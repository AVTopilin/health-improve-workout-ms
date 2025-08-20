@echo off
echo Testing DEBUG profile without JWT authentication...

echo.
echo Step 1: Building application...
mvn clean package -DskipTests

echo.
echo Step 2: Building Docker image...
docker-compose build --no-cache

echo.
echo Step 3: Starting containers...
docker-compose up -d

echo.
echo Step 4: Waiting for services to be ready...
timeout /t 60 /nobreak

echo.
echo Step 5: Testing endpoints...
echo.
echo Testing health endpoint...
curl -v http://localhost:8080/health

echo.
echo Testing JSON endpoint...
curl -X POST http://localhost:8080/test-json -H "Content-Type: application/json" -d "{\"test\":\"data\"}"

echo.
echo Testing API endpoint (should work without JWT in debug mode)...
curl -X POST http://localhost:8080/api/workouts -H "Content-Type: application/json" -d "{\"name\":\"test\",\"dayOfWeek\":\"MONDAY\",\"weeksCount\":1,\"startDate\":\"2025-08-18\"}"

echo.
echo ========================================
echo Debug profile test completed!
echo ========================================
pause
