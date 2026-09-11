provider "aws" {
  region = var.aws_region
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