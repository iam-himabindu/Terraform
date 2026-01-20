
variable "servers" {
    type = list(string)
    default = ["Dev","UAT"]
  
}

resource "aws_instance" "name" {
    ami = "ami-07ff62358b87c7116"
    instance_type = "t3.micro"
    availability_zone = "us-east-1d"
    for_each = toset(var.servers) # toset not follows any order like list (index)
    tags = {
        Name = each.value   #instance will be creatted by calling the tags from variabels                        
    }                                           # for a set, each.value and each.key is the same
}