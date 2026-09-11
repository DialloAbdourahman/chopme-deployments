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

