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
    # count = var.create_ec2 ? 3 : 1
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

################################ example-4 creating VPC and Subnets  ###############################

variable "azs" {
  default = ["us-east-1a", "us-east-1b"]
}

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true
  tags = {
    Name = "Custom-VPC"
  }
}
resource "aws_subnet" "public" {
  count             = length(var.azs)
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.${count.index}.0/24"
  availability_zone = var.azs[count.index]

  tags = {
    Name = "public-${count.index}"
  }
}