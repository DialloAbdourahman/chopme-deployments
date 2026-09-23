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
  value = module.client_website_bucket.cloudfront_distribution_id
}

output "restaurant_website_distribution_id" {
  value = module.restaurant_website_bucket.cloudfront_distribution_id
}

output "admin_website_distribution_id" {
  value = module.admin_website_bucket.cloudfront_distribution_id
}