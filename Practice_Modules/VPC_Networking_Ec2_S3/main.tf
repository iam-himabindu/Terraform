provider "aws" {
  region = "us-east-1"
}

module "network" {
  source = "../../Modules/Custom_Network_Template"

  vpc_cidr             = "10.0.0.0/16"
  main_subnet          = "10.0.1.0/24"
  public_az1     = "10.0.2.0/24"
  public_az2   = "10.0.3.0/24"

  availability_zone_1  = "us-east-1a"
  availability_zone_2  = "us-east-1b"
  ami_id                = "ami-07ff62358b87c7116"
  bastion_instance_type = "t2.micro"
  private_instance_type = "t3.micro"

  db_name     = "mydb"
  engine = "mysql"
  db_subnet_group_name = "my-db-subnet-group"
  db_username = "admin"
  db_password = "devops123"
  allocated_storage = 20
  instance_class = "db.t3.micro"
  versioning_status = "Enabled"

  bucket_name = "awuefuiahadfaidfjuhsdjk"

  tags = {
    Name = "custom-module"
    Env  = "dev"
  }
}

