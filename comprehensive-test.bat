@echo off
echo Comprehensive JSON parsing test...

echo.
echo ========================================
echo Testing basic JSON parsing
echo ========================================
curl -X POST http://localhost:8080/test-json -H "Content-Type: application/json" -d "{\"test\":\"data\"}"

echo.
echo ========================================
echo Testing WorkoutDto parsing
echo ========================================
curl -X POST http://localhost:8080/test-workout-dto -H "Content-Type: application/json" -d "{\"name\":\"test\",\"dayOfWeek\":\"MONDAY\",\"weeksCount\":1,\"startDate\":\"2025-08-18\"}"

echo.
echo ========================================
echo Testing raw JSON parsing
echo ========================================
curl -X POST http://localhost:8080/test-raw-json -H "Content-Type: application/json" -d "{\"name\":\"test\"}"

echo.
echo ========================================
echo Testing API endpoint with minimal data
echo ========================================
curl -X POST http://localhost:8080/api/workouts -H "Content-Type: application/json" -d "{\"name\":\"test\"}"

echo.
echo ========================================
echo Testing API endpoint with full data
echo ========================================
curl -X POST http://localhost:8080/api/workouts -H "Content-Type: application/json" -d "{\"name\":\"test\",\"dayOfWeek\":\"MONDAY\",\"weeksCount\":1,\"startDate\":\"2025-08-18\"}"

echo.
echo ========================================
echo Testing API endpoint with frontend data
echo ========================================
curl -X POST http://localhost:8080/api/workouts -H "Content-Type: application/json; charset=UTF-8" -d "{\"createdAt\":\"2025-08-18T23:38:47.511093\",\"dayOfWeek\":\"MONDAY\",\"name\":\"dddd\",\"startDate\":\"2025-08-18\",\"updatedAt\":\"2025-08-18T23:38:47.511886\",\"userId\":1,\"weeksCount\":1}"

echo.
echo ========================================
echo Test completed!
echo ========================================
pause
