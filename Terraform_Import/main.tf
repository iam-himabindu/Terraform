#resource "aws_instance" "myvm" {
 #ami           = "unknown"#(we need to add from state file reference)
 #instance_type = "unknown"#(we need to add from state file reference)
 #rest all attributes need to be added to match actual resource preseence in AWS 
#}



resource "aws_instance" "name" {
  ami = "ami-07ff62358b87c7116"
  instance_type = "t2.micro"
  availability_zone = "us-east-1d"
 
  tags = {
    Name:"import-server"
  }
}

resource "aws_s3_bucket" "name" {
    bucket = "nareshit-devops-dev"
  
}


resource "aws_s3_bucket_versioning" "versioning_example" {
  bucket = aws_s3_bucket.name.id
  versioning_configuration {
    status = "Enabled"
  }
}

#example import command 
#terraform import aws_s3_bucket.name "bucket name"
#terraform import aws_instance.name i-0f805ae729b101f2f