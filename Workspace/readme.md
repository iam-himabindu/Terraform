# Terraform Workspaces

This is **Part 1** of the *How to manage multiple environments with Terraform* blog post series.  
In this post, we’ll look at how to manage multiple environments with Terraform using **workspaces**.

## Topics Covered

- Setting up environments using workspaces  
- Switching between environments  
- Using different configurations in each environment  
- Using different backends in each environment  
- Advantages of workspaces  
- Drawbacks of workspaces  
- Conclusion  

> **Note:** Terraform Cloud and Terraform Enterprise also support a concept called *workspaces*. This is **not the same** as the CLI workspaces discussed in this post, though it is similar and has many of the same trade-offs.

---

## Setting up Environments Using Workspaces

Let’s say you have the following Terraform configuration:

```hcl
provider "aws" {
  region = "us-east-2"
}

resource "aws_instance" "example" {
  ami           = "ami-0fb653ca2d3203ac1"
  instance_type = "t2.micro"

  tags = {
    Name = "example-server"
  }
}

```

This code deploys a single virtual server (an EC2 instance) in AWS in the us-east-2 (Ohio) region and assigns it the tag example-server.

Now imagine you want to deploy this server in three environments:

- dev
- stage
- prod

## Create the dev Workspace
```hcl
terraform workspace new dev
```

**Output:** 
```hcl
Created and switched to workspace "dev"!
You're now on a new, empty workspace. Workspaces isolate their state, so if you run
"terraform plan" Terraform will not see any existing state for this configuration.
```

Now deploy to dev:
```hcl
terraform apply
```

Terraform plan output:
```hcl
# aws_instance.example will be created
Plan: 1 to add, 0 to change, 0 to destroy.
```

Enter yes, and Terraform deploys the instance.

## Create the stage Workspace
```hcl
terraform workspace new stage
```

Then run:
```hcl
terraform apply
```

Even though an instance already exists in dev, Terraform will plan a new EC2 instance because:

- Each workspace has its own state file
- The stage workspace has no knowledge of dev

## Create the prod Workspace
```hcl
terraform workspace new prod
terraform apply
```

At this point, you have:

- 3 environments
- 3 workspaces
- 1 EC2 instance per environment
- A single Terraform codebase

## Switching Between Environments

List all workspaces:
```hcl
terraform workspace list

```
Example output:
```hcl
  default
  dev
  stage
* prod
```

## Switch to the dev workspace:
```hcl
terraform workspace select dev

Switched to workspace "dev".
```

Now, any Terraform command (plan/apply/destroy) runs against the dev environment.

## ⚠️ Workspace Limitation

When using workspaces:

- You cannot see environments directly in code
- You must rely on CLI commands
- Understanding what is deployed across environments becomes difficult
- Comparing dev vs prod infrastructure is not straightforward
- This becomes especially painful when using many small modules.

## Using Different Configurations in Each Environment

Terraform exposes the current workspace name via:
```hcl
terraform.workspace
```

Example:
```hcl
resource "aws_instance" "example" {
  ami           = "ami-0fb653ca2d3203ac1"
  instance_type = terraform.workspace == "prod"
                  ? "m4.large"
                  : "t2.micro"

  tags = {
    Name = "example-server-${terraform.workspace}"
  }
}
```
What This Does

- Adds workspace name to the EC2 tag

   - example-server-dev

   - example-server-stage

   - example-server-prod

- Uses larger instance types in production

- Saves cost in non-prod environments

**Better Approach: Use Maps Instead of Ternary Logic**

Ternary expressions don’t scale well for many environments.
A better approach is using a map:
```hcl
locals {
  instance_types = {
    dev   = "t2.micro"
    stage = "t2.small"
    prod  = "m4.large"
  }
}

resource "aws_instance" "example" {
  ami           = "ami-0fb653ca2d3203ac1"
  instance_type = local.instance_types[terraform.workspace]

  tags = {
    Name = "example-server-${terraform.workspace}"
  }
}

```
This approach is:

- Cleaner
- Easier to maintain
- Scales well with many environments

## Using Different Backends in Each Environment

- Best practice is to fully isolate environments, for example:

   - Separate AWS accounts

   - Separate S3 buckets

   - Separate credentials

## Benefits:

- Reduced blast radius

- Lower risk of accidental prod changes

- Stronger security boundaries

## Terraform Backend Limitation with Workspaces
Terraform workspaces do not support different backends per workspace.

**Example backend configuration:**
```hcl
terraform {
  backend "s3" {
    bucket = "example-bucket"
    region = "us-east-2"
    key    = "example/terraform.tfstate"
  }
}
```

You might be tempted to do this:
```hcl
terraform {
  backend "s3" {
    # ❌ THIS WILL NOT WORK
    bucket = terraform.workspace == "prod"
      ? "prod-bucket"
      : "example-bucket"

    region = "us-east-2"
    key    = "example/terraform.tfstate"
  }
}
```
## Why HashiCorp Does Not Recommend Workspaces for Environments

Because:

- You cannot isolate backends per environment
- Environment visibility is poor
- Risk of accidental changes increases
- Scaling becomes difficult

This is why even HashiCorp’s own documentation discourages using workspaces for managing environments.
