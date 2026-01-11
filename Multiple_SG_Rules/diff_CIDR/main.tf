resource "aws_security_group" "multi_cidr" {
  name        = "devops-multiple_cidr"
  description = "Allow restricted inbound traffic"

  ingress = [
    {
      description      = "SSH access from office network"
      from_port        = 22
      to_port          = 22
      protocol         = "tcp"
      cidr_blocks      = ["203.0.113.0/24"]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false  # our laptop IP address
    },
    {
      description      = "HTTP access for public users"
      from_port        = 80
      to_port          = 80
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"] 
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false # for public users
    },
    {
      description      = "HTTPS access for public users"
      from_port        = 443
      to_port          = 443
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false  # for Public access
    },
    {
      description      = "App access from internal VPC"
      from_port        = 8080
      to_port          = 8080
      protocol         = "tcp"
      cidr_blocks      = ["10.0.0.0/16"] 
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false #  for internal team/VPC CIDR
    }
    
  ]

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Multi-CIDR-SG"
  }
}