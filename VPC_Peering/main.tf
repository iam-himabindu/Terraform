provider "aws" {
  region = "us-east-1"
}


resource "aws_vpc" "vpc1" {
  cidr_block = "10.1.0.0/16"
}

resource "aws_vpc" "vpc2" {
  cidr_block = "10.2.0.0/16"
}

resource "aws_vpc_peering_connection" "foo" {
  peer_vpc_id   = aws_vpc.vpc1.id
  vpc_id        = aws_vpc.vpc2.id
  accepter {
    allow_remote_vpc_dns_resolution = true
  }
}