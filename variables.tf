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

variable "az2" {
  description = "Name of the VPC"
  type        = string
}

variable "ecr_repository_name" {
  description = "Name of the cluster"
  type        = string
}

variable "ecr_repository_mutability" {
  description = "Name of the cluster"
  type        = string
}

variable "ecr_repository_retention_count" {
  description = "Name of the cluster"
  type        = number
}

variable "ecs_cluster_name" {
  description = "Name of the cluster"
  type        = string
}

variable "ecs_task_definition_family" {
  description = "Name of the cluster"
  type        = string
}

variable "ecs_task_definition_container_name" {
  description = "Name of the cluster"
  type        = string
}

variable "ecs_task_definition_container_tag" {
  description = "Name of the cluster"
  type        = string
}

variable "ecs_task_definition_container_port" {
  description = "Name of the cluster"
  type        = number
}

variable "ecs_service_name" {
  description = "Name of the cluster"
  type        = string
}

variable "ecs_service_desired_count" {
  description = "Name of the cluster"
  type        = number
}

variable "force_destroy" {
  description = "Name of the cluster"
  type        = bool
}

variable "docdb_name" {
  description = "DocumentDB master username"
  type        = string
}

variable "docdb_master_username" {
  description = "DocumentDB master username"
  type        = string
}

variable "docdb_master_password" {
  description = "DocumentDB master password"
  type        = string
  sensitive   = true
}

variable "docdb_instance_class" {
  description = "DocumentDB instance class"
  type        = string
}

variable "docdb_instance_count" {
  description = "DocumentDB instance class"
  type        = number
}

variable "docdb_backup_retention_period" {
  description = "DocumentDB instance class"
  type        = number
}

variable "docdb_preferred_backup_window" {
  description = "DocumentDB instance class"
  type        = string
}

variable "docdb_preferred_maintenance_window" {
  description = "DocumentDB instance class"
  type        = string
}

variable "docdb_skip_final_snapshot" {
  description = "DocumentDB instance class"
  type        = bool
}