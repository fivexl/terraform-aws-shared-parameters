output "bucket_arn" {
  value       = local.data.bucket_arn
  description = "The ARN of the S3 bucket where access logs should be delivered."
}

output "account_id" {
  value       = local.data.account_id
  description = "The account ID of the owner of the S3 bucket."
}
