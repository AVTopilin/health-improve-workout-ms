@echo off
echo Debugging workout exercises API...
echo.

echo Reading JWT token...
set /p JWT_TOKEN=<jwt_token_simple.txt

echo.
echo ========================================
echo 1. Testing workout existence
echo ========================================
echo Testing GET /api/workouts/9:
curl -s -H "Authorization: Bearer %JWT_TOKEN%" http://localhost:8080/api/workouts/9
echo.

echo.
echo ========================================
echo 2. Testing workout exercises endpoint
echo ========================================
echo Testing GET /api/workouts/9/exercises:
curl -s -H "Authorization: Bearer %JWT_TOKEN%" http://localhost:8080/api/workouts/9/exercises
echo.

echo.
echo ========================================
echo 3. Testing all workouts
echo ========================================
echo Testing GET /api/workouts:
curl -s -H "Authorization: Bearer %JWT_TOKEN%" http://localhost:8080/api/workouts
echo.

echo.
echo ========================================
echo 4. Testing exercises endpoint
echo ========================================
echo Testing GET /api/exercises:
curl -s -H "Authorization: Bearer %JWT_TOKEN%" http://localhost:8080/api/exercises
echo.

echo.
echo ========================================
echo 5. Testing exercises by workout ID
echo ========================================
echo Testing GET /api/exercises/workout/9:
curl -s -H "Authorization: Bearer %JWT_TOKEN%" http://localhost:8080/api/exercises/workout/9
echo.

echo.
echo ========================================
echo Debug completed! Check the results above.
echo ========================================
pause
