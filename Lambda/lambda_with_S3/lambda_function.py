def lambda_handler(event, context):
    return {
        "statusCode": 200,
        "body": "Hello from Lambda uploaded via S3 using Terraform!"
    }
