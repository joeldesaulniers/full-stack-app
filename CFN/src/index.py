import boto3
import os

def handler(event, context):
    return {
        'statusCode': 200,
        'body': 'Hello from CloudFormation ! This is my python app.'
    }
