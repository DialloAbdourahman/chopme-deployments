# ============================================================
# FRONTEND WEBSITES
# ============================================================
output "client_website_url" {
  value       = "https://${var.client_website_domains[0]}"
  description = "Public URL of the client website"
}

output "restaurant_website_url" {
  value       = "https://${var.restaurant_website_domains[0]}"
  description = "Public URL of the restaurant website"
}

output "admin_website_url" {
  value       = "https://${var.admin_website_domains[0]}"
  description = "Public URL of the admin website"
}

output "client_website_cloudfront_domain" {
  value = module.client_website_bucket.cloudfront_domain_name
}

output "restaurant_website_cloudfront_domain" {
  value = module.restaurant_website_bucket.cloudfront_domain_name
}

output "admin_website_cloudfront_domain" {
  value = module.admin_website_bucket.cloudfront_domain_name
}

output "client_website_distribution_id" {
  value       = module.client_website_bucket.cloudfront_distribution_id
  description = "CloudFront distribution ID (needed for cache invalidation after deploys)"
}

output "restaurant_website_distribution_id" {
  value       = module.restaurant_website_bucket.cloudfront_distribution_id
  description = "CloudFront distribution ID (needed for cache invalidation after deploys)"
}

output "admin_website_distribution_id" {
  value       = module.admin_website_bucket.cloudfront_distribution_id
  description = "CloudFront distribution ID (needed for cache invalidation after deploys)"
}

# ============================================================
# BACKEND API
# ============================================================
output "api_url" {
  value       = "https://${var.api_domain}"
  description = "Public URL of the backend API"
}

output "alb_dns_name" {
  value       = module.alb.alb_dns_name
  description = "ALB DNS name (origin of the API domain)"
}

# ============================================================
# ECS / ECR
# ============================================================
output "ecr_repository_url" {
  value       = module.ecr.repository_url
  description = "ECR repository URL to push backend images to"
}

output "ecs_cluster_name" {
  value       = module.ecs_chopme_backend.cluster_name
  description = "ECS cluster name"
}

output "ecs_service_name" {
  value       = module.ecs_chopme_backend.service_name
  description = "ECS service name (use with aws ecs update-service for deploys)"
}

output "ecs_log_group_name" {
  value       = module.ecs_chopme_backend.log_group_name
  description = "CloudWatch log group for the backend containers"
}

# ============================================================
# DATABASE
# ============================================================
output "docdb_endpoint" {
  value       = module.documentdb.endpoint
  description = "DocumentDB cluster writer endpoint"
}

output "docdb_port" {
  value       = module.documentdb.port
  description = "DocumentDB port"
}

# ============================================================
# STORAGE
# ============================================================
output "backend_public_bucket_name" {
  value       = module.backend_public_bucket.bucket_name
  description = "S3 bucket used by the backend for public images"
}