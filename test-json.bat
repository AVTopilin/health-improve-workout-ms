@echo off
echo Testing JSON parsing endpoint...

echo Testing with valid JSON...
curl -X POST http://localhost:8080/test-json ^
  -H "Content-Type: application/json" ^
  -d "{\"createdAt\":\"2025-08-18T23:10:23.01633\",\"dayOfWeek\":\"MONDAY\",\"name\":\"test1\",\"startDate\":\"2025-08-18\",\"updatedAt\":\"2025-08-18T23:10:23.016382\",\"userId\":1,\"weeksCount\":1}"

echo.
echo Testing with malformed JSON...
curl -X POST http://localhost:8080/test-json ^
  -H "Content-Type: application/json" ^
  -d "{\"createdAt\":\"2025-08-18T23:10:23.01633\",\"dayOfWeek\":\"MONDAY\",\"name\":\"test1\",\"startDate\":\"2025-08-18\",\"updatedAt\":\"2025-08-18T23:10:23.016382\",\"userId\":1,\"weeksCount\":1"

echo.
echo Testing health endpoint...
curl -v http://localhost:8080/health

echo.
echo Done!
pause
