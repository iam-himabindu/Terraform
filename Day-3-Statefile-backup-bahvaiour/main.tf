resource "aws_instance" "name" {
    ami="ami-08d7aabbb50c2c24e"
    instance_type="t2.micro"
    
}

resource "aws_s3_bucket" "UAT" {
  bucket = "ntrestnginhbckterfirst"

}

resource "aws_s3_bucket_versioning" "UAT" {
  bucket = aws_s3_bucket.UAT.id

  versioning_configuration {
    status = "Enabled"
  }
}
