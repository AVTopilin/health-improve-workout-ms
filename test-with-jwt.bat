@echo off
echo Testing API with JWT authentication (PRODUCTION mode)...

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
powershell -ExecutionPolicy Bypass -Command "try { $body = @{ grant_type = 'password'; client_id = 'workout-client'; username = 'testuser'; password = 'password' }; $response = Invoke-RestMethod -Uri 'http://localhost:8081/realms/workout-realm/protocol/openid-connect/token' -Method POST -Body $body -ContentType 'application/x-www-form-urlencoded'; $env:JWT_TOKEN = $response.access_token; Write-Host '[SUCCESS] Token received!' -ForegroundColor Green; Write-Host 'Token: ' + $response.access_token.Substring(0,50) + '...' -ForegroundColor White } catch { Write-Host '[ERROR] Token retrieval failed:' -ForegroundColor Red; Write-Host $_.Exception.Message -ForegroundColor Red; exit 1 }"

if %errorlevel% neq 0 (
    echo Failed to get JWT token
    pause
    exit /b 1
)

echo.
echo ========================================
echo 2. Testing Health Endpoint (should work without auth)
echo ========================================
echo Testing /health without token...
curl -s http://localhost:8080/health
echo.

echo ========================================
echo 3. Testing API Endpoints WITH JWT Token
echo ========================================
echo Testing GET /api/workouts with JWT...
curl -s -H "Authorization: Bearer %JWT_TOKEN%" http://localhost:8080/api/workouts
echo.

echo.
echo Testing POST /api/workouts with JWT...
curl -s -X POST http://localhost:8080/api/workouts ^
  -H "Authorization: Bearer %JWT_TOKEN%" ^
  -H "Content-Type: application/json" ^
  -d "{\"name\":\"JWT Test Workout\",\"dayOfWeek\":\"WEDNESDAY\",\"weeksCount\":2,\"startDate\":\"2025-08-21\"}"
echo.

echo.
echo Testing GET /api/users with JWT...
curl -s -H "Authorization: Bearer %JWT_TOKEN%" http://localhost:8080/api/users
echo.

echo.
echo Testing GET /api/muscle-groups with JWT...
curl -s -H "Authorization: Bearer %JWT_TOKEN%" http://localhost:8080/api/muscle-groups
echo.

echo.
echo Testing GET /api/equipment with JWT...
curl -s -H "Authorization: Bearer %JWT_TOKEN%" http://localhost:8080/api/equipment
echo.

echo.
echo Testing GET /api/exercise-templates with JWT...
curl -s -H "Authorization: Bearer %JWT_TOKEN%" http://localhost:8080/api/exercise-templates
echo.

echo.
echo Testing GET /api/exercises with JWT...
curl -s -H "Authorization: Bearer %JWT_TOKEN%" http://localhost:8080/api/exercises
echo.

echo.
echo Testing GET /api/progressions with JWT...
curl -s -H "Authorization: Bearer %JWT_TOKEN%" http://localhost:8080/api/progressions
echo.

echo.
echo ========================================
echo 4. Testing API Endpoints WITHOUT JWT (should fail)
echo ========================================
echo Testing GET /api/workouts without JWT (should fail)...
curl -s -w "HTTP Status: %%{http_code}\n" http://localhost:8080/api/workouts
echo.

echo.
echo Testing POST /api/workouts without JWT (should fail)...
curl -s -w "HTTP Status: %%{http_code}\n" -X POST http://localhost:8080/api/workouts ^
  -H "Content-Type: application/json" ^
  -d "{\"name\":\"Unauthorized Test\"}"
echo.

echo.
echo ========================================
echo 5. Testing Swagger/OpenAPI with JWT
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
pause
