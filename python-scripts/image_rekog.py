import boto3

def lambda_handler(event, context):
    client = boto3.client("rekognition")

    for record in event["Records"]:
        bucket_name = record["s3"]["bucket"]["name"]
        image_obj = record["s3"]["object"]["key"]

    print(bucket_name)
    print(image_obj)