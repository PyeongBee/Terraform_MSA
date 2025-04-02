output "s3_bucket_id" {
  description = "The ID of S3 Bucket for Web Server"
  value       = aws_s3_bucket.web_server.id
}

output "s3_bucket_domain_name" {
  description = "The ID of S3 Bucket for Web Server"
  value       = aws_s3_bucket.web_server.bucket_regional_domain_name
}
