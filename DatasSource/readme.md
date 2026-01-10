# Terraform Data Source

## What is a Data Source?

A **Data Source** in Terraform is used to **fetch information about existing infrastructure resources** without creating or modifying them.

- Data sources **do not create resources**
- They **read information** about objects that already exist
- These objects may be created:
  - Manually via AWS Console
  - By another Terraform configuration
  - By another team or tool

Data sources fetch data directly from **cloud provider APIs** and make that information available for use in Terraform resources.

### Key Points
- Data sources are **read-only**
- They help Terraform work with **external or pre-existing infrastructure**
- Useful for **hybrid environments** where not everything is managed by Terraform


## How to Use Data Source?

### Use Case
Create an EC2 instance using:
- An **existing VPC**
- An **existing Subnet**
- Both created manually in the AWS Console (outside Terraform)


## Step 1: Provider Configuration

Create a directory and add a file named `provider.tf`.

```hcl
provider "aws" {
  region = "us-east-1"
  # Access keys are not required here
  # Terraform will automatically use credentials from ~/.aws/credentials
}
```

### Step 2: Use Data Sources to Fetch Existing Resources

Create a file named demo_datasource.tf.

Fetch Existing VPC and Subnet
```hcl
data "aws_vpc" "vpc" {
  id = "vpc-xxxxxxxx"
}

data "aws_subnet" "subnet" {
  id = "subnet-xxxxxxxx"
}
```
**Create a Security Group Using Existing VPC**
```hcl
resource "aws_security_group" "sg" {
  name   = "sg"
  vpc_id = data.aws_vpc.vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
```
### Create an EC2 Instance Using Existing Subnet
```hcl
resource "aws_instance" "dev" {
  ami           = data.aws_ami.amzlinux.id
  instance_type = "t2.micro"
  subnet_id     = data.aws_subnet.subnet.id

  vpc_security_group_ids = [
    aws_security_group.sg.id
  ]

  tags = {
    Name = "DataSource-Instance"
  }
}
```
### Case 2: Fetch AMI Using Data Source
Instead of hardcoding an AMI ID, we can dynamically fetch the latest Amazon Linux 2 AMI.
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
