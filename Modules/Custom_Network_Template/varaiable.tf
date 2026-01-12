variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = ""
}

variable "vpc_name" {
  description = "VPC name"
  type        = string
  default     = ""
}

variable "vpc_cidr" {
  description = "VPC CIDR block"
  type        = string
  default     = ""
}

variable "public_subnet_cidr" {
  description = "Public subnet CIDR"
  type        = string
  default     = "10.0.0.0/24"
}

variable "private_subnet_cidr" {
  description = "Private subnet CIDR"
  type        = string
  default     = "10.0.1.0/24"
}

variable "public_az" {
  description = "Public subnet AZ"
  type        = string
  default     = "us-east-1a"
}

variable "private_az" {
  description = "Private subnet AZ"
  type        = string
  default     = "us-east-1b"
}

variable "ami_id" {
  description = "AMI ID for EC2 instances"
  type        = string
  default     = "ami-068c0051b15cdb816"
}

variable "bastion_instance_type" {
  description = "Instance type for bastion host"
  type        = string
  default     = "t3.micro"
}

variable "private_instance_type" {
  description = "Instance type for private server"
  type        = string
  default     = "t2.micro"
}

variable "key_name" {
  description = "EC2 key pair name"
  type        = string
  default     = "public"
}



# -------------------------
# Network
# -------------------------
variable "vpc_id" {
  description = "VPC ID where RDS will be deployed"
  type        = string
}

variable "db_subnet_ids" {
  description = "List of subnet IDs for DB subnet group"
  type        = list(string)
}

variable "mysql_allowed_cidr" {
  description = "CIDR blocks allowed to access MySQL"
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

# -------------------------
# Naming
# -------------------------
variable "db_subnet_group_name" {
  description = "DB subnet group name"
  type        = string
  default     = "dev-db-subnet-group"
}

variable "rds_sg_name" {
  description = "RDS Security Group name"
  type        = string
  default     = "dev-rds-sg"
}

variable "rds_monitoring_role_name" {
  description = "IAM role name for RDS enhanced monitoring"
  type        = string
  default     = "rds-monitoring-role"
}

variable "db_identifier" {
  description = "RDS instance identifier"
  type        = string
  default     = "dev-mysql-db"
}

# -------------------------
# RDS Configuration
# -------------------------
variable "allocated_storage" {
  description = "Allocated storage in GB"
  type        = number
  default     = 10
}

variable "db_name" {
  description = "Initial database name"
  type        = string
  default     = "mydb"
}

variable "engine_version" {
  description = "MySQL engine version"
  type        = string
  default     = "8.0"
}

variable "instance_class" {
  description = "RDS instance class"
  type        = string
  default     = "db.t3.micro"
}

variable "db_username" {
  description = "Master username"
  type        = string
}

variable "db_password" {
  description = "Master password"
  type        = string
  sensitive   = true
}

variable "parameter_group_name" {
  description = "DB parameter group"
  type        = string
  default     = "default.mysql8.0"
}

# -------------------------
# Backup & Monitoring
# -------------------------
variable "backup_retention_days" {
  description = "Backup retention period"
  type        = number
  default     = 7
}

variable "backup_window" {
  description = "Backup window"
  type        = string
  default     = "02:00-03:00"
}

variable "monitoring_interval" {
  description = "Enhanced monitoring interval (seconds)"
  type        = number
  default     = 60
}

variable "performance_insights_retention_days" {
  description = "Performance Insights retention"
  type        = number
  default     = 7
}

variable "maintenance_window" {
  description = "Maintenance window"
  type        = string
  default     = "sun:04:00-sun:05:00"
}


# -------------------------
# S3 Configuration
# -------------------------
variable "bucket_name" {
  description = "S3 bucket name (must be globally unique)"
  type        = string
}

variable "bucket_tag_name" {
  description = "Name tag for the S3 bucket"
  type        = string
  default     = "my-normal-terraform-s3-bucket"
}

variable "environment" {
  description = "Environment tag"
  type        = string
  default     = "dev"
}

variable "bucket_acl" {
  description = "ACL for the S3 bucket"
  type        = string
  default     = "private"
}

variable "object_ownership" {
  description = "S3 object ownership setting"
  type        = string
  default     = "BucketOwnerPreferred"
}

variable "versioning_status" {
  description = "Enable or suspend versioning"
  type        = string
  default     = "Enabled"
}
