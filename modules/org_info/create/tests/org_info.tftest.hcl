mock_provider "aws" {
  mock_data "aws_organizations_organization" {
    defaults = {
      arn               = "arn:aws:organizations::111111111111:organization/o-testorg123"
      id                = "o-testorg123"
      master_account_id = "111111111111"
      roots = [
        {
          id   = "r-root"
          name = "Root"
          arn  = "arn:aws:organizations::111111111111:root/o-testorg123/r-root"
        }
      ]
      non_master_accounts = [
        {
          id     = "111111111112"
          name   = "development-account"
          arn    = "arn:aws:organizations::111111111111:account/o-testorg123/111111111112"
          email  = "development@example.test"
          status = "ACTIVE"
        },
        {
          id     = "111111111113"
          name   = "production-account"
          arn    = "arn:aws:organizations::111111111111:account/o-testorg123/111111111113"
          email  = "production@example.test"
          status = "ACTIVE"
        },
        {
          id     = "111111111114"
          name   = "staging-account"
          arn    = "arn:aws:organizations::111111111111:account/o-testorg123/111111111114"
          email  = "staging@example.test"
          status = "ACTIVE"
        },
        {
          id     = "111111111115"
          name   = "security-account"
          arn    = "arn:aws:organizations::111111111111:account/o-testorg123/111111111115"
          email  = "security@example.test"
          status = "ACTIVE"
        },
        {
          id     = "111111111116"
          name   = "infrastructure-account"
          arn    = "arn:aws:organizations::111111111111:account/o-testorg123/111111111116"
          email  = "infrastructure@example.test"
          status = "ACTIVE"
        }
      ]
    }
  }

  mock_data "aws_organizations_organizational_units" {
    defaults = { children = [] }
  }
}

# Publishing uses a separate provider with no Organizations mock data.
mock_provider "aws" {
  alias = "publishing"
}

run "discover_populated" {
  command = plan

  module {
    source = "../discover"
  }

  override_data {
    target = data.aws_organizations_organizational_units.level1
    values = {
      children = [
        {
          id   = "ou-root-level001"
          name = "development-apps"
          arn  = "arn:aws:organizations::111111111111:ou/o-testorg123/ou-root-level001"
        }
      ]
    }
  }

  override_data {
    target = data.aws_organizations_organizational_unit_child_accounts.accounts["ou-root-level001"]
    values = {
      accounts = [
        {
          id     = "111111111112"
          name   = "development-account"
          arn    = "arn:aws:organizations::111111111111:account/o-testorg123/111111111112"
          email  = "development@example.test"
          status = "ACTIVE"
        }
      ]
    }
  }

  override_data {
    target = data.aws_organizations_organizational_units.level2["ou-root-level001"]
    values = {
      children = [
        {
          id   = "ou-root-level002"
          name = "production-apps"
          arn  = "arn:aws:organizations::111111111111:ou/o-testorg123/ou-root-level002"
        }
      ]
    }
  }

  override_data {
    target = data.aws_organizations_organizational_unit_child_accounts.accounts["ou-root-level002"]
    values = {
      accounts = [
        {
          id     = "111111111113"
          name   = "production-account"
          arn    = "arn:aws:organizations::111111111111:account/o-testorg123/111111111113"
          email  = "production@example.test"
          status = "ACTIVE"
        }
      ]
    }
  }

  override_data {
    target = data.aws_organizations_organizational_units.level3["ou-root-level002"]
    values = {
      children = [
        {
          id   = "ou-root-level003"
          name = "staging-apps"
          arn  = "arn:aws:organizations::111111111111:ou/o-testorg123/ou-root-level003"
        }
      ]
    }
  }

  override_data {
    target = data.aws_organizations_organizational_unit_child_accounts.accounts["ou-root-level003"]
    values = {
      accounts = [
        {
          id     = "111111111114"
          name   = "staging-account"
          arn    = "arn:aws:organizations::111111111111:account/o-testorg123/111111111114"
          email  = "staging@example.test"
          status = "ACTIVE"
        }
      ]
    }
  }

  override_data {
    target = data.aws_organizations_organizational_units.level4["ou-root-level003"]
    values = {
      children = [
        {
          id   = "ou-root-level004"
          name = "security-apps"
          arn  = "arn:aws:organizations::111111111111:ou/o-testorg123/ou-root-level004"
        }
      ]
    }
  }

  override_data {
    target = data.aws_organizations_organizational_unit_child_accounts.accounts["ou-root-level004"]
    values = {
      accounts = [
        {
          id     = "111111111115"
          name   = "security-account"
          arn    = "arn:aws:organizations::111111111111:account/o-testorg123/111111111115"
          email  = "security@example.test"
          status = "ACTIVE"
        }
      ]
    }
  }

  override_data {
    target = data.aws_organizations_organizational_units.level5["ou-root-level004"]
    values = {
      children = [
        {
          id   = "ou-root-level005"
          name = "infrastructure-apps"
          arn  = "arn:aws:organizations::111111111111:ou/o-testorg123/ou-root-level005"
        }
      ]
    }
  }

  override_data {
    target = data.aws_organizations_organizational_unit_child_accounts.accounts["ou-root-level005"]
    values = {
      accounts = [
        {
          id     = "111111111116"
          name   = "infrastructure-account"
          arn    = "arn:aws:organizations::111111111111:account/o-testorg123/111111111116"
          email  = "infrastructure@example.test"
          status = "ACTIVE"
        }
      ]
    }
  }

  assert {
    condition     = jsonencode(output.org_info) == jsonencode(jsondecode(file("tests/fixtures/org_info.json")))
    error_message = "Discovery must preserve the six fields and account grouping through five OU levels."
  }
}

run "discover_empty" {
  command = plan

  module {
    source = "../discover"
  }

  override_data {
    target = data.aws_organizations_organization.this
    values = {
      arn               = "arn:aws:organizations::111111111111:organization/o-testorg123"
      id                = "o-testorg123"
      master_account_id = "111111111111"
      roots = [
        {
          id   = "r-root"
          name = "Root"
          arn  = "arn:aws:organizations::111111111111:root/o-testorg123/r-root"
        }
      ]
      non_master_accounts = []
    }
  }

  assert {
    condition = jsonencode(output.org_info) == jsonencode(merge(jsondecode(file("tests/fixtures/org_info.json")), {
      accounts = {}
      accounts_by_environment = {
        development = [], production = [], staging = [], security = [], infrastructure = []
      }
    }))
    error_message = "Empty organizations must retain the six-field contract with empty account collections."
  }
}

run "create_default" {
  command = plan

  variables {
    shared_kms_key_arn = "arn:aws:kms:eu-central-1:111111111111:key/00000000-0000-0000-0000-000000000000"
    principals_to_share_with = {
      organization = "arn:aws:organizations::111111111111:organization/o-testorg123"
      security     = "111111111112"
    }
    tags = { Purpose = "org-info-test" }
  }

  assert {
    condition     = length(module.discover) == 1
    error_message = "Omitting org_info must create one discovery instance."
  }

  assert {
    condition = jsonencode(local.org_info) == jsonencode(merge(jsondecode(file("tests/fixtures/org_info.json")), {
      accounts_by_environment = {
        development = [], production = [], staging = [], security = [], infrastructure = []
      }
    }))
    error_message = "Omitting org_info must still discover organization metadata."
  }
}

run "create_reused" {
  command = plan

  variables {
    shared_kms_key_arn = "arn:aws:kms:eu-central-1:111111111111:key/00000000-0000-0000-0000-000000000000"
    principals_to_share_with = {
      organization = "arn:aws:organizations::111111111111:organization/o-testorg123"
      security     = "111111111112"
    }
    tags     = { Purpose = "org-info-test" }
    org_info = run.discover_populated.org_info
  }

  # An accidental Organizations lookup receives no roots and fails.
  providers = { aws = aws.publishing }

  assert {
    condition     = length(module.discover) == 0
    error_message = "Expected 0 discovery instances for create_reused."
  }

  assert {
    condition     = jsonencode(local.org_info) == jsonencode(var.org_info)
    error_message = "Supplied metadata must reach the publishing modules unchanged."
  }
}

run "create_empty" {
  command = plan

  variables {
    shared_kms_key_arn = "arn:aws:kms:eu-central-1:111111111111:key/00000000-0000-0000-0000-000000000000"
    principals_to_share_with = {
      organization = "arn:aws:organizations::111111111111:organization/o-testorg123"
      security     = "111111111112"
    }
    tags     = { Purpose = "org-info-test" }
    org_info = run.discover_empty.org_info
  }

  # An accidental Organizations lookup receives no roots and fails.
  providers = { aws = aws.publishing }

  assert {
    condition     = length(module.discover) == 0
    error_message = "Expected 0 discovery instances for create_empty."
  }

  assert {
    condition     = jsonencode(local.org_info) == jsonencode(var.org_info)
    error_message = "Supplied metadata must reach the publishing modules unchanged."
  }
}

run "create_supplied" {
  command = plan

  variables {
    shared_kms_key_arn = "arn:aws:kms:eu-central-1:111111111111:key/00000000-0000-0000-0000-000000000000"
    principals_to_share_with = {
      organization = "arn:aws:organizations::111111111111:organization/o-testorg123"
      security     = "111111111112"
    }
    tags     = { Purpose = "org-info-test" }
    org_info = merge(run.discover_populated.org_info, { accounts_by_environment = { development = ["111111111112"] } })
  }

  # An accidental Organizations lookup receives no roots and fails.
  providers = { aws = aws.publishing }

  assert {
    condition     = length(module.discover) == 0
    error_message = "Expected 0 discovery instances for create_supplied."
  }

  assert {
    condition     = jsonencode(local.org_info) == jsonencode(var.org_info)
    error_message = "Supplied metadata must reach the publishing modules unchanged."
  }
}
