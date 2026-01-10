# Terraform Notes


## What Is Terraform?

Terraform is an Infrastructure as Code (IaC) tool, used primarily by DevOps teams to automate various infrastructure tasks.  
The provisioning of cloud resources is one of the main use cases of Terraform.

- Cloud-agnostic
- Open-source
- Written in Go
- Created by HashiCorp

Terraform allows you to describe your complete infrastructure in the form of code.  
Even if your servers come from different providers such as AWS or Azure, Terraform helps you build and manage these resources in parallel across providers.

Think of Terraform as connective tissue and a common language that you can utilize to manage your entire IT stack.


## Benefits of Infrastructure-as-Code (IaC)

IaC replaces standard operating procedures and manual effort required for IT resource management with lines of code.  
Instead of manually configuring cloud nodes or physical hardware, IaC automates the infrastructure management through source code.

### Key Benefits of Using IaC (Terraform)

### Speed and Simplicity
- Eliminates manual processes
- Accelerates delivery and management lifecycles
- Entire infrastructure can be spun up by running a script

### Team Collaboration
- Teams collaborate using tools like GitHub
- Code can be linked to issue tracking systems
- Easy future reference and reuse

### Error Reduction
- Minimizes errors and configuration drift
- Standardized infrastructure setup
- Reduces the need for constant admin oversight

### Disaster Recovery
- Faster recovery from failures
- No need to manually rebuild infrastructure
- Re-run scripts to provision the same setup

### Enhanced Security
- Automation reduces risks caused by human error
- Properly implemented IaC improves overall security


## Basic Terraform Folder Structure

```text
projectname/
│
├── provider.tf
├── version.tf
├── backend.tf
├── main.tf
├── variables.tf
├── terraform.tfvars
└── outputs.tf

```

## Terraform File Naming Best Practices

### Common Tutorial Structure
- **main.tf** → providers, resources, data sources  
- **variables.tf** → variables  
- **output.tf** → outputs  

### Issue With This Structure
- Logic is concentrated in `main.tf`
- File becomes complex and lengthy
- Harder to understand and maintain

Terraform does not mandate any specific structure.  
It only requires a directory containing Terraform files.

### Preferred Logical Structure
- **provider.tf** → terraform block and provider block  
- **data.tf** → data sources  
- **variables.tf** → variables  
- **locals.tf** → local variables  
- **output.tf** → outputs  


## Important Terraform Commands

### Version
```bash

terraform --version
terraform init	                Initialize a working directory
terraform init -input=true	   it will ask for input if necessary
terraform init -lock=false	   Disable locking of state files during state-related operations
terraform plan	                 Creates an execution plan (dry run)
terraform apply	                 Executes changes to the actual environment
terraform apply –auto-approve	   Apply changes without being prompted to enter ”yes”
terraform destroy –auto-approve   Destroy/cleanup without being prompted to enter ”yes”

```

### Terraform Workspaces
```bash
terraform workspace new <name>   Create a new workspace and select it
terraform workspace select <name>   Select an existing workspace
terraform workspace list       List the existing workspaces
terraform workspace show        Show the name of the current workspace
terraform workspace delete <name>   Delete an empty workspace
```

### Terraform Import
terraform import aws_instance.example i-abcd1234(instance id)	#import an AWS instance with ID i-abcd1234 into aws_instance resource named “foo”

## State File

### What is State and Why Is It Important in Terraform?

Terraform must store state about your managed infrastructure and configuration.  
This state is used by Terraform to:

- Map real-world resources to your configuration
- Keep track of metadata
- Improve performance for large infrastructures

The **state file is extremely important** because it maps various resource metadata to actual resource IDs, allowing Terraform to know exactly what it is managing.

This file must be saved and distributed to anyone who might run Terraform.

## Remote State

By default, Terraform stores state locally in a file named `terraform.tfstate`.

When working with Terraform in a team, using a local state file becomes complicated because:

- Each user must always have the latest state file
- Multiple users running Terraform at the same time can corrupt the state

With **remote state**, Terraform writes the state data to a remote data store, which can then be shared safely between all team members.


## State Lock

If supported by your backend, Terraform will lock your state for all operations that could write state.

- This prevents others from acquiring the lock
- Helps avoid state corruption

State locking happens automatically on all write operations.  
You will not see a message when locking occurs.

If state locking fails:
- Terraform will stop execution
- You can disable locking using the `-lock` flag (not recommended)


## Setting Up an S3 Backend

Create a new file in your working directory named **backend.tf**.

Paste the following configuration into `backend.tf`:

```hcl
terraform {
  backend "s3" {
    encrypt        = true
    bucket         = "sample"
    dynamodb_table = "terraform-state-lock-dynamo"
    key            = "terraform.tfstate"
    region         = "us-east-1"
  }
}

Prerequisite Resources (S3 and DynamoDB)

Before configuring the backend, the required S3 bucket and DynamoDB table must be created, as they are referenced in backend.tf.

Creating DynamoDB Table and S3 Bucket

Create a new file named dynamo.tf (or main.tf).

Add the following configurations:

S3 Bucket
resource "aws_s3_bucket" "example" {
  bucket = "sample"
}

DynamoDB Table (State Locking)
resource "aws_dynamodb_table" "dynamodb-terraform-state-lock" {
  name           = "terraform-state-lock-dynamo"
  hash_key       = "LockID"
  read_capacity  = 20
  write_capacity = 20

  attribute {
    name = "LockID"
    type = "S"
  }
}

```

## Data Source

### What Is a Data Source?

A **data source** in Terraform relates to resources, but it only **fetches information** about an object rather than creating one.  
It provides dynamic information about entities that are defined **outside of Terraform**.

Data sources allow fetching details about infrastructure components from cloud provider APIs using Terraform scripts.

When we refer to a resource using a **data source**, Terraform:
- Does **not** create the resource
- Only retrieves information about the existing resource
- Allows that information to be reused in further configuration


## How to Use a Data Source

### Example Scenario
We will create an EC2 instance using an **existing VPC and Subnet** that were already created in the AWS Console (external to Terraform).


## Step 1: Provider Configuration

Create a Terraform directory and add a file named **provider.tf**.

```hcl
provider "aws" {
  region     = "us-east-1"
  access_key = "your_access_key"
  secret_key = "your_secret_key" 
  # keys no need to configure here, it will call from .aws folder from local
}

```

### Step 2: Data Source Configuration
Create another file named demo_datasource.tf and add the following code.

### Fetch Existing VPC and Subnet
```hcl

data "aws_vpc" "vpc" {
  id = vpc_id
}

data "aws_subnet" "subnet" {
  id = subnet_id
}

```
### Create Security Group Using Data Source
Here we are creating a Security Group by calling an existing VPC using a data source.

```hcl

resource "aws_security_group" "sg" {
  name   = "sg"
  vpc_id = data.aws_vpc.vpc.id

  ingress = [
    {
      cidr_blocks     = ["0.0.0.0/0"]
      description     = ""
      from_port       = 22
      protocol        = "tcp"
      security_groups = []
      self            = false
      to_port         = 22
    }
  ]

  egress = [
    {
      cidr_blocks     = ["0.0.0.0/0"]
      description     = ""
      from_port       = 0
      protocol        = "-1"
      security_groups = []
      self            = false
      to_port         = 0
    }
  ]
}

```
### Create EC2 Instance Using Data Source
```hcl
resource "aws_instance" "dev" {
  ami           = data.aws_ami.amzlinux.id
  instance_type = "t2.micro"
  subnet_id     = data.aws_subnet.dev.id
  security_groups = [data.aws_security_group.dev.id]

  tags = {
    Name = "DataSource-Instance"
  }
}

```
### Explanation
VPC and Subnet are already created using AWS Console

Data source blocks fetch information about them

Security Group uses vpc_id fetched from data source

EC2 instance uses subnet_id fetched from data source

This shows how data sources retrieve information about resources not created using Terraform and reuse them to create new infrastructure.

###  Fetch AMI ID Using Data Source
We can also fetch the AMI ID dynamically using a data source.

```hcl

data "aws_ami" "amzlinux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-gp2"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}

```
### This ensures:

Latest Amazon Linux 2 AMI is always used

No hardcoding of AMI IDs

Region-independent and reusable configuration

## Terraform Import

### Why Terraform Import?

Terraform is a relatively new technology, and adopting it to manage an organization’s cloud resources can take time and effort.  
Due to limited skilled resources and the steep learning curve, teams often start managing cloud infrastructure directly through cloud provider consoles.

This is true not only for Terraform but for any IaC tool such as:
- CloudFormation
- Azure ARM Templates
- Pulumi

Handling concepts like **state files** and **remote backends** can be complex.  
In worst-case scenarios, the `terraform.tfstate` file may even be lost.  
This is where **Terraform import** becomes extremely useful.

Terraform import helps bring **pre-existing cloud resources under Terraform management**.

- `terraform import` is a CLI command
- It reads real-world infrastructure
- Updates the Terraform state
- Enables future changes via IaC

⚠️ Import updates the **state only**.  
It does **not** automatically generate configuration files (this is being improved in future Terraform releases).


## Simple Import Example – AWS EC2

### Prerequisites
- Terraform installed
- AWS credentials configured via AWS CLI
- Existing EC2 instance created manually (or already available)


## Step 1: Prepare the EC2 Instance

Create an EC2 instance manually in AWS (optional if one already exists).

Example EC2 details:
- Name: MyVM
- Instance ID: i-0b9be609418aa0609
- Instance Type: t2.micro
- VPC ID: vpc-1827ff72


## Step 2: Create `main.tf` and Configure Provider

Create a file named `main.tf` and add the provider configuration.

```hcl
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

Initialize Terraform: 
```hcl
terraform init
```
Successful initialization will:

Install provider plugins

Create .terraform.lock.hcl

Prepare Terraform for further commands

### Step 3: Write Configuration for the Resource to Be Imported

Terraform import does not create resource configuration automatically.
You must define the resource manually.

Minimal EC2 configuration (required arguments only):
```hcl
resource "aws_instance" "myvm" {
  ami           = "unknown"       # to be updated from state
  instance_type = "unknown"       # to be updated from state
}
```
### Step 4: Import the Resource

Map the existing EC2 instance to the Terraform configuration.
```hcl
terraform import aws_instance.myvm i-0b9be609418aa0609
```

### Successful output example:
```hcl
aws_instance.myvm: Importing from ID "i-0b9be609418aa0609"...
aws_instance.myvm: Import prepared!
aws_instance.myvm: Refreshing state... [id=i-0b9be609418aa0609]

Import successful!
```

At this stage:

Terraform state now knows about the EC2 instance

All resource attributes are stored in terraform.tfstate

### Step 5: Observe State File and Plan Output

After import:

terraform.tfstate file is created

Configuration and state are not fully aligned
```hcl
terraform plan
```

Terraform may show a replacement plan, which is not desired.

Example output:
```hcl
Plan: 1 to add, 0 to change, 1 to destroy.
```

This indicates Terraform wants to replace the EC2 instance, which defeats the purpose of import.

### Step 6: Improve Configuration to Avoid Replacement

Terraform operations rely heavily on the state file.
You must update the configuration to minimize differences between:

Configuration files

State file

Identify attributes causing replacement (highlighted in terraform plan).

Example: AMI mismatch causes replacement.

Update the AMI value accordingly and run plan again.

Resulting output:
```hcl
~ update in-place
Plan: 0 to add, 1 to change, 0 to destroy.

```
Now:

EC2 instance will NOT be replaced

Some attributes may still change

### Step 7: Improve Configuration to Avoid Any Changes

To reach zero difference:

Update all attributes highlighted with ~ in plan output

Match values exactly with the state

Final EC2 configuration:
```hcl
resource "aws_instance" "myvm" {
  ami           = "ami-00f22f6155d6d92c5"
  instance_type = "t2.micro"

  tags = {
    Name = "MyVM"
  }
}
```

Run plan again:
```hcl
terraform plan
```
Final output:
```hcl
No changes. Your infrastructure matches the configuration.
```

### Conclusion

Existing cloud resources successfully imported
Terraform state and configuration are fully aligned
Infrastructure can now be managed safely using Terraform
No unexpected replacements or changes

✅ Terraform import completed successfully

## Meta-Arguments in Terraform

Meta-arguments in Terraform are **special arguments** that can be used with **resource blocks** and **modules** to control their behavior or influence the infrastructure provisioning process.  
They provide additional configuration options beyond regular resource-specific arguments.


## List of Meta-Arguments

### depends_on
- Specifies explicit dependencies between resources
- Ensures one resource is created or updated **before** another resource


### count
- Controls resource instantiation
- Sets the number of resource instances based on a condition or variable


### for_each
- Creates multiple instances of a resource
- Uses a map or set of strings
- Each instance is created with a unique key–value pair


### lifecycle
- Defines lifecycle rules for a resource
- Controls updates, replacements, and deletions


### provider
- Specifies which provider configuration to use for a resource
- Allows selecting a specific provider alias or version


### provisioner
- Executes actions after resource creation
- Commonly used to run scripts or commands


### connection
- Defines connection details to a resource
- Enables remote command execution or file transfers


### variable
- Declares input variables
- Values can be passed during Terraform execution


### output
- Declares output values
- Displayed after Terraform execution


### locals
- Defines local values
- Used internally within Terraform configuration files

## depends_on Meta-Argument in Terraform

Terraform can automatically identify **resource dependencies**, creating dependent resources in the correct order while provisioning independent resources in parallel.  

However, some dependencies **cannot be automatically inferred**. For example, a resource may rely on another resource's behavior but does not reference it in its arguments.  

In such cases, the `depends_on` meta-argument is used to **explicitly define dependencies**.


### Key Points

- `depends_on` must be a **list of references** to other resources
- Can be used in **resources** and **modules** (Terraform v0.13+)
- Ensures that a resource is created **after the specified dependent resources**
- If a dependency fails, the dependent resource **will not be created**


### Example 1: EC2 Dependent on S3 Bucket

```hcl
provider "aws" { 
}

resource "aws_s3_bucket" "example" {
  bucket = "qwertyuiopasdfg"
}

resource "aws_instance" "dev" {
  ami           = "ami-0440d3b780d96b29d"
  instance_type = "t2.micro"
  depends_on    = [aws_s3_bucket.example] 
  # EC2 instance will be created only after S3 bucket creation
}

```
### Example 2: EC2 Dependent on IAM Role
### Step 1: Create IAM Policy

```hcl
resource "aws_iam_policy" "example_policy" {
  name        = "example_policy"
  description = "Permissions for EC2"
  policy      = jsonencode({
    Version: "2012-10-17",
    Statement: [
      {
        Action   = "ec2:*",
        Effect   = "Allow",
        Resource = "*"
      }
    ]
  })
}
```

### Step 2: Create IAM Role
```hcl
resource "aws_iam_role" "example_role" {
  name = "example_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action    = "sts:AssumeRole",
        Effect    = "Allow",
        Sid       = "examplerole",
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}
```
### Step 3: Attach IAM Policy to IAM Role
```hcl
resource "aws_iam_policy_attachment" "policy_attach" {
  name       = "example_policy_attachment"
  roles      = [aws_iam_role.example_role.name]
  policy_arn = aws_iam_policy.example_policy.arn
}
```
### Step 4: Create IAM Instance Profile
```hcl
resource "aws_iam_instance_profile" "example_profile" {
  name = "example_profile"
  role = aws_iam_role.example_role.name
}
```

### Step 5: Create EC2 Instance and Attach IAM Role
```hcl
resource "aws_instance" "example_instance" {
  instance_type        = var.ec2_instance_type
  ami                  = var.image_id
  iam_instance_profile = aws_iam_instance_profile.example_profile.name
  depends_on           = [aws_iam_role.example_role] 
  # EC2 instance will be created only after IAM role is created and attached
}
```

## count Meta-Argument in Terraform

By default, a Terraform **resource block** creates **one infrastructure object**.  
If you want **multiple resources with the same configuration**, you can use the `count` meta-argument.  
This avoids duplicating the resource block multiple times.


### Key Points

- `count` accepts a **whole number**
- Terraform creates that **many instances** of the resource
- Each instance can be uniquely identified using `count.index`  
  - Index ranges from `0` to `count-1`
- Can be used in **resources** and **modules** (Terraform v0.13+)
- Cannot be used together with `for_each`


### Example 1: Create Multiple EC2 Instances

```hcl
resource "aws_instance" "myec2" {
  ami           = "ami-0230bd60aa48260c6"
  instance_type = "t2.micro"
  count         = 2

  tags = {
    Name = "webec2-${count.index}"
  }
}
```

### Example 2: Dynamic Resource Count from a List

```hcl
variable "ami" {
  type    = string
  default = "ami-0440d3b780d96b29d"
}

variable "instance_type" {
  type    = string
  default = "t2.micro"
}

variable "sandboxes" {
  type    = list(string)
  default = ["sandbox_server_two", "sandbox_server_three"]
}

# main.tf
resource "aws_instance" "sandbox" {
  ami           = var.ami
  instance_type = var.instance_type
  count         = length(var.sandboxes)

  tags = {
    Name = var.sandboxes[count.index]
  }
}
```

## for_each Meta-Argument in Terraform

Similar to the `count` meta-argument, the default behavior of a Terraform resource is to create **one infrastructure object**.  
While `count` allows creating multiple instances, `for_each` provides a **more flexible approach**.


### Key Points

- `for_each` accepts a **map** or **set of strings**
- Terraform creates **one instance per member** of the map or set
- To reference each member:
  - `each.key` → The map key or set member
  - `each.value` → The map value
- Can be used in **resources** (Terraform v0.12.6+) and **modules** (Terraform v0.13+)


### Example: Using for_each with a Set of Strings

```hcl
# variables.tf
variable "ami" {
  type    = string
  default = "ami-0078ef784b6fa1ba4"
}

variable "instance_type" {
  type    = string
  default = "t2.micro"
}

variable "sandboxes" {
  type    = set(string)
  default = ["sandbox_one", "sandbox_two", "sandbox_three"]
}

# main.tf
resource "aws_instance" "sandbox" {
  ami           = var.ami
  instance_type = var.instance_type
  for_each      = var.sandboxes

  tags = {
    Name = each.value # for a set, each.key and each.value are the same
  }
}
```
## Multi-Provider Setup in Terraform

The `provider` meta-argument specifies **which provider** to use for a resource.  
This is particularly useful when working with **multiple providers**, such as when creating **multi-region resources**.

To differentiate providers, use the `alias` field.  
Then reference the provider alias in the resource as `provider.<alias>`.

### Example: Using Multiple AWS Providers

```hcl
# Default provider for ap-south-1
provider "aws" {
  region = "ap-south-1"
}

# Additional provider for us-east-1 with alias
provider "aws" {
  region = "us-east-1"
  alias  = "america"
}

# Resource using default provider
resource "aws_s3_bucket" "test" {
  bucket = "del-hyd-naresh-it"
}

# Resource using aliased provider
resource "aws_s3_bucket" "test2" {
  bucket   = "del-hyd-naresh-it-test2"
  provider = aws.america
}
```
## Lifecycle Meta-Argument in Terraform

The **lifecycle** meta-argument is a nested block within a resource block.  
It is used to **control how Terraform handles creation, modification, and destruction** of resources.


### Example: Basic Lifecycle Usage

```hcl
resource "aws_instance" "test" {
  ami               = "ami-0440d3b780d96b29d"
  instance_type     = "t2.micro"
  availability_zone = "us-east-1b"

  tags = {
    Name = "test"
  }

  lifecycle {
    create_before_destroy = true
    # This will create the new object first, then destroy the old one
  }

  # lifecycle {
  #   prevent_destroy = true
  #   # Prevents accidental destruction of critical resources
  # }

  # lifecycle {
  #   ignore_changes = [tags]
  #   # Terraform will ignore changes to these attributes
  # }
}
```
### Key Lifecycle Attributes
### 1. create_before_destroy

Default behavior: Terraform destroys the old object first, then creates a new one
With create_before_destroy = true, Terraform:
Creates the new object first
Destroys the old object afterward
Helps reduce downtime
⚠️ Some resources may have restrictions preventing concurrent existence
```hcl
lifecycle {
  create_before_destroy = true
}
```
### 2. prevent_destroy

Prevents Terraform from accidentally destroying critical resources
Terraform will throw an error if a destroy is attempted
Use only when necessary, as it can block certain configuration changes
```hcl
lifecycle {
  prevent_destroy = true
}
```

### Error Example:
```hcl
Error: Instance cannot be destroyed
resource details...
Resource [resource_name] has lifecycle.prevent_destroy set,
but the plan calls for this resource to be destroyed.
```
### 3. ignore_changes

Ignores updates to specified attributes that are changed outside Terraform
Useful when another system automatically updates attributes (e.g., Azure Policy tags)
Can specify specific attributes or use all to ignore everything
```hcl
# Ignore a specific attribute
lifecycle {
  ignore_changes = [
    tags["department"]
  ]
}

# Ignore all attributes
lifecycle {
  ignore_changes = [
    all
  ]
}
```
### Summary

lifecycle meta-argument gives fine-grained control over resource management
Helps avoid downtime, accidental deletions, and unwanted updates

### Attributes:
create_before_destroy → minimize downtime
prevent_destroy → protect critical resources
ignore_changes → ignore external changes to attributes

## Locals and Provisioners in Terraform

---

### Locals

A **local value** assigns a name to an expression so it can be reused multiple times within a module.  
- Helps avoid repeating the same expressions or values
- Values are **set locally** in the configuration, not by user input
- Overuse can make configuration harder to read

#### Example:

```hcl
locals {
  bucket_name = "${var.layer}-${var.env}-bucket-hydnaresh"
}

resource "aws_s3_bucket" "demo" {
  bucket = local.bucket_name

  tags = {
    Name        = local.bucket_name
    Environment = var.env
  }
}
```
### Provisioners

Provisioners allow you to perform specific actions on local or remote machines that Terraform’s declarative model cannot handle.

### 1. File Provisioner

Copies files or directories from the machine running Terraform to the newly created resource.
Supports SSH or WinRM connections.

```hcl
resource "aws_instance" "web" {
  # ...

  provisioner "file" {
    source      = "conf/myapp.conf"
    destination = "/etc/myapp.conf"
  }
}
```
### 2. Local-Exec Provisioner

Executes a command on the machine running Terraform after resource creation.
Never executes on the remote machine
Useful for local operations

```hcl
resource "aws_instance" "web" {
  # ...

  provisioner "local-exec" {
    command = "echo ${self.private_ip} >> private_ips.txt"
  }
}
```
### 3. Remote-Exec Provisioner

Executes a command on the remote machine after resource creation.
Requires a connection block
Can run scripts, bootstrap servers, or use configuration management tools

```hcl
resource "aws_instance" "web" {
  # ...

  connection {
    type        = "ssh"
    user        = "ubuntu"       # EC2 username
    private_key = file("~/.ssh/id_rsa")
    host        = self.public_ip
  }

  provisioner "remote-exec" {
    inline = [
      "touch file200",
      "echo hello from aws >> file200",
    ]
  }
}
```
## Modules in Terraform

### What is a Terraform Module?

Terraform **modules** are reusable and encapsulated collections of Terraform configurations.  
They simplify resource management, making Terraform code **modular, scalable, and maintainable**.

#### Benefits of Using Terraform Modules

- **Reusability:** Organize resources into containers to reuse across projects and environments.
- **Abstraction:** Simplifies configuration and makes Terraform code concise and readable.
- **Encapsulation:** Isolates resources and dependencies, allowing safe modification of components.
- **Versioning:** Track changes and update dependencies in a controlled manner.
- **Collaboration:** Share modules via Terraform Registry or private repositories to standardize infrastructure.


### Terraform Module Examples

#### Example 1: AWS VPC Module

**Module Directory Structure:**

modules/
vpc/
main.tf
variables.tf


**VPC Module Code (modules/vpc/main.tf):**
```hcl
resource "aws_vpc" "example" {
  cidr_block = var.cidr_block
  tags       = { Name = var.name }
}
```

### Input Variables (modules/vpc/variables.tf):
```hcl
variable "cidr_block" {
  description = "The CIDR block for the VPC."
}

variable "name" {
  description = "The name of the VPC."
}
```
### Using the VPC Module (main.tf):
```hcl
module "my_vpc" {
  source     = "./modules/vpc"
  cidr_block = "10.0.0.0/16"
  name       = "my-vpc"
}
```

Reuse this module to create multiple VPCs with different configurations.

### Example 2: AWS EC2 Instance Module

***Module Directory Structure:

modules/
  ec2/
    main.tf
    variables.tf


### EC2 Module Code (modules/ec2/main.tf):
```hcl
resource "aws_instance" "example" {
  ami           = var.ami
  instance_type = var.instance_type
  subnet_id     = var.subnet_id
  key_name      = var.key_name

  tags = {
    Name = var.name
  }
}

```
### Input Variables (modules/ec2/variables.tf):
```hcl
variable "ami" {
  description = "The AMI ID for the EC2 instance."
}

variable "instance_type" {
  description = "The instance type for the EC2 instance."
}

variable "subnet_id" {
  description = "The subnet ID for the EC2 instance."
}

variable "key_name" {
  description = "Key pair to associate with the EC2 instance."
}

variable "name" {
  description = "The name of the EC2 instance."
}

```
### Using the EC2 Module (main.tf):
```hcl
module "my_ec2" {
  source        = "./modules/ec2"
  ami           = "ami-12345678"
  instance_type = "t2.micro"
  subnet_id     = "subnet-01234567"
  key_name      = "my-key-pair"
  name          = "my-ec2-instance"
}

```
Reuse this module to deploy EC2 instances with varying configurations.

### Using a Module from GitHub
```hcl
module "root_module" {
  source = "github.com/CloudTechDevOps/Terraform/root_modules"
}
```

# Terraform Connection, Output Values, and Conditional Meta-Arguments


## Connection Block

The **connection block** defines how Terraform connects to a remote resource.  
Multiple connection blocks can be used if you need different permissions for different provisioners (e.g., root vs. limited user).

- A connection block nested **directly in a resource** applies to all its provisioners.
- Nested in a **provisioner**, it only applies to that provisioner.

**Example:**
```hcl
connection {
  type        = "ssh"
  user        = "ubuntu"  # Replace with the appropriate username for your EC2 instance
  private_key = file("~/.ssh/id_rsa")  # Path to private key
  host        = self.public_ip
}
```
### Output Values

Output values expose information about your infrastructure:
Display info on CLI
Share values with other Terraform configurations

**Example:**
```hcl

output "instance_public_ip" {
  value     = aws_instance.test.public_ip
  sensitive = true
}

output "instance_id" {
  value = aws_instance.test.id
}

output "instance_public_dns" {
  value = aws_instance.test.public_dns
}

output "instance_arn" {
  value = aws_instance.test.arn
}
```
### Conditional Meta-Arguments (Variable Validation)
Terraform allows conditional checks on variables using the validation block.

**Example:** 
```hcl
variable "aws_region" {
  description = "The region in which to create the infrastructure"
  type        = string
  nullable    = false
  default     = "change me" # Must be updated to valid region

  validation {
    condition     = var.aws_region == "us-west-2" || var.aws_region == "eu-west-1"
    error_message = "The variable 'aws_region' must be one of the following regions: us-west-2, eu-west-1"
  }
}

provider "aws" {
  region = var.aws_region
}
```
