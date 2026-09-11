variable "environment" {
  description = "The environment of this project"
  type        = string
}

variable "aws_region" {
  description = "The region to use for our project"
  type        = string
}

variable "client_website_bucket_name" {
  description = "The bucket name of the client website"
  type        = string
}

variable "restaurant_website_bucket_name" {
  description = "The bucket name of the restaurant website"
  type        = string
}

variable "admin_website_bucket_name" {
  description = "The bucket name of the admin website"
  type        = string
}

variable "vpc_name" {
  description = "Name of the vpc"
  type        = string
}

variable "vpc_cidr" {
  description = "Name of the VPC"
  type        = string
}

variable "az1" {
  description = "Name of the VPC"
  type        = string
}
