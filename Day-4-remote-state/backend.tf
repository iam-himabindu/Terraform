terraform {
  # Configure a remote backend (e.g., AWS S3) for state storage
  backend "s3" {
    bucket = "udasfhiskasogfkfgjjkzsdklfg"
    key    = "terraform.tfstate"
    region = "us-east-1" 
    # Enable S3 native locking
    use_lockfile   = true 
  }
}