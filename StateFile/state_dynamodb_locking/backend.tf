#creating s3 bucket and dynamo DB for state backend storgae and applying the lock mechanisam for statefile

# This backend configuration instructs Terraform to store its state in an S3 bucket.


terraform {
  # Configure a remote backend (e.g., AWS S3) for state storage
  backend "s3" {
    bucket = "ahegfuiahsiodohadsjkfjklzs"   # Name of the S3 bucket where the state will be stored.
    key    = "terraform.tfstate"     # Path within the bucket where the state will be read/written.
    region = "us-east-1" 
    # Enable S3 native locking
    # use_lockfile   = true    #terraform version must be avove 1.10
    dynamodb_table = "terraform-state-lock"        # The name of the DynamoDB table created 

    # DynamoDB table used for state locking 
    encrypt = true    # any version we can use dynamodb locking 
  }
}