terraform {
    #required_version = ">=1.10" # this will allow to work same terraform version only 
  # Configure a remote backend (e.g., AWS S3) for state storage
  backend "s3" {
    bucket = "udasfhiskasogfkfgjjkzsdklfg"
    key    = "terraform.tfstate"
    region = "us-east-1" 
    # Enable S3 native locking
    use_lockfile   = true  #s3 supports this feature but teraaform version > 1.10, latest version >=1.10
    # The dynamodb_table argument is no longer needed
  }
}