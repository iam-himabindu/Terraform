################################ example1:without list varaible ###############################

# resource "aws_instance" "instance" {
#     ami = "ami-07ff62358b87c7116"
#     instance_type = "t2.micro"
#     count = 2
#     # tags = {
#     #   Name = "dev"
#     # }
#   tags ={
#     Name = "dev-${count.index}"
#   }
# }

################################ example-2 with variables list of string ###############################

variable "instance" {
    type = list(string)
    description = "EC2-Servers"
    default = ["dev","prod"]
  
}

resource "aws_instance" "name" {
    ami = "ami-07ff62358b87c7116"
    instance_type = "t2.micro"
   # key_name = "public"
    count = length(var.instance)
    tags = {
        Name = var.instance[count.index]  #instance will be created by calling the tags from variabels
    }
}

################################ example-3 creating IAM users  ###############################
variable "user_names" {
  description = "IAM usernames"
  type        = list(string)
  default     = ["user1", "user2", "user3"]
}
resource "aws_iam_user" "example" {
  count = length(var.user_names)
  name  = var.user_names[count.index]
}