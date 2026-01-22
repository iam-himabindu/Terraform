provider "aws" {
  region = "us-east-1"
}

# Key Pair
resource "aws_key_pair" "example" {
  key_name   = "task"
  public_key = file("~/.ssh/id_ed25519.pub")
}

# EC2 Instance (Ubuntu)
resource "aws_instance" "server" {
  ami           = "ami-0b6c6ebed2801a5cb"  # Ubuntu AMI
  instance_type = "t2.micro"
  key_name  = aws_key_pair.example.key_name
  associate_public_ip_address = true

  tags = {
    Name = "Ubuntu-Server"
  }
}

# Null Resource to run remote commands on EC2
resource "null_resource" "run_script" {
  # Remote-exec provisioner runs commands on the EC2
  provisioner "remote-exec" {
    connection {
      host        = aws_instance.server.public_ip
      user        = "ubuntu"
      private_key = file("~/.ssh/id_ed25519")
    }

    inline = [
  "echo 'Hello this is Terraform Remote Execution!' >> /home/ubuntu/remote_test.txt",
  "ls -l /home/ubuntu/remote_test.txt"
]
  }
  # Triggers force rerun every apply

  triggers = {
    always_run = "${timestamp()}" #### Forces re-run every time
  }
}

  