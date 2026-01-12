module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"   # we can give any github repo here
  # ami_id = "ami-01376101673c89611"
  instance_type = "t3.micro"
 # key_name      = "user1"
  subnet_id     = "subnet-eddcdzz4"
}