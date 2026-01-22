

provider "aws" {
  region = var.region
  profile = "prod"
}

module "vpc" {
  source              = "../../Modules/VPC"
  cidr_block          = var.vpc_cidr
  public_subnet_cidr  = var.public_subnet_cidr
  availability_zone   = var.availability_zone
  env                 = var.env
}
module "ec2" {
  source        = "../../Modules/EC2"
  instance_type = var.instance_type
  env           = var.env
  ami_id = var.ami_id
  subnet_id = module.vpc.public_subnet_id
}
