@echo off
echo Testing ALL API endpoints...

echo.
echo ========================================
echo 1. Testing Health and Basic Endpoints
echo ========================================
echo Testing /health...
curl -s http://localhost:8080/health
echo.

echo Testing /...
curl -s http://localhost:8080/
echo.

echo Testing /test-json...
curl -s -X POST http://localhost:8080/test-json -H "Content-Type: application/json" -d "{\"test\":\"data\"}"
echo.

echo ========================================
echo 2. Testing Workout API
echo ========================================
echo Creating workout...
curl -s -X POST http://localhost:8080/api/workouts -H "Content-Type: application/json" -d "{\"name\":\"API Test Workout\",\"dayOfWeek\":\"MONDAY\",\"weeksCount\":2,\"startDate\":\"2025-08-19\"}"
echo.

echo Getting all workouts...
curl -s http://localhost:8080/api/workouts
echo.

echo ========================================
echo 3. Testing Exercise API
echo ========================================
echo Creating exercise...
curl -s -X POST http://localhost:8080/api/exercises -H "Content-Type: application/json" -d "{\"name\":\"API Test Exercise\",\"description\":\"Test exercise for API testing\",\"sets\":3,\"reps\":10,\"weight\":50.5,\"workoutId\":1}"
echo.

echo Getting all exercises...
curl -s http://localhost:8080/api/exercises
echo.

echo ========================================
echo 4. Testing Exercise Template API
echo ========================================
echo Creating exercise template...
curl -s -X POST http://localhost:8080/api/exercise-templates -H "Content-Type: application/json" -d "{\"name\":\"API Test Template\",\"description\":\"Test template for API testing\",\"difficultyLevel\":\"BEGINNER\",\"muscleGroupId\":1}"
echo.

echo Getting all exercise templates...
curl -s http://localhost:8080/api/exercise-templates
echo.

echo ========================================
echo 5. Testing Muscle Group API
echo ========================================
echo Creating muscle group...
curl -s -X POST http://localhost:8080/api/muscle-groups -H "Content-Type: application/json" -d "{\"name\":\"API Test Muscle Group\",\"description\":\"Test muscle group for API testing\"}"
echo.

echo Getting all muscle groups...
curl -s http://localhost:8080/api/muscle-groups
echo.

echo ========================================
echo 6. Testing Equipment API
echo ========================================
echo Creating equipment...
curl -s -X POST http://localhost:8080/api/equipment -H "Content-Type: application/json" -d "{\"name\":\"API Test Equipment\",\"description\":\"Test equipment for API testing\",\"equipmentType\":\"DUMBBELL\"}"
echo.

echo Getting all equipment...
curl -s http://localhost:8080/api/equipment
echo.

echo ========================================
echo 7. Testing Progression API
echo ========================================
echo Creating progression...
curl -s -X POST http://localhost:8080/api/progressions -H "Content-Type: application/json" -d "{\"exerciseId\":1,\"incrementType\":\"WEIGHT\",\"incrementValue\":2.5,\"periodicityType\":\"WEEKLY\",\"periodicityValue\":1}"
echo.

echo Getting all progressions...
curl -s http://localhost:8080/api/progressions
echo.

echo ========================================
echo 8. Testing User API
echo ========================================
echo Getting all users...
curl -s http://localhost:8080/api/users
echo.

echo ========================================
echo 9. Testing Swagger/OpenAPI
echo ========================================
echo Testing Swagger UI...
curl -s -I http://localhost:8080/swagger-ui.html
echo.

echo Testing API docs...
curl -s -I http://localhost:8080/v3/api-docs
echo.

echo ========================================
echo API Testing Completed!
echo ========================================
pause
