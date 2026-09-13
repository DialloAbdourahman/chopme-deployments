variable "bucket_name" {
  description = "Name of the S3 bucket"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "force_destroy" {
  description = "Allow destroying the bucket even when it contains objects"
  type        = bool
  default     = false
}

variable "enable_versioning" {
  description = "Enable object versioning on the bucket"
  type        = bool
  default     = false
}

variable "cors_allowed_origins" {
  description = "Origins allowed to call presigned URLs from the browser"
  type        = list(string)
  default     = ["*"]
}
