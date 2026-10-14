"""Run mocked plans and check the public discovery and publishing contract."""

import json
from pathlib import Path
import subprocess
import sys


ROOT = Path(__file__).resolve().parent.parent
ORG_INFO = json.loads((ROOT / "tests/fixtures/org_info.json").read_text())
EMPTY_ENVIRONMENTS = {name: [] for name in ORG_INFO["accounts_by_environment"]}
EMPTY_ORG_INFO = {**ORG_INFO, "accounts": {}, "accounts_by_environment": EMPTY_ENVIRONMENTS}
EXPECTED = {
    "discover_populated": ORG_INFO,
    "discover_empty": EMPTY_ORG_INFO,
    "create_default": {**ORG_INFO, "accounts_by_environment": EMPTY_ENVIRONMENTS},
    "create_reused": ORG_INFO,
    "create_empty": EMPTY_ORG_INFO,
    "create_supplied": {
        **ORG_INFO,
        "accounts_by_environment": {"development": ["111111111112"]},
    },
}
KMS_KEY = "arn:aws:kms:eu-central-1:111111111111:key/00000000-0000-0000-0000-000000000000"
PRINCIPALS = {
    "organization": "arn:aws:organizations::111111111111:organization/o-testorg123",
    "security": "111111111112",
}
TAGS = {"Purpose": "org-info-test"}


def check_plan(name, plan):
    resources = {
        resource["address"]: resource
        for resource in plan.get("resource_changes", [])
        if resource["mode"] == "managed"
    }
    expected = EXPECTED[name]
    if name.startswith("discover_"):
        assert not resources, f"{name}: discovery must create no managed resources"
        assert plan["output_changes"]["org_info"]["after"] == expected, name
        return

    addresses = set()
    for field, value in expected.items():
        prefix = f'module.shared_parameters["{field}"]'
        parameter = f"{prefix}.aws_ssm_parameter.this[0]"
        ram = f"{prefix}.module.ram_resource_share"
        share = f"{ram}.aws_ram_resource_share.this"
        addresses.update([parameter, share, f'{ram}.aws_ram_resource_association.this["this"]'])
        suffix = field.replace("_", "-")
        actual = resources[parameter]["change"]["after"]
        for key, wanted in {
            "name": f"/shared/management/{suffix}",
            "description": f"Shared SSM parameter for {field}",
            "type": "SecureString",
            "tier": "Advanced",
            "key_id": KMS_KEY,
            "tags": TAGS,
            "value": json.dumps(value, sort_keys=True, separators=(",", ":")),
        }.items():
            assert actual[key] == wanted, f"{name}: {parameter}.{key} changed"
        actual_share = resources[share]["change"]["after"]
        assert actual_share["name"] == f"ssm-shared-management-{suffix}", name
        assert actual_share["allow_external_principals"] is False, name
        assert actual_share["tags"] == TAGS, name
        for key, principal in PRINCIPALS.items():
            association = f'{ram}.aws_ram_principal_association.this["{key}"]'
            addresses.add(association)
            assert resources[association]["change"]["after"]["principal"] == principal, name

    assert set(resources) == addresses, f"{name}: publishing resource addresses changed"
    assert all(r["change"]["actions"] == ["create"] for r in resources.values()), name


def main():
    result = subprocess.run(
        ["terraform", "test", "-no-color", "-json", "-verbose"],
        cwd=ROOT,
        text=True,
        capture_output=True,
    )
    events = [json.loads(line) for line in result.stdout.splitlines()]
    for event in events:
        if event.get("type") != "test_plan":
            print(event.get("@message", ""))
            if event.get("type") == "diagnostic":
                print(event["diagnostic"].get("detail", ""))
    if result.stderr:
        print(result.stderr, file=sys.stderr)
    if result.returncode:
        raise SystemExit(result.returncode)

    checked = set()
    for event in events:
        if event.get("type") == "test_plan":
            name = event["@testrun"]
            check_plan(name, event["test_plan"])
            checked.add(name)
    assert checked == set(EXPECTED), f"Missing plans: {set(EXPECTED) - checked}"
    print("PASS: six discovery/publishing plans, exact JSON values, and publishing addresses")


if __name__ == "__main__":
    main()
