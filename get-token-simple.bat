@echo off
chcp 65001 >nul
echo Simple JWT token retrieval from Keycloak...
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
echo Method 1: Using PowerShell script (recommended)
echo ------------------------------------------------
powershell -ExecutionPolicy Bypass -File "%~dp0Get-JWTToken.ps1"
echo.
echo Method 2: Using curl directly
echo -----------------------------
echo curl -X POST http://localhost:8081/realms/workout-realm/protocol/openid-connect/token ^
echo      -H "Content-Type: application/json" ^
echo      -d "{\"grant_type\":\"password\",\"client_id\":\"workout-client\",\"username\":\"testuser\",\"password\":\"test123\"}"
echo.
echo Note: Make sure you have created in Keycloak:
echo - Realm: workout-realm
echo - Client: workout-client (confidential)
echo - User: testuser with password: test123
echo.
echo To open Keycloak Admin Console: http://localhost:8081
echo Login: admin / Password: admin
echo.
pause
