# Terraform AWS Shared Parameter Module
This Terraform module simplifies the creation and management of AWS Systems Manager (SSM) parameters and securely shares these resources within an organization using AWS Resource Access Manager (RAM).

### Features:
- Creates SSM parameters with advanced tier settings.
- Shares SSM parameters within your organization using AWS RAM, ensuring that only designated principals specified in the `principals_to_share_with` variable have access to the shared resources.

### Usage:
If you need to share sensitive information across multiple accounts in your organization, you can use this module to create an SSM parameter and share it securely using AWS RAM. One use case is sharing organization information such as the organization ARN, root ID, organization ID, and account IDs across multiple accounts in the organization so that this information is not stored in plain text in your Terraform code.

This module is frequently used in conjunction with the `naming_conventions` and `shared_parameter_data` modules. The `naming_conventions` module is used to generate the name of the SSM parameter (within this module), and afterward, the `shared_parameter_data` module is used to retrieve information for consistency across the Terraform code. Examples of it, you can find in the `/shared_parameters` directory.

### Examples:
```hcl
module "organization_info_shared_parameter" {
  source                   = "../../../../modules/shared_parameter"
  parameter_name           = module.naming_conventions.org_info_ssm_parameter_name
  parameter_description    = "Organization information including ARN, root ID, org ID, and account IDs"
  parameter_key_id         = module.default_kms_key_arn.value
  parameter_value          = jsonencode(local.org_info)
  principals_to_share_with = module.org_entities.created_ous["Security"].arn
  tags                     = module.tags.result

  providers = {
    aws = aws.primary
  }
}


<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 5.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_ram_resource_share"></a> [ram\_resource\_share](#module\_ram\_resource\_share) | ../ram_resource_share | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_ssm_parameter.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_parameter_description"></a> [parameter\_description](#input\_parameter\_description) | Description of the parameter | `string` | n/a | yes |
| <a name="input_parameter_key_id"></a> [parameter\_key\_id](#input\_parameter\_key\_id) | The KMS key id or arn for encrypting the parameter | `string` | n/a | yes |
| <a name="input_parameter_name"></a> [parameter\_name](#input\_parameter\_name) | Name of the parameter | `string` | n/a | yes |
| <a name="input_parameter_type"></a> [parameter\_type](#input\_parameter\_type) | Type of the parameter | `string` | `"SecureString"` | no |
| <a name="input_parameter_value"></a> [parameter\_value](#input\_parameter\_value) | Value of the parameter | `string` | n/a | yes |
| <a name="input_principals_to_share_with"></a> [principals\_to\_share\_with](#input\_principals\_to\_share\_with) | The principals to share the resource with. The format of the principal can be:<br>  an AWS account ID,<br>  an Amazon Resource Name (ARN) of an organization in AWS Organizations,<br>  an ARN of an organizational unit (OU) in AWS Organizations,<br>  an ARN of an IAM role, an ARN of an IAM user,<br>  or a service principal name. | `list(string)` | n/a | yes |
| <a name="input_resource_share_name"></a> [resource\_share\_name](#input\_resource\_share\_name) | Name of the resource share | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to apply to resources | `map(string)` | n/a | yes |

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->