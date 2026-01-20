
# The terraform taint command marks specified objects in the Terraform state as tainted. 
# Use the terraform taint command when objects become degraded or damaged

provider "aws" {
  region = "us-east-1"
}


resource "aws_instance" "server" {
  ami     = "ami-0ecb62995f68bb549" # Ubuntu AMI
  instance_type   = "t2.micro"

  tags = {
    Name = "UbuntuServer"
  }
}

#Use terraform taint to manually mark the resource for recreation by below comamnd
# terraform taint aws_instance.server it will give as below
# Resource instance aws_instance.server has been marked as taintedtf
# Now if we run this terraform apply command, it will show as 1 to add and 1 to destroy
# without doing any configuration changes in the main file
