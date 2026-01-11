resource "aws_instance" "name" {
  ami = "ami-07ff62358b87c7116"
  instance_type = "t2.micro"
  availability_zone = "us-east-1d"
 
  tags = {
    Name:"import-server"
  }
}


#example import command 
#terraform import aws_s3_bucket.name "bucket name"
#terraform import aws_instance.name i-0f805ae729b101f2f