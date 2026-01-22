provider "aws" {
    region = "us-east-1"
    alias = "virginia"
    profile = "dev"

  
}
provider "aws" {
    region = "us-west-2"
     profile = "default"
    alias = "oregon"
  
}