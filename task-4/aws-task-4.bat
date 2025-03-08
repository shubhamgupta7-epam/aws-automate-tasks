@echo off
setlocal enabledelayedexpansion

:: AWS Configuration
echo Configuring AWS CLI... Enter your credentials:
aws configure

:: Load config values from config.txt
for /f "tokens=1,2 delims==" %%A in (config.txt) do (
    set %%A=%%B
)

:: Attach KMS key policy to the IAM role
echo Attaching KMS key policy to the role: !iam_role_name!
aws iam put-role-policy --role-name !iam_role_name! --policy-name AllowAccessToKMSKey --policy-document file://policy-6.json

:: Enable server-side encryption for the destination bucket
echo Enabling bucket encryption for: !bucket_name_2!
aws s3api put-bucket-encryption --bucket !bucket_name_2! --server-side-encryption-configuration file://policy-7.json

:: Copy the object from source bucket to local machine
echo Downloading object from bucket: !bucket_name_1!
aws s3 cp s3://!bucket_name_1!/confidential_credentials.csv ./confidential_credentials.csv

:: Upload the object to the destination bucket
echo Uploading object to bucket: !bucket_name_2!
aws s3 cp ./confidential_credentials.csv s3://!bucket_name_2!/

:: Clean up local file
del confidential_credentials.csv

echo AWS tasks completed successfully!
pause
