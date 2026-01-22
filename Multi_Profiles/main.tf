
resource "aws_vpc" "demo" {
    cidr_block = "10.0.0.0/16"
    provider = aws.virginia
    tags = {
      Name="multi-vpc-virginia"
    }
  
}

resource "aws_s3_bucket" "name1" {
    bucket = "ajhdfjhasdfgjhskgfhjsfgjkjk"
    provider = aws.oregon
  
}


resource "aws_s3_bucket" "name2" {
    bucket = "hdfasjkfdaiowefahfdjnsmnnfjsb"
    provider = aws.virginia
  
}


#note we can use multi provider block if diff requiremnt and diff resource and diff regions