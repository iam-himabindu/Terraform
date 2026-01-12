module "name" {
source = "github.com/CloudTechDevOps/terraform-us/day-4-modules"  # we can give any github repo here
ami_id = "ami-01376101673c89611"
instance_type = "t2.micro"
# key = "public"
    
 }