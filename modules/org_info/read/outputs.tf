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

output "accounts_by_environment" {
  value       = local.org_info.accounts_by_environment
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


