terraform {
  # Configure a remote backend (e.g., AWS S3) for state storage
  backend "s3" {
    bucket = "ahegfuiahsiodohadsjkfjklzs"
    key    = "terraform.tfstate"
    region = "us-east-1" 
    # Enable S3 native locking
    # use_lockfile   = true    #terraform version must be avove 1.10
    dynamodb_table = "terraform-state-lock"        # The name of the DynamoDB table created
    encrypt = true
  }
}