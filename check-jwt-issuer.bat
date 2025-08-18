@echo off
chcp 65001 >nul
echo Checking JWT Token Issuer...
echo.
echo This script will help verify that JWT tokens have the correct issuer
echo.
echo Prerequisites:
echo - Keycloak must be running
echo - Realm and client must be configured
echo.
echo Press any key to continue...
pause >nul
echo.
echo 1. Getting JWT token from Keycloak...
echo.
echo Requesting token for workout-client...
echo.
set /p CLIENT_SECRET="Enter client secret (or press Enter to use default): "
if "%CLIENT_SECRET%"=="" set CLIENT_SECRET=your-client-secret-here
echo.
echo 2. Making token request...
curl -X POST "http://localhost:8081/realms/workout-realm/protocol/openid-connect/token" ^
  -H "Content-Type: application/x-www-form-urlencoded" ^
  -d "grant_type=client_credentials" ^
  -d "client_id=workout-client" ^
  -d "client_secret=%CLIENT_SECRET%" ^
  -s > token_response.json
echo.
echo 3. Checking response...
if exist token_response.json (
    echo [OK] Token response received
    echo.
    echo 4. Extracting access token...
    powershell -Command "(Get-Content token_response.json | ConvertFrom-Json).access_token" > token.txt
    if exist token.txt (
        echo [OK] Access token extracted
        echo.
        echo 5. Decoding JWT token...
        echo.
        echo Token header:
        powershell -Command "$token = Get-Content token.txt; $parts = $token.Split('.'); [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($parts[0])) | ConvertFrom-Json | ConvertTo-Json -Depth 10"
        echo.
        echo Token payload:
        powershell -Command "$token = Get-Content token.txt; $parts = $token.Split('.'); [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($parts[1])) | ConvertFrom-Json | ConvertTo-Json -Depth 10"
        echo.
        echo 6. Checking issuer claim...
        powershell -Command "$token = Get-Content token.txt; $parts = $token.Split('.'); $payload = [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($parts[1])) | ConvertFrom-Json; Write-Host 'Issuer (iss):' $payload.iss; Write-Host 'Audience (aud):' $payload.aud; Write-Host 'Subject (sub):' $payload.sub"
        echo.
        echo 7. Expected vs Actual:
        echo Expected issuer: http://keycloak:8080/realms/workout-realm
        echo.
        echo 8. Testing token with backend...
        set /p TOKEN=<token.txt
        echo Testing API call with token...
        curl -H "Authorization: Bearer %TOKEN%" http://localhost:8080/api/workouts -v
        echo.
        echo 9. Cleanup...
        del token_response.json token.txt 2>nul
        echo.
        echo 10. Troubleshooting:
        echo.
        if "%CLIENT_SECRET%"=="your-client-secret-here" (
            echo [WARNING] You used default client secret
            echo Please get the real client secret from Keycloak Admin Console
            echo.
        )
        echo If issuer is wrong, check Keycloak configuration:
        echo - KC_HOSTNAME should be 'keycloak' (not 'localhost')
        echo - KC_HOSTNAME_PORT should be 8080
        echo - Backend should use 'http://keycloak:8080/realms/workout-realm'
        echo.
        echo If you need to restart with correct config, run: restart-with-jwt-fix.bat
    ) else (
        echo [ERROR] Failed to extract access token
    )
) else (
    echo [ERROR] Failed to get token response
    echo.
    echo Possible issues:
    echo - Keycloak not running
    echo - Realm not configured
    echo - Client not configured
    echo - Wrong client secret
)
echo.
pause
