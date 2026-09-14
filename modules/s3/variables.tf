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

variable "block_public_access" {
  description = "Block all public access to the bucket (set false to allow public bucket policies/ACLs)"
  type        = bool
  default     = true
}

variable "bucket_policy" {
  description = "Optional bucket policy JSON document to attach to the bucket"
  type        = string
  default     = null
}
