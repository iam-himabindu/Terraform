variable "ami_id" {
    type = string
    default = ""
    description = "passing ami value to main"
}

variable "instance_type" {
    type = string
    default = ""
    description = "passing the values of inttance type"
  
}
variable "subnet_1_id" {
  type = string
    default = ""
    description = "passing the values of subnet id"
}

# variable "subnet_2_id" {
#   type = string
#     default = ""
#     description = "passing the values of subnet id"
# }
variable "key" {
    type = string
    default = ""
    description = "passing the values of key"
  
}

variable "tags" {}

