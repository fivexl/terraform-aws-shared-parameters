resource "aws_ram_resource_share" "this" {
  name                      = var.name
  allow_external_principals = var.allow_external_principals
  permission_arns           = var.permission_arns
  tags                      = var.tags
}

resource "aws_ram_resource_association" "this" {
  for_each = var.number_of_resources == 1 ? { "this" : var.resources[0] } : { for p in var.resources : p => p }

  resource_arn       = each.value
  resource_share_arn = aws_ram_resource_share.this.arn
}

resource "aws_ram_principal_association" "this" {
  for_each = { for p in var.principals : p => p }

  principal          = each.value
  resource_share_arn = aws_ram_resource_share.this.arn
}
