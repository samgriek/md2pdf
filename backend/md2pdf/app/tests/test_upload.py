import boto3
import requests
import pytest
import uuid

def test_upload_file(object_name):
    # Set up AWS client
    session = boto3.Session(
        aws_access_key_id='AKIAQQ2GE4IV36E3NZAF',
        aws_secret_access_key='WDeCBCnGydPW1bswW9oSFJbtRdlU97T2Gnf2LLUQ',
        region_name='us-west-2'  # or your preferred region
    )
    s3_client = session.client('s3')

    # Generate pre-signed URL
    bucket_name = 'dev-video-upload-1' # replace with your file name
    presigned_url = s3_client.generate_presigned_url(
        'put_object',
        Params={'Bucket': bucket_name, 'Key': f"{uuid.uuid4()}-unit-test", 'ContentType': 'text/plain'},
        ExpiresIn=3600  # or your preferred expiration time in seconds
    )

    # Read file data
    with open(object_name, 'rb') as file:
        file_data = file.read()

    # Upload file using pre-signed URL
    response = requests.put(presigned_url, data=file_data, headers={'Content-Type': 'text/plain'})

    # Check response
    assert response.status_code == 200
