
resource "aws_vpc" "name" {
    cidr_block = "10.0.0.0/16"
    enable_dns_support = true
    enable_dns_hostnames = true
    tags = {
      Name = "main-vpc"
    }
  
}

resource "aws_s3_bucket" "name" {
    bucket="ahdfasfiugsiogfjjkf"
    force_destroy = true
  
}


resource "aws_instance" "server" {
    ami = "ami-07ff62358b87c7116"
    instance_type = "t2.micro"
    #key_name = "ec2test"
    availability_zone = "us-east-1d"
    tags = {
      Name = "workspace-server"
    }
}


