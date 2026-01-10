####### with data source ###########
data "aws_subnet" "subnet-1" {
  filter {
    name   = "tag:Name"           
    values = ["datasource-1"]       # subnet_id = 02870a06686b1f2cc
  }
}

data "aws_subnet" "subnet-2" {
  filter {
    name   = "tag:Name"
    values = ["datasource-2"]      # subnet_id = 067a65641a59884fe
  }
}

data "aws_subnet" "subnet-3" {
  filter {
    name   = "tag:Name"
    values = ["instance-subnet"]        # subnet_id = 06d97c921bb611a2b
  }
}
resource "aws_db_subnet_group" "sub-grp" {
  name       = "rds-subnet-group"
  subnet_ids = [data.aws_subnet.subnet-1.id, data.aws_subnet.subnet-2.id]

  tags = {
    Name = "My DB subnet group"
  }
}

resource "aws_instance" "name" {
    ami = data.aws_ami.amzlinux.id
    instance_type = "t2.micro"          
    subnet_id = data.aws_subnet.subnet-3.id   # subnet_id = 06d97c921bb611a2b


    tags = {
        Name = "Datasource-instance"
    }
}

#calling Default AMI process aas a Data source

data "aws_ami" "amzlinux" {
  most_recent = true
  owners = [ "amazon" ]
  filter {
    name = "name"
    values = [ "amzn2-ami-hvm-*-gp2" ]
  }
  filter {
    name = "root-device-type"
    values = [ "ebs" ]
  }
  filter {
    name = "virtualization-type"
    values = [ "hvm" ]
  }
  filter {
    name = "architecture"
    values = [ "x86_64" ]
  }
}

# data "aws_ami" "amzlinux" {
#   most_recent = true
#   owners = [ "self" ]
#   filter {
#     name = "name"
#     values = [ "frontend-ami" ]
#   }

# }

