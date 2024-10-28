output "org_arn" {
  value       = local.org_info.org_arn
  description = "The ARN of the organization"
}

output "root_id" {
  value       = local.org_info.root_id
  description = "The ID of the organization's root"
}

output "org_id" {
  value       = local.org_info.org_id
  description = "The ID of the organization"
}

output "environment_accounts" {
  value       = local.org_info.environment_accounts
  description = "List of account IDs for each environment"
}

output "master_account_id" {
  value       = local.org_info.master_account_id
  description = "The ID of the organization's master account"
}

output "accounts" {
  value       = local.org_info.accounts
  description = "The IDs of the organization's accounts, master account is excluded from the list."
}

output "ous" {
  value       = local.org_info.ous
  description = <<EOT
  The organizational units (OUs) in the organization. The key is the name of the OU and the value is a map with the following attributes:
  - id
  - arn
  - accounts: A list of account IDs that are in the OU (including nested OUs)
  EOT
}
