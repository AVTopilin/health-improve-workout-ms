@echo off
echo Checking Equipment API...
echo.

echo Reading JWT token...
set /p JWT_TOKEN=<jwt_token_simple.txt

echo Testing GET /api/equipment...
curl -s -H "Authorization: Bearer %JWT_TOKEN%" http://localhost:8080/api/equipment

echo.
echo.
echo Testing GET /api/equipment/1 (specific equipment)...
curl -s -H "Authorization: Bearer %JWT_TOKEN%" http://localhost:8080/api/equipment/1

echo.
pause
