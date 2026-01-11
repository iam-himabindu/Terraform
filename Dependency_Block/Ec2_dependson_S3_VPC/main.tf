resource "aws_s3_bucket" "name" {
  bucket = "depwegfhbucuydkdt"
  force_destroy = true
 }


resource "aws_vpc" "demo" {
    cidr_block = "10.0.0.0/16"
    tags = {
        Name = "Custom_VPC"
    }
    depends_on = [ aws_s3_bucket.name ]   # after create s3 only vpc create like depdnecy block usage 
}


resource "aws_instance" "dev" {
    ami = "ami-0440d3b780d96b29d"
    instance_type = "t2.micro"
    depends_on = [ aws_vpc.demo]
    tags = {
      Name="depend-server"
    }
}


  