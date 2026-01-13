
variable "vpc_cidr" {
  type = string
}

variable "publicsubnet1" {
  type = string
}

variable "publicsubnet2" {
  type = string
}

variable "privatesubnet" {
  type = string
}
variable "availability_zone_1" {
  type = string
}

variable "availability_zone_2" {
  type = string
}

variable "ami_id" {
  type = string
}

variable "bastion_instance_type" {
  type = string
}

variable "private_instance_type" {
  type = string
}
 

# -------------------------
# RDS
# -------------------------
variable "db_name" {
  type = string
}

variable "db_username" {
  type = string
}

variable "db_password" {
  type      = string
  sensitive = true
}
variable "identifier" {
  
}
variable "instance_class" {
  type    = string
  default = ""
}
variable "backup_window" {
  
}
variable "maintenance_window" {
  
}

variable "replica_identifier" {
  
}
variable "replica_instance_class" {
  type    = string
  default = ""
}
variable "db_subnet_group_name" {
  
}
variable "allocated_storage" {
  
}
variable "engine" {
  
}

# -------------------------
# S3
# -------------------------
variable "aws_s3_bucket" {
  description = "S3 bucket name"
  type        = string
}

variable "acl" {
  description = "S3 bucket ACL"
  type        = string
  default     = ""
}
variable "aws_s3_bucket_ownership_controls" {
  
}

variable "versioning" {
  description = "Enable S3 versioning"
  # type        = bool
  # default     = ""
}

variable "tags" {
  type = map(string)
}
