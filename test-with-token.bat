@echo off
chcp 65001 >nul
echo Testing API with JWT token...
echo.
echo Enter JWT token (or press Enter to test without token):
set /p JWT_TOKEN=
echo.
if "%JWT_TOKEN%"=="" (
    echo Testing without token...
    echo.
    echo 1. GET /api/workouts (without token):
    curl -s http://localhost:8080/api/workouts
    echo.
    echo 2. GET /api/exercises (without token):
    curl -s http://localhost:8080/api/exercises
    echo.
) else (
    echo Testing with JWT token...
    echo.
    echo 1. GET /api/workouts (with token):
    curl -s -H "Authorization: Bearer %JWT_TOKEN%" http://localhost:8080/api/workouts
    echo.
    echo 2. GET /api/exercises (with token):
    curl -s -H "Authorization: Bearer %JWT_TOKEN%" http://localhost:8080/api/exercises
    echo.
    echo 3. POST /api/workouts (with token):
    curl -s -X POST -H "Authorization: Bearer %JWT_TOKEN%" -H "Content-Type: application/json" -d "{\"name\":\"Test workout with token\",\"description\":\"Created with JWT token\"}" http://localhost:8080/api/workouts
    echo.
)
echo.
echo Testing completed!
echo.
pause
