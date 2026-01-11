# Terraform Import – Why and How

## Why Import?

Terraform is a relatively new technology, and adopting it to manage an organisation’s cloud resources can take time and effort. Due to a lack of skilled resources and the steep learning curve involved in using Terraform effectively, many teams initially manage cloud infrastructure directly through cloud provider web consoles.

In general, any Infrastructure as Code (IaC) approach—such as **Terraform**, **AWS CloudFormation**, **Azure ARM Templates**, or **Pulumi**—requires proper training and hands-on experience with real-world scenarios. Things become even more complex when dealing with concepts such as:

- Terraform state files  
- Remote backends  
- State locking and consistency  

In worst-case scenarios, the `terraform.tfstate` file may be lost or corrupted. Fortunately, Terraform provides the **import** functionality, which can be used to rebuild the state file from existing infrastructure.

Terraform **import** allows pre-existing cloud resources to be brought under Terraform management. The `terraform import` command reads real-world infrastructure and updates the Terraform state so that future changes can be managed using IaC.

> **Note:**  
> The import functionality updates only the Terraform **state**. It does **not** automatically generate Terraform configuration files (`.tf`). However, the Terraform team is actively improving this capability in newer releases.


## Simple Import Example

Now that we understand why importing resources is important, let us start with a simple example: importing an **AWS EC2 instance** into Terraform.

> **Assumptions:**  
> - Terraform is already installed on your system  
> - AWS CLI is configured with valid credentials  
> - Required IAM permissions are in place  

We will not cover the installation or AWS CLI configuration steps in this tutorial.


## Step 1: Prepare the EC2 Instance

For demonstration purposes, we will create an EC2 instance manually and then import it into Terraform.  
If you already have an existing EC2 instance, this step can be skipped.

### Terraform: Create EC2 Instance in an Existing VPC

Provision an EC2 instance manually using the AWS Management Console.

### Example EC2 Instance Details

- **Name:** MyVM  
- **Instance ID:** i-0b9be609418aa0609  
- **Instance Type:** t2.micro  
- **VPC ID:** vpc-1827ff72  

This EC2 instance will be used as the target resource for Terraform import in the next steps.

## Step 2: Create `main.tf` and Set Provider Configuration

The goal of this step is to import the existing EC2 instance into our Terraform configuration.  
In your desired working directory, create a file named **`main.tf`** and configure the AWS provider.

### Example: Importing EC2 Instance into Terraform Configuration

```hcl
// Provider configuration
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}
```

Once the file is created, run the following command to initialize Terraform:

```bash
terraform init
```

### Successful Initialization Output

```text
Terraform has been successfully initialized!

You may now begin working with Terraform. Try running "terraform plan" to see
any changes that are required for your infrastructure. All Terraform commands
should now work.

If you ever set or change modules or backend configuration for Terraform,
rerun this command to reinitialize your working directory. If you forget, other
commands will detect it and remind you to do so if necessary.
```


## Step 3: Write Configuration for the Resource to Be Imported

As discussed earlier, **Terraform import does not generate configuration files automatically**.  
Therefore, you must manually create the Terraform configuration that represents the existing EC2 instance.

At this stage, the configuration does **not** need to include every attribute of the EC2 instance.  
Only the required arguments are sufficient, and additional attributes can be added later after reviewing the imported state.

Although you may already know many attributes, it is generally safer to keep the configuration minimal—especially when importing infrastructure that was not originally created by you.

Append the following EC2 configuration to your `main.tf` file.

### Example EC2 Resource Configuration

```hcl
resource "aws_instance" "myvm" {
  ami           = "unknown"        # To be updated from the state file
  instance_type = "unknown"        # To be updated from the state file
}
```

> **Note:**  
> The `ami` and `instance_type` attributes are mandatory for the `aws_instance` resource.  
> Their actual values will be determined after importing the resource and inspecting the Terraform state.


## Step 4: Import the EC2 Instance

At this point:
- The EC2 instance already exists in AWS
- The corresponding Terraform configuration exists in `main.tf`

The final step is to **map the existing EC2 instance to the Terraform resource** using the import command.

### Import Command

```bash
terraform import aws_instance.myvm <INSTANCE_ID>
```

### Example

```bash
terraform import aws_instance.myvm i-0b9be609418aa0609
```

### Successful Import Output

```text
aws_instance.myvm: Importing from ID "i-0b9be609418aa0609"...
aws_instance.myvm: Import prepared!
  Prepared aws_instance for import
aws_instance.myvm: Refreshing state... [id=i-0b9be609418aa0609]

Import successful!

The resources that were imported are shown above. These resources are now in
your Terraform state and will henceforth be managed by Terraform.
```

### What Happened During Import?

- Terraform mapped the configuration `aws_instance.myvm` to the existing EC2 instance using its Instance ID.
- The Terraform **state file** now contains the complete set of attributes for the EC2 instance.
- Terraform can now track, plan, and manage future changes to this EC2 instance using IaC.

From this point onward, you can inspect the state and update the configuration to match the imported resource exactly.

## Step 5: Observe State Files and Plan Output

After running the `terraform import` command successfully, you will notice a new file in your working directory:

- **terraform.tfstate**

This file represents the current known state of your infrastructure as understood by Terraform. It is automatically generated during the import process. Take some time to inspect this file, as it contains all attributes fetched from the existing EC2 instance.

At this stage, your Terraform configuration does **not** fully reflect the state file. Any attempt to run `terraform plan` or `terraform apply` will result in unexpected changes.

Run the following command:

```bash
terraform plan
```

### Sample Plan Output

```text
          } -> (known after apply)
          ~ throughput            = 0 -> (known after apply)
          ~ volume_id             = "vol-0fa93084426be508a" -> (known after apply)
          ~ volume_size           = 8 -> (known after apply)
          ~ volume_type           = "gp2" -> (known after apply)
        }

      - timeouts {}
    }

Plan: 1 to add, 0 to change, 1 to destroy.
```

```text
Note: You didn't use the -out option to save this plan, so Terraform can't guarantee
to take exactly these actions if you run "terraform apply" now.
```

### What Does This Mean?

- Terraform is attempting to **replace** the EC2 instance.
- This goes against our goal of importing and managing the *existing* resource.
- The good news is that Terraform has already recognized the EC2 instance via the state file.


## Step 6: Improve Configuration to Avoid Replacement

The `terraform.tfstate` file is the **single source of truth** for Terraform operations.  
To avoid replacing the EC2 instance, your configuration must closely match the state file.

The goal at this stage is **not zero difference**, but to **avoid destructive changes**.

From the plan output, identify attributes that cause replacement.  
In this example, the **AMI ID** is the primary cause.

### Fix the AMI Attribute

Update the `ami` value in your configuration with the actual AMI ID shown in the plan output or state file.

Run `terraform plan` again.

### Updated Plan Output

```text
Terraform used the selected providers to generate the following execution plan.
Resource actions are indicated with the following symbols:
  ~ update in-place

Terraform will perform the following actions:

  # aws_instance.myvm will be updated in-place
  ~ resource "aws_instance" "myvm" {
        id            = "i-0b9be609418aa0609"
      ~ instance_type = "t2.micro" -> "unknown"
      ~ tags          = {
          - "Name" = "MyVM" -> null
        }
      ~ tags_all      = {
          - "Name" = "MyVM"
        } -> (known after apply)
        # (27 unchanged attributes hidden)
    }

Plan: 0 to add, 1 to change, 0 to destroy.
```

### Result

- The EC2 instance will **not be replaced**
- Some attributes will still be modified
- You are now in a **low-risk state**


## Step 7: Improve Configuration to Avoid Changes

To achieve a **0-difference state**, you must further align your Terraform configuration with the state file.

Terraform highlights differences using the `~` symbol.  
For example:

- `instance_type` changes from `"t2.micro"` → `"unknown"`
- Tags are being removed

If these values are aligned correctly, Terraform will not request any changes.

### Final `aws_instance` Configuration

```hcl
resource "aws_instance" "myvm" {
  ami           = "ami-00f22f6155d6d92c5"
  instance_type = "t2.micro"

  tags = {
    Name = "MyVM"
  }
}
```

Run `terraform plan` again.

### Final Plan Output

```text
aws_instance.myvm: Refreshing state... [id=i-0b9be609418aa0609]

No changes. Your infrastructure matches the configuration.

Terraform has compared your real infrastructure against your configuration
and found no differences, so no changes are needed.
```


## Conclusion

🎉 **Congratulations!**  

You have successfully imported an existing EC2 instance into Terraform and aligned the configuration with the state file.

### What You Achieved

- Imported an existing cloud resource without recreation
- Prevented destructive changes
- Achieved a zero-drift Terraform configuration
- Can now safely manage this resource using Terraform going forward

Your infrastructure is now fully under Terraform control—**without any surprises**.


