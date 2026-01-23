provider "aws" {
  region = "us-east-1"
}

resource "aws_sns_topic" "my_topic" {
  name = "devops-alerts"
}


resource "aws_sns_topic_subscription" "email_subscription" {
  topic_arn = aws_sns_topic.my_topic.arn
  protocol  = "email"
  endpoint  = "your-email@example.com"
}