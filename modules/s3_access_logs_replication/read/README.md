# Shared SSM parameter - S3 access logs replication configuration

This module collects data from the s3_access_logs_replication SSM parameter and provides it as outputs.
You would need this information in any account from which you want to replicate access logs to `log-archive` account.
See outputs for more information.

## Usage
```hcl

module "s3_access_logs_replication_configuration_primary" {
  source = "../shared_parameters/s3_access_logs_replication/read"

  resource_owner = var.config.s3_access_logs_bucket_arn_resource_owner
  providers = {
    aws = aws.primary
  }
}

module "s3_server_access_logs_lake_delivery_configuration_primary" {
  source  = "fivexl/s3-server-access-logs-lake/aws//modules/delivery_configuration"
  version = "0.0.1"
  source_bucket_arn      = "arn:aws:s3:::${module.naming_conventions_primary.s3_access_logs_bucket_name}"
  destination_account_id = module.s3_access_logs_replication_configuration_primary.account_id
  destination_bucket_arn = module.s3_access_logs_replication_configuration_primary.bucket_arn

  tags = var.config.tags
  providers              = { aws = aws.primary }
}
```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.0 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_naming_conventions"></a> [naming\_conventions](#module\_naming\_conventions) | fivexl/naming-conventions/aws | 0.0.1 |
| <a name="module_shared_parameter_data"></a> [shared\_parameter\_data](#module\_shared\_parameter\_data) | ../../shared_parameter_data | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_resource_owner"></a> [resource\_owner](#input\_resource\_owner) | The owner of the resource share | `string` | `"OTHER-ACCOUNTS"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_account_id"></a> [account\_id](#output\_account\_id) | The account ID of the owner of the S3 bucket. |
| <a name="output_bucket_arn"></a> [bucket\_arn](#output\_bucket\_arn) | The ARN of the S3 bucket where access logs should be delivered. |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->