variable "name" {
  type = string
}

variable "description" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "ingress_rules" {
  type = list(object({
    cidr_ipv4                    = optional(string)
    referenced_security_group_id = optional(string)
    from_port                    = number
    ip_protocol                  = string
    to_port                      = number
  }))
}

variable "egress_rules" {
  type = list(object({
    cidr_ipv4                    = optional(string)
    referenced_security_group_id = optional(string)
    ip_protocol                  = string
  }))
}