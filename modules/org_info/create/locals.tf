locals {

  parameter_name      = var.parameter_name != "" ? var.parameter_name : module.naming_conventions.org_info_ssm_parameter_name
  resource_share_name = var.resource_share_name != "" ? var.resource_share_name : module.naming_conventions.org_info_ram_resource_share_name

  all_non_master_accounts = {
    for account in data.aws_organizations_organization.this.non_master_accounts : account.name => {
      id = account.id
    }
  }

  root_id = data.aws_organizations_organization.this.roots[0].id

  org_info = {
    org_arn           = data.aws_organizations_organization.this.arn
    root_id           = local.root_id
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

  ous_info = {
    for ou in local.all_ous : ou.name => {
      id   = ou.id
      name = ou.name
      arn  = ou.arn
      accounts = {
        for acc in try(data.aws_organizations_organizational_unit_child_accounts.accounts[ou.id].accounts, []) :
        acc.name => {
          id = acc.id
        }
      }
    }
  }

  all_ous = concat(
    local.ous_level1,
    local.ous_level2,
    local.ous_level3,
    local.ous_level4,
    local.ous_level5
  )

  ous_level1 = [
    for ou in data.aws_organizations_organizational_units.level1.children : {
      id   = ou.id
      name = ou.name
      arn  = ou.arn
    }
  ]
  ous_level2 = flatten([
    for parent_ou in data.aws_organizations_organizational_units.level2 :
    [
      for ou in parent_ou.children : {
        id   = ou.id
        name = ou.name
        arn  = ou.arn
      }
    ]
  ])
  ous_level3 = flatten([
    for parent_ou in data.aws_organizations_organizational_units.level3 :
    [
      for ou in parent_ou.children : {
        id   = ou.id
        name = ou.name
        arn  = ou.arn
      }
    ]
  ])
  ous_level4 = flatten([
    for parent_ou in data.aws_organizations_organizational_units.level4 :
    [
      for ou in parent_ou.children : {
        id   = ou.id
        name = ou.name
        arn  = ou.arn
      }
    ]
  ])
  ous_level5 = flatten([
    for parent_ou in data.aws_organizations_organizational_units.level5 :
    [
      for ou in parent_ou.children : {
        id   = ou.id
        name = ou.name
        arn  = ou.arn
      }
    ]
  ])
}