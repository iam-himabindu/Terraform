import json
import datetime

def lambda_handler(event, context):
    current_time = datetime.datetime.utcnow().isoformat()

    print("Lambda triggered successfully!")
    print(f"Event received: {json.dumps(event)}")
    print(f"Execution time (UTC): {current_time}")

    return {
        "statusCode": 200,
        "body": json.dumps({
            "message": "Scheduled Lambda executed successfully",
            "time": current_time
        })
    }
