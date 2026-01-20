resource "aws_instance" "name" {
    ami = "ami-07ff62358b87c7116"
    instance_type = "t2.micro"
    availability_zone = "us-east-1c"
    tags = {
      Name = "Lifecycle-1"
    }
  

lifecycle {
      #prevent_destroy = true     # this attribute will create the new object first and then destroy the old one
      create_before_destroy = true        #Terraform will error when it attempts to destroy a resource when this is set to true
      #ignore_changes = [ tags,instance_type,]      # This attribute will never update the object but will be able to create or destroy it.

    }
}
