resource "aws_db_instance" "rds" {
  allocated_storage       = 15
  db_name                 = "mydb"
  identifier              = "jupitor"
  engine                  = "mysql"
  engine_version          = "8.0"
  instance_class          = "db.t3.medium"
  username                = "admin"
  password                = "Italy328"
  db_subnet_group_name    = aws_db_subnet_group.sub-grp.id
  parameter_group_name    = "default.mysql8.0"

  # Enable backups and retention
  backup_retention_period  = 7   # Retain backups for 7 days
  backup_window            = "05:00-06:00" # Daily backup window (UTC)

  # Enable monitoring (CloudWatch Enhanced Monitoring)
  # monitoring_interval      = 60  # Collect metrics every 60 seconds
  # monitoring_role_arn      = aws_iam_role.rds_monitoring.arn

  # Enable performance insights
  performance_insights_enabled          = true
  performance_insights_retention_period = 7  # Retain insights for 7 days

  # Maintenance window
  maintenance_window = "sun:04:00-sun:05:00"  # Maintenance every Sunday (UTC)

  # Enable deletion protection (to prevent accidental deletion)
  deletion_protection = true

  # Skip final snapshot
  skip_final_snapshot = true
}



resource "aws_vpc" "name" {
    cidr_block = "10.0.0.0/16"
    tags = {
      Name = "SolarSystem"
    }
  
}
resource "aws_subnet" "subnet-1" {
    vpc_id = aws_vpc.name.id
    cidr_block = "10.0.0.0/24"
    availability_zone = "us-east-1a"
    tags = {
      Name="Mercury"
    }
  
}
resource "aws_subnet" "subnet-2" {
    vpc_id = aws_vpc.name.id
    cidr_block = "10.0.1.0/24"
    availability_zone = "us-east-1b"
    tags = {
      Name="Venus"
    }
  
}
resource "aws_db_subnet_group" "sub-grp" {
  name       = "mycutsubnett"
  subnet_ids = [aws_subnet.subnet-1.id, aws_subnet.subnet-2.id]

  tags = {
    Name = "Jupitor subnet group"
  }
}

# launch the bastion host
resource "aws_instance" "ec2" {
    ami= "ami-068c0051b15cdb816"
    instance_type = "t3.micro"
    tags = {
      Name="Bastion Host"
    }
}
