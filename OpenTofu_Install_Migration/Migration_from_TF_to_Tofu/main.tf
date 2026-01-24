resource "aws_vpc" "name" {
    cidr_block = "10.0.0.0/16"
    tags = {
      Name = "My-VPC"
    }
  
}
resource "aws_instance" "name" {
    ami = "ami-08a6efd148b1f7504"
    instance_type = "t2.nano"
    #key_name = "test-key"
    availability_zone = "us-east-1b"
    tags = {
      Name = "tofu-server"
    }
  
}

resource "aws_s3_bucket" "example" {
  bucket = "ajhfeioarwjefjkansjkdfnj"
  force_destroy = true
}

resource "aws_s3_bucket_ownership_controls" "example" {
  bucket = aws_s3_bucket.example.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "example" {
  depends_on = [aws_s3_bucket_ownership_controls.example]

  bucket = aws_s3_bucket.example.id
  acl    = "private"
}