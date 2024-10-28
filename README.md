# Terraform AWS Shared Parameters Module
The main purpose of this module is to simplify and centralize the creation of shared parameters in AWS Systems Manager (SSM) Parameter Store and share them across multiple accounts in your AWS organization using AWS Resource Access Manager (RAM).

## Features:
- To create a RAM resource share, such as for a VPC, you can use the /ram_resource_share module.
- To create an SSM parameter that will be shared with specified principals via RAM, you can use the /shared_parameter module.
- To read the value of the shared SSM parameter created with the /shared_parameter module, you can use the /shared_parameter_data module.
- Both /shared_parameter and /shared_parameter_data are used in the /modules/shared_parameters directory to create and read shared SSM parameters.
- You can use the /modules/*  to create and read multiple shared SSM parameters across your organization, including:
- Chatbot topic ARN (shared with the entire Organization, allowing all accounts to send notifications to the chatbot)
- KMS key ARN (shared with the entire Organization, allowing all accounts to encrypt/decrypt shared resources, such as shared SSM parameters)
- Default KMS key ARN (recommended for every environment, enabling all accounts to encrypt/decrypt environment-specific resources such as dev, test, and prod)
- S3 access logs replication module to create a shared SSM parameter with the necessary configuration for setting up access logs replication from any account to the logs archive account
- Org info module to create a shared SSM parameter containing organization information, including:
  - Organization ID
  - Organization ARN
  - Organization Master Account ID
  - OU IDs and other relevant information
  - List of account names and IDs


Most of the modules in the `/modules/*` are dependent on the other modules, for example:
  - chat_bot_topic_arn depends on shared_kms_key_arn and org_info parameters. 
So please make sure to see more information inside of the module, and create the dependent parameters before using the module.


## Review Links

- [Review recent changes](https://github.com/fivexl/terraform-aws-shared-parameters/compare/main@%7B7day%7D...main)
- [Branch-based review](https://github.com/fivexl/terraform-aws-shared-parameters/compare/review...main)
