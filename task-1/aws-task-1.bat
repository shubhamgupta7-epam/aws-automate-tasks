@echo off
setlocal

for /f "tokens=1,2 delims==" %%A in (config.txt) do (
    if "%%A"=="ROLE_NAME" set ROLE_NAME=%%B
    if "%%A"=="BUCKET_NAME" set BUCKET_NAME=%%B
)

if "%ROLE_NAME%"=="" (
    echo ERROR: ROLE_NAME not found in config.txt
    exit /b 1
)

if "%BUCKET_NAME%"=="" (
    echo ERROR: BUCKET_NAME not found in config.txt
    exit /b 1
)

aws configure
aws iam attach-role-policy --policy-arn arn:aws:iam::aws:policy/AmazonS3FullAccess --role-name %ROLE_NAME%
aws s3api put-bucket-policy --bucket %BUCKET_NAME% --policy file://policy-1.json

echo Script execution complete!
pause
