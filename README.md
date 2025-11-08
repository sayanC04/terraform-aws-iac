# terraform-aws-iac
Infrastructure as Code (IaC) project to provision and manage secure, scalable AWS cloud infrastructure using Terraform.

![Cloud Infrastructure Illustration](https://images.unsplash.com/photo-1503437313881-503a91226416?ixlib=rb-1.2.1&auto=format&fit=crop&w=1400&q=80)

## Overview

This repository contains Terraform code to provision AWS resources (EC2, S3, and related components). It also includes a small backend configuration designed to provide remote state storage and locking so multiple operators can work safely.

## Table of contents

- Prerequisites
- Quick start
- Changing configuration (region, sizes, etc.)
- Backend and state locking
- Security & gitignore
- Troubleshooting & notes

## Prerequisites

Before you run the Terraform code in this repo, ensure you have the following installed and configured on your Windows machine:

1. AWS CLI v2
	- Download and install from the official AWS docs: https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html
	- Verify installation in PowerShell:

```powershell
aws --version
```

2. Configure AWS credentials (IAM user with appropriate permissions)
	- Create an IAM user in the AWS Console with programmatic access and the least-privilege policies required for the operations (for example: S3, EC2, IAM if you manage roles, and DynamoDB for state locking).
	- Save the Access Key ID and Secret Access Key.
	- Configure credentials locally using:

```powershell
aws configure
# then follow prompts for Access Key ID, Secret Access Key, region (or leave blank) and output format
```

	- Alternatively, you can set environment variables (recommended for CI):

```powershell
$Env:AWS_ACCESS_KEY_ID = 'your-access-key-id'
$Env:AWS_SECRET_ACCESS_KEY = 'your-secret-access-key'
$Env:AWS_DEFAULT_REGION = 'us-east-1'
```

3. Terraform (for Windows)
	- Option A — Chocolatey (recommended if you use Chocolatey):

```powershell
choco install terraform -y
terraform -version
```

	- Option B — Manual install from HashiCorp:
	  - Download the Windows zip from https://www.terraform.io/downloads.html
	  - Unzip and add the `terraform.exe` binary to a folder on your PATH.

4. (Optional) PowerShell / Git client — to run commands and manage the repository.

## Quick start

From the repository root in PowerShell:

```powershell
cd c:\Users\User\Desktop\terraform-aws-iac\Terraform
# initialize providers and backend (this will configure remote state if backend configured)
terraform init

# see the plan
terraform plan -var-file="terraform.tfvars"

# apply (be careful: creates resources in your AWS account)
terraform apply -var-file="terraform.tfvars"
```

If you want to run interactively without a tfvars file you can use `-var 'aws_region=us-east-1'` and other `-var` flags.

## Changing configuration (region, sizes, etc.)

This project uses a `variables.tf` block to centralize configurable values such as the AWS region, instance types, AMIs, and resource counts.

- To change the region or other variables, edit or create a `terraform.tfvars` file in the `Terraform/` folder with the desired values. Example `terraform.tfvars`:

```hcl
aws_region = "us-east-1"
instance_type = "t3.micro"
```

- You can also override variables on the command line:

```powershell
terraform apply -var 'aws_region=us-west-2' -var 'instance_type=t3.small'
```

- Environment variables are supported for common AWS settings (see `AWS_REGION`, `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`).

Make sure to review `variables.tf` to see all available variables and their defaults.

## Backend and state locking

This repository includes a small `Terraform_backend/` folder which contains configuration for a remote state backend. When configured, the remote backend will:

- Store the Terraform state remotely (e.g., in an S3 bucket).
- Enable state locking (typically via DynamoDB) so concurrent runs don’t corrupt state.

To use the backend configuration in `Terraform_backend/`:

1. Review `Terraform_backend/backend_infra.tf` and its variables to understand the bucket/table names and region.
2. Deploy the backend infra first (this will create the S3 bucket / DynamoDB table used to store and lock state):

```powershell
cd ..\Terraform_backend
terraform init
terraform apply
```

3. Return to `Terraform/` and run `terraform init`. If the backend config is present and reachable, Terraform will prompt to migrate state to the remote backend.

Important: do not manually edit remote state files. Use `terraform` commands to manage state safely.

## Security & gitignore

- Terraform state files can contain sensitive data (resource IDs, secrets, ARNs). Do NOT commit `terraform.tfstate` files or backup files into a public repository.
- This repository includes a recommended `.gitignore` to exclude `terraform.tfstate`, local override files, and local `.terraform` directories.

If your repo does not already contain `.gitignore`, add one and include:

```
# Terraform
*.tfstate
*.tfstate.*
.terraform/
crash.log
override.tf
override.tf.json
*_override.tf
.terraform.tfstate

# SSH keys and other secrets
id_ed25519
id_rsa
*.pem
```

We included a `.gitignore` in the repository for you.

## Troubleshooting & notes

- If `terraform init` fails with provider errors, run `terraform init -upgrade` to refresh provider plugins.
- If you see permission errors in AWS calls, ensure the IAM user has sufficient permissions for the resources you are creating.
- Keep your AWS credentials secure. Prefer environment variables or dedicated CI secrets for automated runs.

## Next steps and recommended improvements

- Add a `terraform.tfvars.example` with placeholder values so new contributors know which variables to set.
- Add a CI job to run `terraform fmt` and `terraform validate` on pull requests.
- Consider using workspaces or separate state backends per environment (dev/staging/prod).

## License

See the repository `LICENSE` file for licensing information.

