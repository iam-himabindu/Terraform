# Your production infrastructure resources go here

resource "aws_instance" "name" {
    ami="ami-08d7aabbb50c2c24e"
    instance_type="t2.micro"
    
}


resource "aws_s3_bucket" "example" {
  bucket = "tf-hima-statefile-bucket"
}