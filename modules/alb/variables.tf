variable "routes" {
  type = list(object({
    path = string
    target_group_arn = string
  }))
}

variable "alb_name" {
  type = string
}

variable "certificate_arn" {
  description = "ACM certificate ARN (same region as the ALB) for the HTTPS listener"
  type        = string
}

variable "security_groups_id" {
  type = list(string)
}

variable "subnet_ids" {
  type = list(string)
}

