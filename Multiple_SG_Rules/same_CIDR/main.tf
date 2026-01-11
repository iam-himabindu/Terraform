resource "aws_instance" "demo" {
  ami                    = "ami-07ff62358b87c7116"      #change ami id for different region
  instance_type          = "t2.micro"
  availability_zone = "us-east-1c" 
  tags = {
    Name = "same-CIDR"
  }
}


resource "aws_security_group" "same_cidr" {
  name        = "devops_same_CIDR"
  description = "Allow TLS inbound traffic"

  ingress = [
    for port in [22, 80, 443, 8080, 9000, 3000, 8082, 8081] : {
      description      = "inbound rules"
      from_port        = port
      to_port          = port
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    }
  ]

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "MainSG"
  }
}