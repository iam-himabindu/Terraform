# -------------------------
# VPC
# -------------------------
resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
  Name = var.tags["vpc"]
}

  
}

# -------------------------
# Public Subnets
# -------------------------
resource "aws_subnet" "publicsubnet1" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.publicsubnet1
  availability_zone       = var.availability_zone_1
  map_public_ip_on_launch = true
  tags = {
  Name = var.tags["public_subnet_1"]
}

  
}

resource "aws_subnet" "publicsubnet2" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.publicsubnet2
  availability_zone       = var.availability_zone_2
  map_public_ip_on_launch = true
  tags = {
  Name = var.tags["public_subnet_2"]
}

  
}

# -------------------------
# Private Subnets
# -------------------------
resource "aws_subnet" "privatesubnet" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.privatesubnet
  availability_zone = var.availability_zone_2
  tags = {
  Name = var.tags["private_subnet"]
}

  
}


# -------------------------
# Internet Gateway
# -------------------------
resource "aws_internet_gateway" "ig" {
  vpc_id = aws_vpc.vpc.id
  tags = {
  Name = var.tags["igw"]
}

  
}

# -------------------------
# Route Tables
# -------------------------
resource "aws_route_table" "publicRT" {
  vpc_id = aws_vpc.vpc.id
  tags = {
  Name = var.tags["public_rt"]
}


  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.ig.id
  }

  
}

resource "aws_route_table_association" "publicRTassociations" {
  subnet_id      = aws_subnet.publicsubnet1.id
  route_table_id = aws_route_table.publicRT.id
}

resource "aws_eip" "eip" {
  domain = "vpc"
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.eip.id
  subnet_id     = aws_subnet.publicsubnet1.id
  tags = {
  Name = var.tags["nat"]
}

  
}

resource "aws_route_table" "privateRT" {
  vpc_id = aws_vpc.vpc.id
  tags = {
  Name = var.tags["private_rt"]
}


  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }

  
}

resource "aws_route_table_association" "privateRTassociation" {
  subnet_id      = aws_subnet.privatesubnet.id
  route_table_id = aws_route_table.privateRT.id
}

# -------------------------
# Security Group
# -------------------------
resource "aws_security_group" "sg" {
  vpc_id = aws_vpc.vpc.id
  tags = {
  Name = var.tags["sg"]
}

  

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# -------------------------
# EC2
# -------------------------
resource "aws_instance" "bastion" {
  ami                         = var.ami_id
  instance_type               = var.bastion_instance_type
  subnet_id                   = aws_subnet.publicsubnet1.id
  vpc_security_group_ids      = [aws_security_group.sg.id]
  associate_public_ip_address = true
  tags = {
  Name = var.tags["bastion"]
}

  
}

resource "aws_instance" "private" {
  ami                    = var.ami_id
  instance_type          = var.private_instance_type
  subnet_id              = aws_subnet.privatesubnet.id
  vpc_security_group_ids = [aws_security_group.sg.id]
  tags = {
  Name = var.tags["private_instance"]
}

  
}

# -------------------------
# RDS
# -------------------------
resource "aws_db_subnet_group" "db_subnet_grp" {
  name       = var.db_subnet_group_name
  subnet_ids = [aws_subnet.publicsubnet1.id,aws_subnet.publicsubnet2.id]
}


resource "aws_db_instance" "rds" {
  allocated_storage      = var.allocated_storage
  engine                 = var.engine
  identifier = var.identifier
  instance_class         = var.instance_class
  db_name                = var.db_name
  username               = var.db_username
  password               = var.db_password
  vpc_security_group_ids = [aws_security_group.sg.id]
  db_subnet_group_name   = aws_db_subnet_group.db_subnet_grp.id
  backup_window = var.backup_window
  maintenance_window = var.maintenance_window
  backup_retention_period = 7
  #performance_insights_enabled    = true
  #performance_insights_retention_period = 7
  deletion_protection = true
  skip_final_snapshot    = true
}

# READ REPLICA

resource "aws_db_instance" "rds_read_replica" {
  identifier              = var.replica_identifier
  instance_class          = var.replica_instance_class

 replicate_source_db = aws_db_instance.rds.arn

  db_subnet_group_name    = aws_db_subnet_group.db_subnet_grp.id

  publicly_accessible     = false
  skip_final_snapshot     = true

}

# -------------------------
# S3
# -------------------------
resource "aws_s3_bucket" "s3" {
  bucket = var.aws_s3_bucket
  force_destroy = true
}


resource "aws_s3_bucket_acl" "acl" {
  bucket = aws_s3_bucket.s3.id
  acl    = var.acl
}

resource "aws_s3_bucket_ownership_controls" "owner" {
  bucket = aws_s3_bucket.s3.id

  rule {
    object_ownership = "ObjectWriter"
  }
}

resource "aws_s3_bucket_versioning" "version" {
  bucket = aws_s3_bucket.s3.id

  versioning_configuration {
    status = var.versioning
  }
} 