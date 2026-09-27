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

variable "domain_name" {
  description = "Route53 hosted zone name (e.g. chopmeapp.com)"
  type        = string
}

variable "client_website_domains" {
  description = "Custom domains for the client website (e.g. [\"client.dev.chopmeapp.com\"])"
  type        = list(string)
}

variable "restaurant_website_domains" {
  description = "Custom domains for the restaurant website (e.g. [\"restaurant.dev.chopmeapp.com\"])"
  type        = list(string)
}

variable "admin_website_domains" {
  description = "Custom domains for the admin website (e.g. [\"admin.dev.chopmeapp.com\"])"
  type        = list(string)
}

variable "api_domain" {
  description = "Custom domain for the backend API / ALB (e.g. api.dev.chopmeapp.com)"
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

variable "ecs_service_autoscaling_enabled" {
  description = "Enable autoscaling for the ECS service"
  type        = bool
  default     = true
}

variable "ecs_service_autoscaling_min_capacity" {
  description = "Minimum number of tasks when autoscaling"
  type        = number
  default     = 2
}

variable "ecs_service_autoscaling_max_capacity" {
  description = "Maximum number of tasks when autoscaling"
  type        = number
  default     = 6
}

variable "ecs_service_autoscaling_cpu_target" {
  description = "Target average CPU utilization percentage for scaling"
  type        = number
  default     = 60
}

variable "ecs_service_autoscaling_memory_target" {
  description = "Target average memory utilization percentage for scaling"
  type        = number
  default     = 70
}

variable "ecs_service_autoscaling_scale_in_cooldown" {
  description = "Seconds to wait before scaling in again"
  type        = number
  default     = 300
}

variable "ecs_service_autoscaling_scale_out_cooldown" {
  description = "Seconds to wait before scaling out again"
  type        = number
  default     = 60
}

variable "force_destroy" {
  description = "Name of the cluster"
  type        = bool
}

variable "s3_public_bucket_name" {
  description = "Bucket used by the backend for restaurant/menu images"
  type        = string
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
  description = "Skip the final snapshot when destroying the DocumentDB cluster (true for dev, false for prod)"
  type        = bool
  default     = true
}

variable "docdb_deletion_protection" {
  description = "Skip the final snapshot when destroying the DocumentDB cluster (true for dev, false for prod)"
  type        = bool
  default     = true
}

variable "docdb_snapshot_identifier" {
  description = "Snapshot identifier to restore the DocumentDB cluster from (null creates a fresh cluster)"
  type        = string
  default     = null
}

variable "docdb_encrypt_storage" {
  description = "Encrypt the DocumentDB cluster storage at rest"
  type        = bool
  default     = true
}

