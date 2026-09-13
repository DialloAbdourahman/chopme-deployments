variable "cluster_name" {
  description = "ECS cluster name"
  type        = string
}

variable "service_name" {
  description = "ECS service name"
  type        = string
}

variable "task_definition_family" {
  description = "ECS task definition family"
  type        = string
}

variable "container_name" {
  description = "Container name"
  type        = string
}

variable "container_image" {
  description = "Full container image URL including tag"
  type        = string
}

variable "container_port" {
  description = "Container port"
  type        = number
}

variable "cpu" {
  description = "Task CPU units"
  type        = number
  default     = 512
}

variable "memory" {
  description = "Task memory in MiB"
  type        = number
  default     = 1024
}

variable "desired_count" {
  description = "Desired number of running tasks"
  type        = number
  default     = 1
}

variable "execution_role_arn" {
  description = "IAM role ARN used as the task execution role"
  type        = string
}

variable "task_role_arn" {
  description = "IAM role ARN assumed by the running containers"
  type        = string
  default     = null
}

variable "aws_region" {
  description = "AWS region used by the awslogs driver"
  type        = string
}

variable "log_retention_days" {
  description = "CloudWatch log group retention in days"
  type        = number
  default     = 30
}

variable "subnet_ids" {
  description = "Subnet IDs for the ECS service"
  type        = list(string)
}

variable "security_group_ids" {
  description = "Security group IDs for the ECS service"
  type        = list(string)
}

variable "assign_public_ip" {
  description = "Assign a public IP to tasks"
  type        = bool
  default     = true
}

variable "ecs_target_group_arn" {
  description = "Full container image URL including tag"
  type        = string
}

