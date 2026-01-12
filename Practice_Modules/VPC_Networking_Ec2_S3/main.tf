module "custom" {
  source = "../Modules/Custom_Network_Template"
  region="us-east-1"
  vpc="10.0.0.0/16"
  tags={
    Name="VPC-Custom"
  }
}

