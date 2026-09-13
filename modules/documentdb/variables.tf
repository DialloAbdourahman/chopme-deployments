variable "name" {
  description = "Base name for the DocumentDB cluster resources"
  type        = string
}

variable "environment" {
  description = "Deployment environment"
  type        = string
}

variable "vpc_id" {
  description = "VPC where the cluster lives"
  type        = string
}

variable "subnet_ids" {
  description = "Private subnet IDs used by the cluster subnet group"
  type        = list(string)
}

variable "allowed_security_group_ids" {
  description = "Security groups allowed to reach the cluster on port 27017"
  type        = list(string)
}

variable "master_username" {
  description = "Master username"
  type        = string
}

variable "master_password" {
  description = "Master password"
  type        = string
  sensitive   = true
}

variable "instance_class" {
  description = "Instance class for cluster instances"
  type        = string
  default     = "db.t4g.medium"
}

variable "instance_count" {
  description = "Number of instances in the cluster"
  type        = number
  default     = 1
}

variable "backup_retention_period" {
  description = "Backup retention period in days"
  type        = number
  default     = 7
}

variable "preferred_backup_window" {
  description = "Preferred backup window"
  type        = string
  default     = "02:00-04:00"
}

variable "preferred_maintenance_window" {
  description = "Preferred maintenance window"
  type        = string
  default     = "Mon:04:00-Mon:06:00"
}

variable "skip_final_snapshot" {
  description = "Skip final snapshot on destroy"
  type        = bool
  default     = true
}

variable "final_snapshot_identifier" {
  description = "Name of the final snapshot taken on destroy (required when skip_final_snapshot is false)"
  type        = string
  default     = null
}

variable "deletion_protection" {
  description = "Prevent the cluster from being deleted"
  type        = bool
  default     = false
}
