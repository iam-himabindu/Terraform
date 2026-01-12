
variable "db_instance_class" {
    type = string
    default = ""
    description = ""
}
variable "db_name" {
    type = string
    default = ""
    description = ""
}
variable "db_user" {}
variable "db_password" {}
variable "db_sg_id" {
    type = string
    default = ""
    description = ""
}
variable "subnet_ids" {}
variable "env" {}