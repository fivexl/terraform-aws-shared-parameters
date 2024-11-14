data "aws_organizations_organization" "this" {}

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