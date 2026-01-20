provider "aws" {
  region = "us-east-1c"
}



# Key Pair
resource "aws_key_pair" "name" {
    key_name = "devkey"
    public_key = file("~/.ssh/id_ed25519.pub")    # here you need to define public key file path

  
}

resource "aws_instance" "dev" {
  ami                    = "ami-07ff62358b87c7116"
  instance_type          = "t3.micro"
  key_name               = aws_key_pair.name.key_name
  tags = {
    Name="dev-server"
  }
}