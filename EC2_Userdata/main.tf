provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "dev" {
  ami = "ami-07ff62358b87c7116"
  instance_type = "t2.micro"
  availability_zone = "us-east-1b"
  # key_name = "public"
  user_data = file("test.sh")      # calling test.sh from current directory by using file fucntion
  tags = {
        Name = "userdata-server"
    }
}