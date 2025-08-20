@echo off
echo Testing API with JWT authentication (PRODUCTION mode) - IMPROVED VERSION...

echo.
echo ========================================
echo 1. Getting JWT Token from Keycloak
echo ========================================
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
powershell -ExecutionPolicy Bypass -Command "try { $body = @{ grant_type = 'password'; client_id = 'workout-client'; username = 'testuser'; password = 'password' }; $response = Invoke-RestMethod -Uri 'http://localhost:8081/realms/workout-realm/protocol/openid-connect/token' -Method POST -Body $body -ContentType 'application/x-www-form-urlencoded'; $token = $response.access_token; Write-Host '[SUCCESS] Token received!' -ForegroundColor Green; Write-Host 'Token length: ' + $token.Length -ForegroundColor Yellow; Write-Host 'Token preview: ' + $token.Substring(0,50) + '...' -ForegroundColor White; $token | Out-File -FilePath 'jwt_token_new.txt' -Encoding UTF8; Write-Host 'Token saved to jwt_token_new.txt' -ForegroundColor Green } catch { Write-Host '[ERROR] Token retrieval failed:' -ForegroundColor Red; Write-Host $_.Exception.Message -ForegroundColor Red; exit 1 }"

if %errorlevel% neq 0 (
    echo Failed to get JWT token
    pause
    exit /b 1
)

echo.
echo ========================================
echo 2. Reading JWT Token from file
echo ========================================
if exist jwt_token_new.txt (
    set /p JWT_TOKEN_NEW=<jwt_token_new.txt
    echo JWT Token loaded from file
    echo Token preview: %JWT_TOKEN_NEW:~0,50%...
    echo Token length: %JWT_TOKEN_NEW:~0,50%...
) else (
    echo [ERROR] JWT token file not found
    pause
    exit /b 1
)

echo.
echo ========================================
echo 3. Testing Health Endpoint (should work without auth)
echo ========================================
echo Testing /health without token...
curl -s http://localhost:8080/health
echo.

echo ========================================
echo 4. Testing API Endpoints WITH JWT Token
echo ========================================
echo Testing GET /api/workouts with JWT...
echo Command: curl -H "Authorization: Bearer %JWT_TOKEN_NEW:~0,50%..." http://localhost:8080/api/workouts
powershell -ExecutionPolicy Bypass -Command "try { $headers = @{ 'Authorization' = 'Bearer ' + '%JWT_TOKEN_NEW%' }; $response = Invoke-WebRequest -Uri 'http://localhost:8080/api/workouts' -Headers $headers; Write-Host 'Status: ' + $response.StatusCode -ForegroundColor Green; Write-Host 'Response:' -ForegroundColor Yellow; Write-Host $response.Content -ForegroundColor White } catch { Write-Host 'Error:' -ForegroundColor Red; Write-Host $_.Exception.Message -ForegroundColor Red; if ($_.Exception.Response) { Write-Host 'HTTP Status: ' + $_.Exception.Response.StatusCode -ForegroundColor Red; Write-Host 'Response: ' + $_.Exception.Response.Content -ForegroundColor Red } }"

echo.
echo Testing POST /api/workouts with JWT...
echo Command: curl -X POST -H "Authorization: Bearer %JWT_TOKEN_NEW:~0,50%..." http://localhost:8080/api/workouts
powershell -ExecutionPolicy Bypass -Command "try { $headers = @{ 'Authorization' = 'Bearer ' + '%JWT_TOKEN_NEW%'; 'Content-Type' = 'application/json' }; $body = '{\"name\":\"JWT Test Workout\",\"dayOfWeek\":\"WEDNESDAY\",\"weeksCount\":2,\"startDate\":\"2025-08-21\"}'; $response = Invoke-WebRequest -Uri 'http://localhost:8080/api/workouts' -Method POST -Headers $headers -Body $body; Write-Host 'Status: ' + $response.StatusCode -ForegroundColor Green; Write-Host 'Response:' -ForegroundColor Yellow; Write-Host $response.Content -ForegroundColor White } catch { Write-Host 'Error:' -ForegroundColor Red; Write-Host $_.Exception.Message -ForegroundColor Red; if ($_.Exception.Response) { Write-Host 'HTTP Status: ' + $_.Exception.Response.StatusCode -ForegroundColor Red; Write-Host 'Response: ' + $_.Exception.Response.Content -ForegroundColor Red } }"

echo.
echo Testing GET /api/users with JWT...
powershell -ExecutionPolicy Bypass -Command "try { $headers = @{ 'Authorization' = 'Bearer ' + '%JWT_TOKEN_NEW%' }; $response = Invoke-WebRequest -Uri 'http://localhost:8080/api/users' -Headers $headers; Write-Host 'Status: ' + $response.StatusCode -ForegroundColor Green; Write-Host 'Response:' -ForegroundColor Yellow; Write-Host $response.Content -ForegroundColor White } catch { Write-Host 'Error:' -ForegroundColor Red; Write-Host $_.Exception.Message -ForegroundColor Red; if ($_.Exception.Response) { Write-Host 'HTTP Status: ' + $_.Exception.Response.StatusCode -ForegroundColor Red; Write-Host 'Response: ' + $_.Exception.Response.Content -ForegroundColor Red } }"

echo.
echo Testing GET /api/muscle-groups with JWT...
powershell -ExecutionPolicy Bypass -Command "try { $headers = @{ 'Authorization' = 'Bearer ' + '%JWT_TOKEN_NEW%' }; $response = Invoke-WebRequest -Uri 'http://localhost:8080/api/muscle-groups' -Headers $headers; Write-Host 'Status: ' + $response.StatusCode -ForegroundColor Green; Write-Host 'Response:' -ForegroundColor Yellow; Write-Host $response.Content -ForegroundColor White } catch { Write-Host 'Error:' -ForegroundColor Red; Write-Host $_.Exception.Message -ForegroundColor Red; if ($_.Exception.Response) { Write-Host 'HTTP Status: ' + $_.Exception.Response.StatusCode -ForegroundColor Red; Write-Host 'Response: ' + $_.Exception.Response.Content -ForegroundColor Red } }"

echo.
echo ========================================
echo 5. Testing API Endpoints WITHOUT JWT (should fail)
echo ========================================
echo Testing GET /api/workouts without JWT (should fail)...
curl -s -w "HTTP Status: %%{http_code}\n" http://localhost:8080/api/workouts
echo.

echo Testing POST /api/workouts without JWT (should fail)...
curl -s -w "HTTP Status: %%{http_code}\n" -X POST http://localhost:8080/api/workouts ^
  -H "Content-Type: application/json" ^
  -d "{\"name\":\"Unauthorized Test\"}"
echo.

echo.
echo ========================================
echo 6. Testing Swagger/OpenAPI with JWT
echo ========================================
echo Testing Swagger UI...
curl -s -I http://localhost:8080/swagger-ui.html
echo.

echo Testing API docs...
curl -s -I http://localhost:8080/v3/api-docs
echo.

echo.
echo ========================================
echo JWT Authentication Test Completed!
echo ========================================
echo.
echo Summary:
echo - Health endpoint: Should work without auth
echo - API endpoints: Should work WITH JWT token
echo - API endpoints: Should fail WITHOUT JWT token
echo - Swagger/OpenAPI: Should be accessible
echo.
echo JWT Token saved to: jwt_token_new.txt
echo.
pause
