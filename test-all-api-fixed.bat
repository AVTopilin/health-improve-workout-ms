@echo off
echo Testing ALL API endpoints with CORRECT data...

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
curl -s -X POST http://localhost:8080/api/workouts -H "Content-Type: application/json" -d "{\"name\":\"API Test Workout 2\",\"dayOfWeek\":\"TUESDAY\",\"weeksCount\":3,\"startDate\":\"2025-08-20\"}"
echo.

echo Getting all workouts...
curl -s http://localhost:8080/api/workouts
echo.

echo ========================================
echo 3. Testing Equipment API (FIRST - needed for templates)
echo ========================================
echo Creating equipment...
curl -s -X POST http://localhost:8080/api/equipment -H "Content-Type: application/json" -d "{\"name\":\"Test Dumbbells\",\"description\":\"Test equipment for API testing\",\"type\":\"DUMBBELLS\"}"
echo.

echo Getting all equipment...
curl -s http://localhost:8080/api/equipment
echo.

echo ========================================
echo 4. Testing Exercise Template API (needed for exercises)
echo ========================================
echo Creating exercise template...
curl -s -X POST http://localhost:8080/api/exercise-templates -H "Content-Type: application/json" -d "{\"name\":\"Test Push-up Template\",\"description\":\"Test template for API testing\",\"difficultyLevel\":\"BEGINNER\",\"muscleGroupId\":1,\"equipmentId\":1}"
echo.

echo Getting all exercise templates...
curl -s http://localhost:8080/api/exercise-templates
echo.

echo ========================================
echo 5. Testing Exercise API (now with valid template)
echo ========================================
echo Creating exercise...
curl -s -X POST http://localhost:8080/api/exercises -H "Content-Type: application/json" -d "{\"name\":\"Test Push-up Exercise\",\"description\":\"Test exercise for API testing\",\"sets\":3,\"reps\":10,\"weight\":0.0,\"workoutId\":1,\"exerciseTemplateId\":1,\"restTime\":60}"
echo.

echo Getting all exercises...
curl -s http://localhost:8080/api/exercises
echo.

echo ========================================
echo 6. Testing Progression API (now with valid exercise)
echo ========================================
echo Creating progression...
curl -s -X POST http://localhost:8080/api/progressions -H "Content-Type: application/json" -d "{\"exerciseId\":1,\"exerciseTemplateId\":1,\"weeksCount\":4,\"startDate\":\"2025-08-20\",\"weightProgressionEnabled\":true,\"repsProgressionEnabled\":false,\"setsProgressionEnabled\":false,\"weightIncrementType\":\"INCREMENT\",\"weightIncrementValue\":2.5,\"weightPeriodicity\":\"EVERY_WORKOUT\"}"
echo.

echo Getting all progressions...
curl -s http://localhost:8080/api/progressions
echo.

echo ========================================
echo 7. Testing Muscle Group API
echo ========================================
echo Creating muscle group...
curl -s -X POST http://localhost:8080/api/muscle-groups -H "Content-Type: application/json" -d "{\"name\":\"API Test Muscle Group 2\",\"description\":\"Test muscle group for API testing\"}"
echo.

echo Getting all muscle groups...
curl -s http://localhost:8080/api/muscle-groups
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
echo API Testing with CORRECT data completed!
echo ========================================
pause
