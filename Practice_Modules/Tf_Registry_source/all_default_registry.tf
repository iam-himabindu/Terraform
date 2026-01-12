# module "s3_bucket" {
#   source = "terraform-aws-modules/s3-bucket/aws"

#   bucket = "ashdfasidfahjdsfkshjvj"
#   acl    = "private"

#   control_object_ownership = true
#   object_ownership         = "ObjectWriter"

#   versioning = {
#     enabled = true
#   }
# }

module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"   # we can give any github repo here
  ami= "ami-07ff62358b87c7116"
  instance_type = "t3.micro"
  availability_zone = "us-east-1d"
 # key_name      = "user1"
  subnet_id     = "subnet-07f141b89f70602d4"
  tags = {
    Name:"bastion-host"
  }
}

# module "vpc" {
#   source = "terraform-aws-modules/vpc/aws"

#   name = "my-test-vpc"
#   cidr = "10.0.0.0/16"

#   azs             = ["us-east-1a", "us-east-1b", "us-east-1c"]
#   private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
#   public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

#   enable_nat_gateway = true
#   enable_vpn_gateway = true

#   tags = {
#     Terraform = "true"
#     Environment = "dev"
#   }
# }

# module "db" {
#   source = "terraform-aws-modules/rds/aws"

#   identifier = "demodb"

#   engine            = "mysql"
#   engine_version    = "8.0"
#   instance_class    = "db.t3a.large"
#   allocated_storage = 5

#   db_name  = "demodb"
#   username = "user"
#   port     = "3306"

#   iam_database_authentication_enabled = true

#   vpc_security_group_ids = ["sg-12345678"]

#   maintenance_window = "Mon:00:00-Mon:03:00"
#   backup_window      = "03:00-06:00"

#   # Enhanced Monitoring - see example for details on how to create the role
#   # by yourself, in case you don't want to create it automatically
#   monitoring_interval    = "30"
#   monitoring_role_name   = "MyRDSMonitoringRole"
#   create_monitoring_role = true

#   tags = {
#     Owner       = "user"
#     Environment = "dev"
#   }

#   # DB subnet group
#   create_db_subnet_group = true
#   subnet_ids             = ["subnet-12345678", "subnet-87654321"]

#   # DB parameter group
#   family = "mysql8.0"

#   # DB option group
#   major_engine_version = "8.0"

#   # Database Deletion Protection
#   deletion_protection = true

# }