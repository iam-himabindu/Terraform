resource "aws_instance" "name" {
    ami="ami-068c0051b15cdb816"
    instance_type="t2.micro"
  tags = {
    Name = "dynamoDB"
}
}

resource "aws_s3_bucket" "name" {
    bucket = "ahegfuiahsiodohadsjkfjklzs"
  
}