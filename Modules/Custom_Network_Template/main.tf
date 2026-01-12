provider "aws" {
  region = var.aws_region
}

# # -------------------------
# # VPC
# # -------------------------
# resource "aws_vpc" "vpc" {
#   cidr_block           = var.vpc_cidr
#   enable_dns_support   = true
#   enable_dns_hostnames = true
#   tags = var.tags
# }

# # -------------------------
# # Subnets
# # -------------------------
# resource "aws_subnet" "subnet1" {
#   vpc_id                  = aws_vpc.vpc.id
#   cidr_block              = var.public_subnet
#   availability_zone       = var.availability_zone
#   map_public_ip_on_launch = true
#   tags =var.tags
# }

# resource "aws_subnet" "subnet2" {
#   vpc_id            = aws_vpc.vpc.id
#   cidr_block        = var.private_subnet
#   availability_zone = var.availability_zone
#   tags = var.tags
#}

# # -------------------------
# # Internet Gateway
# # -------------------------

# resource "aws_internet_gateway" "ig" {
#   vpc_id = aws_vpc.vpc.id
#   tags = var.tags
# }

# # -------------------------
# # Public Route Table
# # -------------------------
# resource "aws_route_table" "publicRT" {
#   vpc_id = aws_vpc.vpc.id
#   tags =var.tags

#   route {
#     cidr_block = "0.0.0.0/0"
#     gateway_id = aws_internet_gateway.ig.id
#   }
# }

# resource "aws_route_table_association" "pubassociation" {
#   subnet_id      = aws_subnet.subnet1.id
#   route_table_id = aws_route_table.publicRT.id
# }

# # -------------------------
# # NAT Gateway
# # -------------------------
# resource "aws_eip" "eip" {
#   domain = var.vpc_id
#   tags = var.tags
# }

# resource "aws_nat_gateway" "nat_gw" {
#   allocation_id = aws_eip.eip.id
#   subnet_id     = aws_subnet.subnet1.id   # NAT must be in PUBLIC subnet
#   tags =var.tags
# }

# # -------------------------
# # Private Route Table
# # -------------------------
# resource "aws_route_table" "privateRT" {
#   vpc_id = aws_vpc.vpc.id
#    tags = var.tags

#   route {
#     cidr_block     = "0.0.0.0/0"
#     nat_gateway_id = aws_nat_gateway.nat_gw.id
#   }
#    }


# resource "aws_route_table_association" "pvtassociation" {
#   subnet_id      = aws_subnet.subnet2.id
#   route_table_id = aws_route_table.privateRT.id
# }

# # -------------------------
# # Security Group
# # -------------------------
# resource "aws_security_group" "cus_sg" {
#   name   = "allow_tls"
#   vpc_id = aws_vpc.vpc.id
#   tags = var.tags
  
#   ingress {
#     description = "HTTP"
#     from_port   = 80
#     to_port     = 80
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   ingress {
#     description = "SSH"
#     from_port   = 22
#     to_port     = 22
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   ingress {
#     description = "HTTPS"
#     from_port   = 443
#     to_port     = 443
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
#  }

# # -------------------------
# # Bastion Host (Public EC2)
# # -------------------------
# resource "aws_instance" "bastion" {
#   ami                         = var.ami_id
#   instance_type               = var.bastion_instance_type
#   #key_name                    = var.key_name
#   subnet_id                   = aws_subnet.subnet1.id
#   vpc_security_group_ids      = [aws_security_group.cus_sg.id]
#   associate_public_ip_address = true
#   tags = var.tags
# }

# # -------------------------
# # Private EC2 Instance
# # -------------------------
# resource "aws_instance" "private_server" {
#   ami                    = var.ami_id
#   instance_type          = var.private_instance_type
#   #key_name               = var.key_name
#   subnet_id              = aws_subnet.subnet2.id
#   vpc_security_group_ids = [aws_security_group.cus_sg.id]
#   tags =var.tags
# }


# # -------------------------
# # DB Subnet Group
# # -------------------------
# resource "aws_db_subnet_group" "dev_db_subnet_group" {
#   name       = var.db_subnet_group_name
#   subnet_ids = var.db_subnet_ids

#   tags = {
#     Name = var.db_subnet_group_name
#   }
# }

# # -------------------------
# # Security Group for RDS
# # -------------------------
# resource "aws_security_group" "dev_rds_sg" {
#   name   = var.rds_sg_name
#   vpc_id = var.vpc_id

#   tags = {
#     Name = var.rds_sg_name
#   }

#   # Allow MySQL traffic
#   ingress {
#     from_port   = 3306
#     to_port     = 3306
#     protocol    = "tcp"
#     cidr_blocks = var.mysql_allowed_cidr
#   }

#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
# }

# # -------------------------
# # IAM Role for RDS Enhanced Monitoring
# # -------------------------
# resource "aws_iam_role" "rds_monitoring" {
#   name = var.rds_monitoring_role_name

#   assume_role_policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [{
#       Effect = "Allow"
#       Action = "sts:AssumeRole"
#       Principal = {
#         Service = "monitoring.rds.amazonaws.com"
#       }
#     }]
#   })
# }

# # -------------------------
# # IAM Policy Attachment
# # -------------------------
# resource "aws_iam_role_policy_attachment" "rds_monitoring_attach" {
#   role       = aws_iam_role.rds_monitoring.name
#   policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonRDSEnhancedMonitoringRole"
# }

# # -------------------------
# # RDS MySQL Instance
# # -------------------------
# resource "aws_db_instance" "default" {
#   allocated_storage = var.allocated_storage
#   db_name           = var.db_name
#   engine            = "mysql"
#   engine_version    = var.engine_version
#   instance_class    = var.instance_class

#   username = var.db_username
#   password = var.db_password

#   db_subnet_group_name = aws_db_subnet_group.dev_db_subnet_group.name
#   vpc_security_group_ids = [aws_security_group.dev_rds_sg.id]

#   # parameter_group_name = var.parameter_group_name

#   # Backup configuration
#   backup_retention_period = var.backup_retention_days
#   backup_window           = var.backup_window

#   # Enhanced Monitoring
#   monitoring_interval = var.monitoring_interval
#   monitoring_role_arn = aws_iam_role.rds_monitoring.arn

#   # Performance Insights
#   performance_insights_enabled          = true
#   performance_insights_retention_period = var.performance_insights_retention_days

#   # Maintenance
#   maintenance_window = var.maintenance_window

#   # Safety
#   deletion_protection = true
#   skip_final_snapshot = true

#   tags = {
#     Name = var.db_identifier
#   }
# }

# # -------------------------
# # S3 Bucket
# # -------------------------
# resource "aws_s3_bucket" "example" {
#   bucket = var.bucket_name

#   tags = {
#     Name        = var.bucket_tag_name
#     Environment = var.environment
#   }
# }

# # -------------------------
# # Ownership Controls
# # -------------------------
# resource "aws_s3_bucket_ownership_controls" "example" {
#   bucket = aws_s3_bucket.example.id

#   rule {
#     object_ownership = var.object_ownership
#   }
# }

# # -------------------------
# # Bucket ACL
# # -------------------------
# resource "aws_s3_bucket_acl" "example" {
#   depends_on = [aws_s3_bucket_ownership_controls.example]

#   bucket = aws_s3_bucket.example.id
#   acl    = var.bucket_acl
# }

# # -------------------------
# # Versioning
# # -------------------------
# resource "aws_s3_bucket_versioning" "example" {
#   bucket = aws_s3_bucket.example.id

#   versioning_configuration {
#     status = var.versioning_status
#   }
# }
