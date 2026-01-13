provider "aws" {
  region = "us-east-1"
}
module "network" {
  source = "../../Modules/Custom_Network_Template"

  vpc_cidr     = "10.0.0.0/16"
  
  publicsubnet1   = "10.0.1.0/24"
  publicsubnet2    = "10.0.2.0/24"
  privatesubnet    = "10.0.3.0/24"

  availability_zone_1  = "us-east-1a"
  availability_zone_2  = "us-east-1b"
  ami_id                = "ami-07ff62358b87c7116"
  bastion_instance_type = "t2.micro"
  
  private_instance_type = "t3.micro"

# ----------------------------------------------------------------------------------------------- ####

  db_name  = "mydb"
  engine = "mysql"
  identifier = "module-rds"
  db_subnet_group_name = "module-db-subnet-group"
  db_username = "admin"
  db_password = "devops123"
  allocated_storage = 20
  instance_class = "db.t3.micro"
  backup_window = "05:00-06:00"
  maintenance_window = "sun:04:00-sun:05:00"

  # READ REPLICA


  replica_identifier   = "jupitor-read-replica"
  replica_instance_class  = "db.t3.medium"

  
# ----------------------------------------------------------------------------------------------- ####

 aws_s3_bucket = "awuefuiahadfaidfjuhsdjk"
 acl = "private"
 aws_s3_bucket_ownership_controls="ObjectWriter"
 versioning = "Enabled"



  tags = {
    vpc              = "module-vpc"
    public_subnet_1  = "module-public-subnet-1"
    public_subnet_2  = "module-public-subnet-2"
    private_subnet   = "module-private-subnet"
    igw              = "module-igw"
    public_rt        = "module-public-rt"
    private_rt       = "module-private-rt"
    nat              = "module-nat"
    bastion          = "module-bastion"
    private_instance = "module-private-ec2"
    sg               = "module-sg"
  }
}
