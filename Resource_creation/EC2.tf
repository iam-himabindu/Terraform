
resource "aws_instance" "name" {
    ami = "ami-08a6efd148b1f7504"
    instance_type = "t2.nano"
    key_name = "test-key"
    availability_zone = "us-east-1a"
    tags = {
      Name = "Instance"
    }
  
}