variable "name" {
  description = "Repository name"
  type        = string
}

variable "mutability" {
  description = "Image tag mutability setting"
  type        = string
}

variable "retention_count" {
  description = "Number of images to keep before the expire action applies"
  type        = number
}

variable "environment" {
  description = "Deployment environment"
  type        = string
}

variable "force_destroy" {
  description = "Delete the repository even if it contains images"
  type        = bool
  default     = false
}
