@echo off
setlocal

:: Read values from config.txt
for /f "tokens=1,2 delims==" %%A in (config.txt) do (
    if "%%A"=="ROLE_NAME" set ROLE_NAME=%%B
    if "%%A"=="BUCKET_NAME" set BUCKET_NAME=%%B
)

:: Check if values are loaded
if "%ROLE_NAME%"=="" (
    echo ERROR: ROLE_NAME not found in config.txt
    exit /b 1
)

if "%BUCKET_NAME%"=="" (
    echo ERROR: BUCKET_NAME not found in config.txt
    exit /b 1
)

:: Run AWS configuration
aws configure

:: Attach the inline role policy
echo Attaching policy to role: %ROLE_NAME%
aws iam put-role-policy --role-name %ROLE_NAME% --policy-name allow_list_buckets --policy-document file://policy-2.json

:: Apply the bucket policy
echo Applying policy to bucket: %BUCKET_NAME%
aws s3api put-bucket-policy --bucket %BUCKET_NAME% --policy file://policy-3.json

:: Done
echo Script execution complete!
pause
