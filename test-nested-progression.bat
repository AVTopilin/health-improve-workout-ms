@echo off
echo Testing nested progression in exercises...
echo.

echo Reading JWT token...
set /p JWT_TOKEN=<jwt_token_simple.txt

echo.
echo ========================================
echo 1. Testing exercises with nested progression
echo ========================================
echo Testing GET /api/exercises:
curl -s -H "Authorization: Bearer %JWT_TOKEN%" http://localhost:8080/api/exercises | jq '.[0] | {id, exerciseName, progression: .progression}' 2>nul || echo "jq not available, showing raw response"

echo.
echo ========================================
echo 2. Testing exercises by workout ID
echo ========================================
echo Testing GET /api/exercises/workout/1:
curl -s -H "Authorization: Bearer %JWT_TOKEN%" http://localhost:8080/api/exercises/workout/1 | jq '.[0] | {id, exerciseName, progression: .progression}' 2>nul || echo "jq not available, showing raw response"

echo.
echo ========================================
echo 3. Testing specific exercise
echo ========================================
echo Testing GET /api/exercises/1:
curl -s -H "Authorization: Bearer %JWT_TOKEN%" http://localhost:8080/api/exercises/1 | jq '{id, exerciseName, progression: .progression}' 2>nul || echo "jq not available, showing raw response"

echo.
echo ========================================
echo Test completed! Check the results above.
echo ========================================
echo.
echo Expected result: Each exercise should have a 'progression' field
echo containing progression settings or null if no progression exists.
echo.
pause
