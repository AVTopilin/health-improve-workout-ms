@echo off
echo Testing DateTime parsing fix...

echo.
echo ========================================
echo Testing with problematic datetime format
echo ========================================
curl -X POST http://localhost:8080/api/workouts ^
  -H "Content-Type: application/json" ^
  -d "{\"name\":\"test-datetime\",\"dayOfWeek\":\"MONDAY\",\"weeksCount\":1,\"startDate\":\"2025-08-19\",\"createdAt\":\"2025-08-19T00:00:19.14368\",\"updatedAt\":\"2025-08-19T00:00:19.14368\"}"

echo.
echo ========================================
echo Testing with standard datetime format
echo ========================================
curl -X POST http://localhost:8080/api/workouts ^
  -H "Content-Type: application/json" ^
  -d "{\"name\":\"test-standard\",\"dayOfWeek\":\"MONDAY\",\"weeksCount\":1,\"startDate\":\"2025-08-19\",\"createdAt\":\"2025-08-19T00:00:19.143\",\"updatedAt\":\"2025-08-19T00:00:19.143\"}"

echo.
echo ========================================
echo Testing with minimal data
echo ========================================
curl -X POST http://localhost:8080/api/workouts ^
  -H "Content-Type: application/json" ^
  -d "{\"name\":\"test-minimal\",\"dayOfWeek\":\"MONDAY\",\"weeksCount\":1,\"startDate\":\"2025-08-19\"}"

echo.
echo ========================================
echo Test completed!
echo ========================================
pause
