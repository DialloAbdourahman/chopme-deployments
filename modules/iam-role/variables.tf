variable "name" {
  type = string
}

variable "service_principal" {
  type    = string
  default = "ec2.amazonaws.com"
}

variable "policy_arns" {
  type    = list(string)
  default = []
}

variable "inline_policies" {
  description = "Map of inline policy names to JSON policy documents"
  type        = map(string)
  default     = {}
}