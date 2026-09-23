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

variable "force_destroy" {
  description = "Website error document"
  type        = bool
}

variable "domain_aliases" {
  description = "Custom domain aliases for the CloudFront distribution (requires certificate_arn)"
  type        = list(string)
  default     = []
}

variable "certificate_arn" {
  description = "ACM certificate ARN (must be in us-east-1) covering the domain alias"
  type        = string
  default     = null
}

