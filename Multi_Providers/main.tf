
resource "aws_s3_bucket" "provider-1" {
    bucket = "fghjrtyucvhcvhdfjhs"
    force_destroy = true
    provider = aws.oregon   # s3 bucket will create into "eu-west-1"
  
}
resource "aws_s3_bucket" "test2" {
  bucket = "sdhfhiosajdfjhskjagjs"       #provider.value of alias
  force_destroy = true                    # s3 bucket will create into "us-east-1"
}


resource "aws_instance" "name" {
    ami = "ami-07ff62358b87c7116"
    instance_type = "t2.micro"
    # key_name = "ec2test"
    availability_zone = "us-east-1b"
    tags = {
      Name = "Test-server"
    }
   
}

resource "aws_vpc" "name" {
    cidr_block = "10.0.0.0/16"
    provider = aws.oregon
    tags = {
        Name = "myvpc"
    }
  
}

# same resource vinto tow different regions 
# provider "aws" {
#   region = "us-east-1"
# }

# provider "aws" {
#   region = "ap-south-1"
#   alias  = "mumbai"
# }

# variable "regions" {
#   type = map(object({
#     ami             = string
#     availability_zone = string
#   }))
#   default = {
#     "us-east-1"  = { ami = "ami-085ad6ae776d8f09c", availability_zone = "us-east-1a" }
#     "ap-south-1" = { ami = "ami-05169c5e5bfb48fb4", availability_zone = "ap-south-1a" }
#   }
# }

# resource "aws_instance" "multi_region" {
#   for_each = var.regions

#   ami             = each.value.ami
#   instance_type   = "t2.micro"
#   key_name        = "ec2test"
#   availability_zone = each.value.availability_zone

#   provider = each.key == "us-east-1" ? aws : aws.mumbai

#   tags = {
#     Name = "dev-${each.key}"
#   }
# }