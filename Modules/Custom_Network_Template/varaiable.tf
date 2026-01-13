
variable "vpc_cidr" {
  type = string
}

variable "main_subnet" {
  type = string
}

variable "public_az1" {
  type = string
}

variable "public_az2" {
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

variable "tags" {
  type = map(string)
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

variable "instance_class" {
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
variable "bucket_name" {
  type = string
}

variable "versioning_status" {
  type    = string
  default = ""
}
