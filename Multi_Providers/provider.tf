# Provider-1 for us-east-1 (Default Provider)
provider "aws" {
  region = "us-east-1"
}

#Another provider alias 

provider "aws" {
    region = "us-west-2"
    alias = "oregon"
  
}