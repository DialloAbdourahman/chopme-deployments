variable "bucket_name" {
  description = "Name of the S3 website bucket"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "index_document" {
  description = "Website index document"
  type        = string
  default     = "index.html"
}

variable "error_document" {
  description = "Website error document"
  type        = string
  default     = "index.html"
}