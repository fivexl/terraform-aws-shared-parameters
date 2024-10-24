# Terraform AWS RAM Resource Share Module
This module is intended to simplify configuration of AWS RAM Resource Share, which allows you to share resources with other AWS accounts.


### Features:
This module will create a RAM Resource Share and associate resources and principals with it using the following resources:
  - aws_ram_resource_share
  - aws_ram_resource_association
  - aws_ram_principal_association

### Usage:
```hcl
module "vpc_ram_resource_share" {
  source = "../../../../modules/external/ram_resource_share"

  name = module.vpc.vpc_id

  resources = concat(
    module.vpc.private_subnet_arns,
    module.vpc.database_subnet_arns,
    module.vpc.public_subnet_arns,
  )
  principals = var.vpc.principals_to_share_with

  tags = module.tags.result
}
```

### Examples:

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~>1.3 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.27.0, < 6.0.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 5.27.0, < 6.0.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_ram_principal_association.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ram_principal_association) | resource |
| [aws_ram_resource_association.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ram_resource_association) | resource |
| [aws_ram_resource_share.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ram_resource_share) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_allow_external_principals"></a> [allow\_external\_principals](#input\_allow\_external\_principals) | (Optional) Indicates whether principals outside your organization can be associated with a resource share. | `bool` | `false` | no |
| <a name="input_name"></a> [name](#input\_name) | (Required) The name of the resource share. | `string` | n/a | yes |
| <a name="input_number_of_resources"></a> [number\_of\_resources](#input\_number\_of\_resources) | The number of resources to associate with the resource share | `number` | `1` | no |
| <a name="input_permission_arns"></a> [permission\_arns](#input\_permission\_arns) | (Optional) Specifies the Amazon Resource Names (ARNs) of the RAM permission to associate with the resource share. If you do not specify an ARN for the permission, RAM automatically attaches the default version of the permission for each resource type. You can associate only one permission with each resource type included in the resource share. | `list(string)` | `null` | no |
| <a name="input_principals"></a> [principals](#input\_principals) | (Required) The principals to associate with the resource share. Possible values are an AWS account ID, an AWS Organizations Organization ARN, or an AWS Organizations Organization Unit ARN. | `list(string)` | n/a | yes |
| <a name="input_resources"></a> [resources](#input\_resources) | (Required) Amazon Resource Name (ARN's) of the resources to associate with the RAM Resource Share. | `list(string)` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | (Optional) Key-value map of resource tags | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_resource_share_arn"></a> [resource\_share\_arn](#output\_resource\_share\_arn) | The Amazon Resource Name (ARN) of the resource share. |
| <a name="output_resource_share_id"></a> [resource\_share\_id](#output\_resource\_share\_id) | The Amazon Resource Name (ARN) of the resource share. |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
