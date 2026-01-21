variable "aws_s3_bucket" {
  description = "S3 bucket name"
  type        = string
}

variable "force_destroy" {
  
}

variable "acl" {
  description = "S3 bucket ACL"
  type        = string
  default     = "private"
}

variable "versioning" {
  description = "Enable S3 versioning"
  type        = bool
  default     = false
}

variable "environment" {
  description = "Environment name (dev, qa, prod)"
  type        = string
  default     = "dev"
}