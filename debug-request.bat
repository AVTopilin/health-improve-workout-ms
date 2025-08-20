@echo off
echo Detailed request debugging...

echo.
echo Testing with exact same data as frontend...
curl -X POST http://localhost:8080/api/workouts ^
  -H "Content-Type: application/json; charset=UTF-8" ^
  -H "Authorization: Bearer test-token" ^
  -d "{\"createdAt\":\"2025-08-18T23:38:47.511093\",\"dayOfWeek\":\"MONDAY\",\"name\":\"dddd\",\"startDate\":\"2025-08-18\",\"updatedAt\":\"2025-08-18T23:38:47.511886\",\"userId\":1,\"weeksCount\":1}" ^
  -v

echo.
echo Testing with simplified data...
curl -X POST http://localhost:8080/api/workouts ^
  -H "Content-Type: application/json" ^
  -d "{\"name\":\"test\",\"dayOfWeek\":\"MONDAY\",\"weeksCount\":1,\"startDate\":\"2025-08-18\"}" ^
  -v

echo.
echo Testing with minimal data...
curl -X POST http://localhost:8080/api/workouts ^
  -H "Content-Type: application/json" ^
  -d "{\"name\":\"test\"}" ^
  -v

echo.
echo Done!
pause
