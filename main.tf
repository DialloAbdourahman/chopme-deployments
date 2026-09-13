
# ============================================================
# PROVIDER
# ============================================================
provider "aws" {
  region = var.aws_region
}

# ============================================================
# VPC, SUBNETS and ROUTE TABLES
# ============================================================
module "vpc" {
  source = "./modules/vpc"

  vpc_name = var.vpc_name
  vpc_cidr = var.vpc_cidr
  add_igw  = true
}

module "public_subnet_az1" {
  source = "./modules/subnet"

  vpc_id                  = module.vpc.vpc_id
  subnet_cidr             = "10.0.0.0/24"
  subnet_name             = "public_subnet_az1"
  availability_zone       = var.az1
  map_public_ip_on_launch = true
}

module "public_subnet_az2" {
  source = "./modules/subnet"

  vpc_id                  = module.vpc.vpc_id
  subnet_cidr             = "10.0.1.0/24"
  subnet_name             = "public_subnet_az2"
  availability_zone       = var.az2
  map_public_ip_on_launch = true
}

module "private_subnet_az1" {
  source = "./modules/subnet"

  vpc_id                  = module.vpc.vpc_id
  subnet_cidr             = "10.0.2.0/24"
  subnet_name             = "private_subnet_az1"
  availability_zone       = var.az1
  map_public_ip_on_launch = false
}

module "private_subnet_az2" {
  source = "./modules/subnet"

  vpc_id                  = module.vpc.vpc_id
  subnet_cidr             = "10.0.3.0/24"
  subnet_name             = "private_subnet_az2"
  availability_zone       = var.az2
  map_public_ip_on_launch = false
}

module "public_route_table" {
  source = "./modules/route-table"

  vpc_id                 = module.vpc.vpc_id
  igw_id                 = module.vpc.igw_id
  name                   = "public_route_table"
  destination_cidr_block = "0.0.0.0/0"
  vpc_cidr_block         = var.vpc_cidr
  subnet_ids = [
    module.public_subnet_az1.subnet_id, module.public_subnet_az2.subnet_id
  ]
}

# ============================================================
# ROLES
# ============================================================
module "chopme_backend_role" {
  source            = "./modules/iam-role"
  name              = "backend-role"
  service_principal = "ecs-tasks.amazonaws.com"

  policy_arns = [
    "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
  ]

 
}

# Role assumed by the running containers (task role)
module "chopme_backend_task_role" {
  source            = "./modules/iam-role"
  name              = "backend-task-role"
  service_principal = "ecs-tasks.amazonaws.com"

  inline_policies = {
    "s3-images-access" = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Effect = "Allow"
          Action = [
            "s3:GetObject",
            "s3:PutObject",
            "s3:DeleteObject"
          ]
          Resource = "${module.backend_images_bucket.bucket_arn}/*"
        }
      ]
    })
  }
}

# ============================================================
# SECURITY GROUPS
# ============================================================

module "alb_security_group" {
  source = "./modules/security-group"

  name        = "alb_security_group"
  description = "Security group for the public ALB"
  vpc_id      = module.vpc.vpc_id
  ingress_rules = [
    {
      cidr_ipv4   = "0.0.0.0/0"
      from_port   = 80
      ip_protocol = "tcp"
      to_port     = 80
    }
  ]
  egress_rules = [
    {
      cidr_ipv4   = "0.0.0.0/0"
      ip_protocol = "-1"
    }
  ]
}

module "backend_security_group" {
  source = "./modules/security-group"

  name        = "backend_security_group"
  description = "Security group for HTTP and SSH"
  vpc_id      = module.vpc.vpc_id
  ingress_rules = [
    {
      referenced_security_group_id = module.alb_security_group.security_group_id
      from_port                    = var.ecs_task_definition_container_port
      ip_protocol                  = "tcp"
      to_port                      = var.ecs_task_definition_container_port
    }
  ]
  egress_rules = [
    {
      cidr_ipv4   = "0.0.0.0/0"
      ip_protocol = "-1"
    }
  ]
}

# ============================================================
# S3 WEBSITES
# ============================================================
module "client_website_bucket" {
  source = "./modules/s3-website"

  bucket_name = var.client_website_bucket_name
  environment = terraform.workspace

  force_destroy = var.force_destroy
}

module "restaurant_website_bucket" {
  source = "./modules/s3-website"

  bucket_name = var.restaurant_website_bucket_name
  environment = terraform.workspace

  force_destroy = var.force_destroy
}

module "admin_website_bucket" {
  source = "./modules/s3-website"

  bucket_name = var.admin_website_bucket_name
  environment = terraform.workspace

  force_destroy = var.force_destroy
}

# ============================================================
# ECR REPOSITORY
# ============================================================
module "ecr" {
  source = "./modules/ecr"

  name            = var.ecr_repository_name
  mutability      = var.ecr_repository_mutability
  retention_count = var.ecr_repository_retention_count
  environment     = terraform.workspace
  force_destroy   = var.force_destroy
}

module "ecs_chopme_backend" {
  source = "./modules/ecs_task_and_service"

  cluster_name           = var.ecs_cluster_name
  service_name           = var.ecs_service_name
  task_definition_family = var.ecs_task_definition_family
  container_name         = var.ecs_task_definition_container_name
  container_image        = "${module.ecr.repository_url}:${var.ecs_task_definition_container_tag}"
  container_port         = var.ecs_task_definition_container_port
  desired_count          = var.ecs_service_desired_count

  cpu                = 512
  memory             = 1024
  log_retention_days = 30
  assign_public_ip   = true

  execution_role_arn = module.chopme_backend_role.role_arn
  aws_region         = var.aws_region

  subnet_ids         = [module.public_subnet_az1.subnet_id]
  security_group_ids = [module.backend_security_group.security_group_id]

  ecs_target_group_arn = module.backend_target_group.target_group_arn
  task_role_arn        = module.chopme_backend_task_role.role_arn
}

# ============================================================
# S3 BUCKET (backend images, private - presigned URL access)
# ============================================================
module "backend_images_bucket" {
  source = "./modules/s3"

  bucket_name  = var.s3_public_bucket_name
  environment  = terraform.workspace
  force_destroy = var.force_destroy

  cors_allowed_origins = ["*"]
}

# ============================================================
# ALB + TARGET GROUP
# ============================================================
module "backend_target_group" {
  source = "./modules/target-group"

  vpc_id                         = module.vpc.vpc_id
  target_group_name              = "chopme-${terraform.workspace}-backend-tg"
  target_group_port              = var.ecs_task_definition_container_port
  target_group_protocol          = "HTTP"
  target_group_health_check_path = "/api"
  target_type                    = "ip"
}

module "alb" {
  source = "./modules/alb"

  alb_name           = "chopme-${terraform.workspace}-alb"
  alb_port           = 80
  alb_protocol       = "HTTP"
  security_groups_id = [module.alb_security_group.security_group_id]
  subnet_ids = [
    module.public_subnet_az1.subnet_id,
    module.public_subnet_az2.subnet_id
  ]

  routes = [
    {
      path             = "/*"
      target_group_arn = module.backend_target_group.target_group_arn
    }
  ]
}

# ============================================================
# DOCUMENTDB
# ============================================================

module "documentdb" {
  source = "./modules/documentdb"

  name        = var.docdb_name
  environment = terraform.workspace

  vpc_id     = module.vpc.vpc_id
  subnet_ids = [module.private_subnet_az1.subnet_id, module.private_subnet_az2.subnet_id]

  allowed_security_group_ids = [module.backend_security_group.security_group_id]

  master_username = var.docdb_master_username
  master_password = var.docdb_master_password
  instance_class  = var.docdb_instance_class
  instance_count  = var.docdb_instance_count

  backup_retention_period      = var.docdb_backup_retention_period
  preferred_backup_window      = var.docdb_preferred_backup_window
  preferred_maintenance_window = var.docdb_preferred_maintenance_window

  skip_final_snapshot       = var.docdb_skip_final_snapshot
  final_snapshot_identifier = var.docdb_final_snapshot_identifier
  deletion_protection       = var.docdb_deletion_protection

  storage_encrypted = var.docdb_encrypt_storage
}