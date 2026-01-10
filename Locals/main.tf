
resource "aws_instance" "dev" {
  ami           = local.ami          # Amazon Linux 2 AMI
  instance_type = local.instance_type
  availability_zone = local.availability_zone
 
 tags = {
   Environment = local.environment
   Name=local.name
 }

  }



resource "aws_s3_bucket" "demo" {
    
    bucket = local.bucket-name
    force_destroy = local.force_destroy
    tags = local.tags
    
}



