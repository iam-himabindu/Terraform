# OpenTofu Installation & Migration Guide

## Installation

```powershell
Invoke-WebRequest -outfile "install-opentofu.ps1" -uri "https://get.opentofu.org/install-opentofu.ps1"

Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope Process

& .\install-opentofu.ps1 -installMethod standalone -skipVerify
```

## Migrating to OpenTofu from Terraform 1.9.x

When migrating from Terraform 1.9.x, please migrate to **OpenTofu 1.9.0** first, then upgrade your OpenTofu installation to the latest version.

OpenTofu 1.9.0 is largely compatible with Terraform 1.9.x with a few minor changes needed.

### Step 0: Prepare a Disaster Recovery Plan

Although OpenTofu 1.9.0 is very similar to Terraform 1.9.8, ensure you have an up-to-date and tested disaster recovery plan.

### Step 1: Upgrade Terraform

This migration guide is valid only for **Terraform 1.9.8**.

- If you are on a version below 1.9.8, upgrade to at least 1.9.8.
- If you are on a higher version, wait for an appropriate migration guide.

### Step 2: Apply All Changes with Terraform

Ensure there are no pending changes before migration.

```bash
terraform plan
```

Expected output:

```
No changes. Your infrastructure matches the configuration.
```

### Step 3: Install OpenTofu 1.9.0

Install OpenTofu and verify the installation:

```bash
tofu --version
```

Expected output:

```
OpenTofu v1.9.0
```

### Step 4: Back Up State File and Code

- **Local state**: Back up `terraform.tfstate`.
- **Remote state (e.g., S3)**: Follow backend backup and restore procedures.
- Ensure your code is versioned before proceeding.

### Step 5: Required Code Changes

#### Unsupported Functions

The following functions are **not supported** in OpenTofu:

- `encode_tfvars`
- `decode_tfvars`
- `encode_expr`

Refactor your code if you rely on these functions.

#### S3 Backend Changes

If using the S3 backend:

- Remove `skip_s3_checksum`.
- Remove `endpoints → sso` or `AWS_ENDPOINT_URL` and verify functionality.


#### Removed Block Changes

- Remove the `lifecycle` block.
- If `destroy = true` was used, remove the entire `removed` block.
- Restructure code if using destroy-time provisioners.

#### Input Variable Validation

If validations refer to other variables or objects, restructure them to avoid thisnx (see issue #1336).

#### Testing Changes

If using `terraform test`:

- Remove `override_resource` or `override_data` inside `mock_provider`.
- Restructure tests accordingly (see OpenTofu issue #1204).


### Step 6: Initialize OpenTofu

⚠️ **Warning**  
If any step fails, stop immediately and follow rollback procedures.

```bash
tofu init
```

### Step 7: Inspect the Plan

```bash
tofu plan
```

Expected output:

```
No changes. Your infrastructure matches the configuration.
```

### Step 8: Apply

Run apply to ensure OpenTofu updates the state file:

```bash
tofu apply
```

✅ Migration complete!
