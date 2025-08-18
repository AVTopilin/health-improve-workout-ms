@echo off
chcp 65001 >nul
echo Getting JWT token from Keycloak for Windows...
echo.
echo 1. Make sure Keycloak is running:
echo    docker-compose ps keycloak
echo.
echo 2. Open Keycloak Admin Console:
echo    http://localhost:8081
echo    Login: admin
echo    Password: admin
echo.
echo 3. Go to realm "workout-realm"
echo.
echo 4. Create test user:
echo    - Users -> Add user
echo    - Username: testuser
echo    - Email: test@example.com
echo    - First Name: Test
echo    - Last Name: User
echo    - Email Verified: ON
echo    - Save
echo.
echo 5. Set password for user:
echo    - Credentials tab
echo    - New Password: test123
echo    - Password Confirmation: test123
echo    - Temporary: OFF
echo    - Save
echo.
echo 6. Get JWT token via PowerShell:
echo    powershell -Command "& {"
echo    "  $body = @{"
echo    "    grant_type = 'password'"
echo    "    client_id = 'workout-client'"
echo    "    username = 'testuser'"
echo    "    password = 'test123'"
echo    "  } | ConvertTo-Json"
echo    "  $response = Invoke-RestMethod -Uri 'http://localhost:8081/realms/workout-realm/protocol/openid-connect/token' -Method POST -Body $body -ContentType 'application/json'"
echo    "  Write-Host 'Access Token:'"
echo    "  Write-Host $response.access_token"
echo    "}"
echo.
echo 7. Or use curl (if installed):
echo    curl -X POST http://localhost:8081/realms/workout-realm/protocol/openid-connect/token ^
echo         -H "Content-Type: application/json" ^
echo         -d "{\"grant_type\":\"password\",\"client_id\":\"workout-client\",\"username\":\"testuser\",\"password\":\"test123\"}"
echo.
echo 8. Copy access_token from response
echo.
echo 9. Use token in Authorization header:
echo    curl -H "Authorization: Bearer YOUR_TOKEN_HERE" ^
echo         http://localhost:8080/api/workouts
echo.
echo Note: In dev mode API works without token (permitAll),
echo but with token you can test full authentication functionality.
echo.
pause
