module "test" {
  source = "../../Modules/Custom_Network_Template"
  aws_region = "us-east-1"
  vpc_cidr = "10.0.0.0/16"
  tags = {
    Name="custom-vpc"
  }
} 