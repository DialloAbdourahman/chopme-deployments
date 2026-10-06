
# ============================================================
# PROVIDER
# ============================================================
provider "aws" {
  region = var.aws_region
}

# CloudFront certificates must be created in us-east-1
provider "aws" {
  alias  = "us_east_1"
  region = "us-east-1"
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
          Resource = "${module.backend_public_bucket.bucket_arn}/*"
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
    },
    {
      cidr_ipv4   = "0.0.0.0/0"
      from_port   = 443
      ip_protocol = "tcp"
      to_port     = 443
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

  force_destroy = var.force_destroy_websites

  domain_aliases  = var.client_website_domains
  certificate_arn = aws_acm_certificate_validation.websites.certificate_arn
}

module "restaurant_website_bucket" {
  source = "./modules/s3-website"

  bucket_name = var.restaurant_website_bucket_name
  environment = terraform.workspace

  force_destroy = var.force_destroy_websites

  domain_aliases  = var.restaurant_website_domains
  certificate_arn = aws_acm_certificate_validation.websites.certificate_arn
}

module "admin_website_bucket" {
  source = "./modules/s3-website"

  bucket_name = var.admin_website_bucket_name
  environment = terraform.workspace

  force_destroy = var.force_destroy_websites

  domain_aliases  = var.admin_website_domains
  certificate_arn = aws_acm_certificate_validation.websites.certificate_arn
}

# ============================================================
# DNS + CERTIFICATE (Route53 hosted zone must already exist)
# ============================================================
data "aws_route53_zone" "main" {
  name         = var.domain_name
  private_zone = false
}

locals {
  all_website_domains = concat(
    var.client_website_domains,
    var.restaurant_website_domains,
    var.admin_website_domains,
  )
}

# One cert covering all website domains
resource "aws_acm_certificate" "websites" {
  provider = aws.us_east_1

  domain_name               = local.all_website_domains[0]
  subject_alternative_names = slice(local.all_website_domains, 1, length(local.all_website_domains))

  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "websites_cert_validation" {
  for_each = {
    for dvo in aws_acm_certificate.websites.domain_validation_options : dvo.domain_name => dvo
  }

  zone_id         = data.aws_route53_zone.main.zone_id
  name            = each.value.resource_record_name
  type            = each.value.resource_record_type
  records         = [each.value.resource_record_value]
  ttl             = 60
  allow_overwrite = true
}

resource "aws_acm_certificate_validation" "websites" {
  provider = aws.us_east_1

  certificate_arn         = aws_acm_certificate.websites.arn
  validation_record_fqdns = [for r in aws_route53_record.websites_cert_validation : r.fqdn]
}

locals {
  website_distributions = {
    client     = module.client_website_bucket
    restaurant = module.restaurant_website_bucket
    admin      = module.admin_website_bucket
  }

  website_domains = {
    client     = var.client_website_domains
    restaurant = var.restaurant_website_domains
    admin      = var.admin_website_domains
  }

  website_alias_records = merge([
    for site, domains in local.website_domains : merge([
      for d in domains : {
        "${site}-${d}-a" = {
          domain = d
          type   = "A"
          target = local.website_distributions[site].cloudfront_domain_name
          zone   = local.website_distributions[site].cloudfront_hosted_zone_id
        }
        "${site}-${d}-aaaa" = {
          domain = d
          type   = "AAAA"
          target = local.website_distributions[site].cloudfront_domain_name
          zone   = local.website_distributions[site].cloudfront_hosted_zone_id
        }
      }
    ]...)
  ]...)
}

resource "aws_route53_record" "website_aliases" {
  for_each = local.website_alias_records

  zone_id = data.aws_route53_zone.main.zone_id
  name    = each.value.domain
  type    = each.value.type

  alias {
    name                   = each.value.target
    zone_id                = each.value.zone
    evaluate_target_health = false
  }
}

# ALB cert lives in the ALB's region (not us-east-1)
resource "aws_acm_certificate" "api" {
  domain_name       = var.api_domain
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "api_cert_validation" {
  for_each = {
    for dvo in aws_acm_certificate.api.domain_validation_options : dvo.domain_name => dvo
  }

  zone_id         = data.aws_route53_zone.main.zone_id
  name            = each.value.resource_record_name
  type            = each.value.resource_record_type
  records         = [each.value.resource_record_value]
  ttl             = 60
  allow_overwrite = true
}

resource "aws_acm_certificate_validation" "api" {
  certificate_arn         = aws_acm_certificate.api.arn
  validation_record_fqdns = [for r in aws_route53_record.api_cert_validation : r.fqdn]
}

resource "aws_route53_record" "api" {
  for_each = toset(["A", "AAAA"])

  zone_id = data.aws_route53_zone.main.zone_id
  name    = var.api_domain
  type    = each.value

  alias {
    name                   = module.alb.alb_dns_name
    zone_id                = module.alb.alb_zone_id
    evaluate_target_health = false
  }
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
  force_destroy   = var.force_destroy_ecr
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

  subnet_ids         = [module.public_subnet_az1.subnet_id, module.public_subnet_az2.subnet_id]
  security_group_ids = [module.backend_security_group.security_group_id]

  ecs_target_group_arn = module.backend_target_group.target_group_arn
  task_role_arn        = module.chopme_backend_task_role.role_arn

  enable_autoscaling             = var.ecs_service_autoscaling_enabled
  autoscaling_min_capacity       = var.ecs_service_autoscaling_min_capacity
  autoscaling_max_capacity       = var.ecs_service_autoscaling_max_capacity
  autoscaling_cpu_target         = var.ecs_service_autoscaling_cpu_target
  autoscaling_memory_target      = var.ecs_service_autoscaling_memory_target
  autoscaling_scale_in_cooldown  = var.ecs_service_autoscaling_scale_in_cooldown
  autoscaling_scale_out_cooldown = var.ecs_service_autoscaling_scale_out_cooldown
}

# ============================================================
# S3 BUCKET and GATEWAY ENDPOINT
# ============================================================
module "backend_public_bucket" {
  source = "./modules/s3"

  bucket_name   = var.s3_public_bucket_name
  environment   = terraform.workspace
  force_destroy = var.force_destroy_public_s3_backend_bucket

  cors_allowed_origins = ["*"]
  enable_versioning = true

  block_public_access = false
  bucket_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "PublicRead"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource  = "arn:aws:s3:::${var.s3_public_bucket_name}/*"
      }
    ]
  })
}

resource "aws_vpc_endpoint" "s3_gateway_endpoint" {
  vpc_id            = module.vpc.vpc_id
  service_name      = "com.amazonaws.${var.aws_region}.s3"
  vpc_endpoint_type = "Gateway"

  route_table_ids = [ module.public_route_table.route_table_id ]

  tags = { Name = "chopme-${terraform.workspace}-s3-gateway-endpoint" }
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
  target_group_health_check_path = "/api/health"
  target_type                    = "ip"
}

module "alb" {
  source = "./modules/alb"

  alb_name           = "chopme-${terraform.workspace}-alb"
  certificate_arn    = aws_acm_certificate_validation.api.certificate_arn
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

  skip_final_snapshot = var.docdb_skip_final_snapshot
  snapshot_identifier = var.docdb_snapshot_identifier

  deletion_protection = var.docdb_deletion_protection

  storage_encrypted = var.docdb_encrypt_storage

}