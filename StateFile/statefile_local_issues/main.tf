resource "aws_instance" "name" {
    ami = "ami-085ad6ae776d8f09c"
    instance_type = "t2.micro"
    key_name = "ec2test"
    availability_zone = "us-east-1a"
    tags = {
      Name = "dev"
    }
   
  
}


#note Developers Overwriting Each Other’s Work if separe state file for same project
#Merge Conflicts in terraform.tfstate
#If two developers run terraform apply at the same time, one may overwrite the other's changes, causing unexpected resource modifications.
#both developers working independetly not collabrative 
#solution: maintain common ststefile to overocme above issues 