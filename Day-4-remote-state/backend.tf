terraform {
  # Configure a remote backend (e.g., AWS S3) for state storage
  backend "s3" {
    bucket = "tf-hima-statefile-bucket"
    key    = "terraform.tfstate"
    region = "us-east-1" 
  }
}