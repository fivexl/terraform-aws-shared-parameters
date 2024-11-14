module "naming_conventions" {
  source  = "fivexl/naming-convetions/aws"
  version = "0.0.1"
}

data "aws_organizations_organization" "this" {}


locals {

  all_non_master_accounts= {
    for account in data.aws_organizations_organization.this.non_master_accounts : account.name => {
      id = account.id
    }
  }

  org_info = {
    org_arn           = data.aws_organizations_organization.this.arn
    root_id           = data.aws_organizations_organization.this.roots[0].id
    org_id            = data.aws_organizations_organization.this.id
    master_account_id = data.aws_organizations_organization.this.master_account_id
    accounts          = local.all_non_master_accounts
    ous               = local.ous_info

    environment_accounts = {
      for prefix in ["development", "production", "staging", "security", "infrastructure"] :
      prefix => compact(flatten([
        for ou_key, ou in local.ous_info :
        [
          for _, account in ou.accounts :
          account.id
        ]
        if can(regex("^${prefix}", ou.name))
      ]))
    }
  }
}

module "shared_parameter" {
  source = "../../shared_parameter"

  parameter_name           = module.naming_conventions.org_info_ssm_parameter_name
  resource_share_name      = module.naming_conventions.org_info_ram_resource_share_name
  parameter_description    = "Organization information including ARN, root ID, org ID, and account IDs"
  parameter_key_id         = var.shared_kms_key_arn
  parameter_value          = jsonencode(local.org_info)
  principals_to_share_with = var.principals_to_share_with

  tags = var.tags
}
