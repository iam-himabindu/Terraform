# -------------------------
# VPC
# -------------------------
resource "aws_vpc" "this" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = var.tags
}

# -------------------------
# Public Subnet
# -------------------------
resource "aws_subnet" "main_subnet" {
  vpc_id                  = aws_vpc.this.id
  cidr_block              = var.main_subnet
  availability_zone       = var.availability_zone_1
  map_public_ip_on_launch = true
  tags = var.tags
}

# -------------------------
# Private Subnets (2 AZs)
# -------------------------
resource "aws_subnet" "public_az1" {
  vpc_id            = aws_vpc.this.id
  cidr_block        = var.public_az1
  availability_zone = var.availability_zone_1
  tags = var.tags
}

resource "aws_subnet" "public_az2" {
  vpc_id            = aws_vpc.this.id
  cidr_block        = var.public_az2
  availability_zone = var.availability_zone_2
  tags = var.tags
}

# -------------------------
# Internet Gateway
# -------------------------
resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id
  tags   = var.tags
}

# -------------------------
# Route Tables
# -------------------------
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }

  tags = var.tags
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.main_subnet.id
  route_table_id = aws_route_table.public.id
}

resource "aws_eip" "nat" {
  domain = "vpc"
}

resource "aws_nat_gateway" "this" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.main_subnet.id
  tags          = var.tags
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.this.id
  }

  tags = var.tags
}

resource "aws_route_table_association" "private" {
  subnet_id      = aws_subnet.public_az1.id
  route_table_id = aws_route_table.private.id
}

# -------------------------
# Security Group
# -------------------------
resource "aws_security_group" "this" {
  vpc_id = aws_vpc.this.id
  tags   = var.tags

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
  subnet_id                   = aws_subnet.main_subnet.id
  vpc_security_group_ids      = [aws_security_group.this.id]
  associate_public_ip_address = true
  tags = var.tags
}

resource "aws_instance" "private" {
  ami                    = var.ami_id
  instance_type          = var.private_instance_type
  subnet_id              = aws_subnet.public_az1.id
  vpc_security_group_ids = [aws_security_group.this.id]
  tags = var.tags
}

# -------------------------
# RDS
# -------------------------
resource "aws_db_subnet_group" "this" {
  name       = var.db_subnet_group_name
  subnet_ids = [aws_subnet.public_az2.id,aws_subnet.public_az1.id]
}


resource "aws_db_instance" "this" {
  allocated_storage      = var.allocated_storage
  engine                 = var.engine
  instance_class         = var.instance_class
  db_name                = var.db_name
  username               = var.db_username
  password               = var.db_password
  vpc_security_group_ids = [aws_security_group.this.id]
  db_subnet_group_name   = aws_db_subnet_group.this.name
  skip_final_snapshot    = true
}

# -------------------------
# S3
# -------------------------
resource "aws_s3_bucket" "this" {
  bucket = var.bucket_name
  force_destroy = true
  tags   = var.tags
}

resource "aws_s3_bucket_versioning" "this" {
  bucket = aws_s3_bucket.this.id

  versioning_configuration {
    status = var.versioning_status
  }
}

