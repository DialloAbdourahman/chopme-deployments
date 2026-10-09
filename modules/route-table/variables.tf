variable "vpc_id" {
  type = string
}
variable "name" {
  type = string
}
variable "igw_id" {
  type    = string
  default = ""
}
variable "destination_cidr_block" {
  type = string
  default = ""
}
variable "nat_gateway_id" {
  type    = string
  default = ""
}
variable "subnet_ids" {
  type = list(string)
}