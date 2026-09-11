provider "aws" {
  region = var.aws_region
}

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

module "private_subnet_az1" {
  source = "./modules/subnet"

  vpc_id                  = module.vpc.vpc_id
  subnet_cidr             = "10.0.1.0/24"
  subnet_name             = "private_subnet_az1"
  availability_zone       = var.az1
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
    module.public_subnet_az1.subnet_id
  ]
}

module "client_website_bucket" {
  source = "./modules/s3-website"

  bucket_name = var.client_website_bucket_name
  environment = var.environment
}

module "restaurant_website_bucket" {
  source = "./modules/s3-website"

  bucket_name = var.restaurant_website_bucket_name
  environment = var.environment
}

module "admin_website_bucket" {
  source = "./modules/s3-website"

  bucket_name = var.admin_website_bucket_name
  environment = var.environment
}


