module "dev" {
    source = "../../Modules/Ec2_Template"
    ami_id = "ami-07ff62358b87c7116"
    instance_type = "t2.micro"
    #key = "public"
    tags = {
        Name = "custom-ec2-module"
    }
  
}