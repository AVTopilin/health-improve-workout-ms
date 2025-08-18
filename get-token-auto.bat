@echo off
chcp 65001 >nul
echo Automatic JWT token retrieval from Keycloak...
echo.
echo Checking Keycloak availability...
curl -s http://localhost:8081/health >nul
if %errorlevel% neq 0 (
    echo [ERROR] Keycloak is not available at http://localhost:8081
    echo Make sure Keycloak is running: docker-compose ps keycloak
    pause
    exit /b 1
)
echo [OK] Keycloak is available
echo.
echo Getting JWT token...
echo.
echo Using PowerShell to get token...
powershell -ExecutionPolicy Bypass -Command "try { $body = @{ grant_type = 'password'; client_id = 'workout-client'; username = 'testuser'; password = 'password' }; $response = Invoke-RestMethod -Uri 'http://localhost:8081/realms/workout-realm/protocol/openid-connect/token' -Method POST -Body $body -ContentType 'application/x-www-form-urlencoded'; Write-Host '[SUCCESS] Token received successfully!' -ForegroundColor Green; Write-Host 'Access Token:' -ForegroundColor Yellow; Write-Host $response.access_token -ForegroundColor White; Write-Host 'Token Type:' -ForegroundColor Yellow; Write-Host $response.token_type -ForegroundColor White; Write-Host 'Expires In:' -ForegroundColor Yellow; Write-Host $response.expires_in -ForegroundColor White; Write-Host 'Use in header: Authorization: Bearer ' + $response.access_token -ForegroundColor Cyan } catch { Write-Host '[ERROR] Token retrieval failed:' -ForegroundColor Red; Write-Host $_.Exception.Message -ForegroundColor Red; Write-Host 'Make sure user testuser, client workout-client, and realm workout-realm exist in Keycloak' -ForegroundColor Yellow }"
echo.
echo If PowerShell didn't work, use curl:
echo curl -X POST http://localhost:8081/realms/workout-realm/protocol/openid-connect/token ^
echo      -H "Content-Type: application/x-www-form-urlencoded" ^
echo      -d "grant_type=password&client_id=workout-client&username=testuser&password=password"
echo.
pause
