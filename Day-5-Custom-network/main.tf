# creation of VPC
resource "aws_vpc" "vpc" {
    cidr_block = "10.0.0.0/16"
    enable_dns_support = true
    enable_dns_hostnames = true
    tags = {
      Name = "Terraform-VPC"
    }
  
}
# creation of subnets
resource "aws_subnet" "subnet1" {
    vpc_id = aws_vpc.vpc.id
    cidr_block = "10.0.0.0/24"
    availability_zone = "us-east-1a"
    tags = {
      Name ="Public subnet"
    }
  
}

resource "aws_subnet" "subnet2" {
    vpc_id = aws_vpc.vpc.id
    cidr_block = "10.0.1.0/24"
    availability_zone = "us-east-1b"
    tags = {
      Name ="Private subnet"
    }
  
}
# Internet gateway creation
resource "aws_internet_gateway" "ig" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "Internet Gateway"
  }
}

# Attaching Internet Gateway to VPC
#resource "aws_internet_gateway_attachment" "igattach" {
 # internet_gateway_id = aws_internet_gateway.ig.id
  #vpc_id = aws_vpc.vpc.id
#}

# creation of public route and edit routes
resource "aws_route_table" "publicRT" {
  vpc_id = aws_vpc.vpc.id
    tags = {
    Name = "Public RT"
  }
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.ig.id
  }
}
# public subnet association
resource "aws_route_table_association" "pubassociation" {
  subnet_id      = aws_subnet.subnet1.id
  route_table_id = aws_route_table.publicRT.id
}


#  Allocate an Elastic IP for the NAT Gateway
resource "aws_eip" "eip" {
tags = {
    Name = "nat-gateway-eip"
  }
}

#Create the NAT Gateway and associate it with the EIP
resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.eip.id   # Associate the EIP using its allocation ID
  subnet_id = aws_subnet.subnet2.id   # Place the NAT gateway in a public subnet
  tags = {
    Name = "NAT Gateway"
  }
}

# Create private route table edit routes and subnet association

# creation of private route and edit routes
resource "aws_route_table" "privateRT" {
  vpc_id = aws_vpc.vpc.id
    tags = {
    Name = "PRivate RT"
  }
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat_gw.id
  }
}
# private subnet association
resource "aws_route_table_association" "pvtassociation" {
  subnet_id      = aws_subnet.subnet2.id
  route_table_id = aws_route_table.privateRT.id
}

# Create security group
resource "aws_security_group" "cus_sg" {
  name   = "allow_tls"
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "cus_sg"
  }
  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"  # indicates all protocol
    cidr_blocks = ["0.0.0.0/0"]
  }
}
  
# launch the bastion host
resource "aws_instance" "ec2" {
    ami= "ami-068c0051b15cdb816"
    instance_type = "t3.micro"
    subnet_id = aws_subnet.subnet1.id
    vpc_security_group_ids = [aws_security_group.cus_sg.id]
    tags = {
      Name="Bastion Host"
    }
}

# launch the private server
resource "aws_instance" "ec21" {
    ami= "ami-068c0051b15cdb816"
    instance_type = "t2.micro"
    subnet_id = aws_subnet.subnet2.id
    vpc_security_group_ids = [aws_security_group.cus_sg.id]
    tags = {
      Name="Private Server"
    }
}