@echo off
setlocal

:: Load values from config.txt
for /f "tokens=1,2 delims==" %%A in (config.txt) do (
    if "%%A"=="IAM_ROLE_ASSUME_NAME" set IAM_ROLE_ASSUME_NAME=%%B
    if "%%A"=="IAM_ROLE_READONLY_NAME" set IAM_ROLE_READONLY_NAME=%%B
)

:: Check if values are loaded
if "%IAM_ROLE_ASSUME_NAME%"=="" (
    echo ERROR: IAM_ROLE_ASSUME_NAME not found in config.txt
    exit /b 1
)

if "%IAM_ROLE_READONLY_NAME%"=="" (
    echo ERROR: IAM_ROLE_READONLY_NAME not found in config.txt
    exit /b 1
)

:: Run AWS configure (optional — remove if not needed)
aws configure

:: Attach assume role policy
echo Attaching assume role policy to: %IAM_ROLE_ASSUME_NAME%
aws iam put-role-policy --role-name %IAM_ROLE_ASSUME_NAME% --policy-name assume_role_permissions --policy-document file://policy-4.json

:: Attach ReadOnlyAccess policy
echo Attaching ReadOnlyAccess policy to: %IAM_ROLE_READONLY_NAME%
aws iam attach-role-policy --role-name %IAM_ROLE_READONLY_NAME% --policy-arn arn:aws:iam::aws:policy/ReadOnlyAccess

:: Update the assume role policy
echo Updating assume role policy for: %IAM_ROLE_READONLY_NAME%
aws iam update-assume-role-policy --role-name %IAM_ROLE_READONLY_NAME% --policy-document file://policy-5.json

:: Done
echo Script execution complete!
pause
