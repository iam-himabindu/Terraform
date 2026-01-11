resource "aws_s3_bucket" "demo" {                     #terraform apply -target=aws_s3_bucket.demo  to apply specific resource 
    bucket = "testdemobucketfortarget" 
}


resource "aws_instance" "name" {
    ami = "ami-07ff62358b87c7116"                   #terraform apply -target=aws_instance.name
    instance_type = "t2.micro"                                                                                                        
    availability_zone = "us-east-1c"
    tags = {
        Name = "target-server"
    }
}

resource "aws_s3_bucket" "dependent" {                         #terraform apply -target=aws_s3_bucket.dependent
    bucket = "dependentbucketwithversion"                       #terraform destroy -target=aws_s3_bucket.dependent
}
resource "aws_s3_bucket_versioning" "versioning_example" {
  bucket = aws_s3_bucket.dependent.id
  versioning_configuration {
    status = "Enabled"
  }
}
#Example below for multiple targets
#terraform apply -target=aws_s3_bucket.dependent -target=aws_instance.dev -target=aws_db_instance.database
#try skip resource 

#target resource we can apply specific resource level only by using bellow command as the reference 
#terraform apply -target=aws_s3_bucket.demo
