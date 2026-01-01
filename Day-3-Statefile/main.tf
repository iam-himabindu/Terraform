resource "aws_instance" "name" {
    ami="ami-08d7aabbb50c2c24e"
    instance_type="t3.micro"
    iam_instance_profile = "ec2-role"
    subnet_id = "subnet-0a8168aa33375682e"
}

