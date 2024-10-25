data "aws_organizations_organizational_units" "level1" {
  parent_id = local.root_id
}

data "aws_organizations_organizational_units" "level2" {
  for_each  = { for ou in local.ous_level1 : ou.id => ou }
  parent_id = each.key
}

data "aws_organizations_organizational_units" "level3" {
  for_each  = { for ou in local.ous_level2 : ou.id => ou }
  parent_id = each.key
}

data "aws_organizations_organizational_units" "level4" {
  for_each  = { for ou in local.ous_level3 : ou.id => ou }
  parent_id = each.key
}

data "aws_organizations_organizational_units" "level5" {
  for_each  = { for ou in local.ous_level4 : ou.id => ou }
  parent_id = each.key
}

data "aws_organizations_organizational_unit_child_accounts" "accounts" {
  for_each  = { for ou in local.all_ous : ou.id => ou }
  parent_id = each.key
}


locals {
  root_id = data.aws_organizations_organization.this.roots[0].id
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
  all_ous = concat(
    local.ous_level1,
    local.ous_level2,
    local.ous_level3,
    local.ous_level4,
    local.ous_level5
  )

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
}
