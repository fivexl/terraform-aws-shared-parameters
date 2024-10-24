output "resource_share_arn" {
  description = "The Amazon Resource Name (ARN) of the resource share."
  value       = aws_ram_resource_share.this.arn
}

output "resource_share_id" {
  description = "The Amazon Resource Name (ARN) of the resource share."
  value       = aws_ram_resource_share.this.id
}