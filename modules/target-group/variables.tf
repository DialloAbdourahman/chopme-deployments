variable "vpc_id" {
  type = string
}

variable "target_group_name" {
  type = string
}

variable "target_group_port" {
  type = number
}

variable "target_group_protocol" {
  type = string
}

variable "target_group_health_check_path" {
  type = string
  default = "/"
}

variable "target_type" {
  type    = string
  default = "ip"
}