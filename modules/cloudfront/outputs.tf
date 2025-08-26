output "cloudfront_domain_name" {
  description = "The domain name corresponding to the distribution."
  value       = aws_cloudfront_distribution.frontend_distribution.domain_name
}

output "cloudfront_id" {
  description = "The distribution ID."
  value       = aws_cloudfront_distribution.frontend_distribution.id
}

output "cloudfront_arn" {
  description = "The distribution ARN."
  value       = aws_cloudfront_distribution.frontend_distribution.arn
}

output "cloudfront_status" {
  description = "The current status of the distribution. When the status is Deployed, the distribution's information is fully propagated throughout the Amazon CloudFront system."
  value       = aws_cloudfront_distribution.frontend_distribution.status
}

output "cloudfront_hosted_zone_id" {
  description = "The Route 53 Hosted Zone ID of the distribution."
  value       = aws_cloudfront_distribution.frontend_distribution.hosted_zone_id  
}
