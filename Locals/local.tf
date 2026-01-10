locals {
  environment = "development"
  instance_type = "t3.micro"
   ami = "ami-07ff62358b87c7116"
   availability_zone = "us-east-1a"
    name="Local-Instance"


}
locals {
  bucket-name = "local-code-hima-2026-9x3k" 
  force_destroy = true
  tags = {
    Name = "LocalBucket"
  } 
}
