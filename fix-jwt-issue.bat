@echo off
echo ========================================
echo Fixing JWT Authentication Issue
echo ========================================

echo.
echo Step 1: Stopping containers...
docker-compose down

echo.
echo Step 2: Removing old Docker image...
docker rmi workout-backend_workout-backend --force

echo.
echo Step 3: Building application...
mvn clean package -DskipTests

echo.
echo Step 4: Building Docker image with --no-cache...
docker-compose build --no-cache

echo.
echo Step 5: Starting containers...
docker-compose up -d

echo.
echo Step 6: Waiting for services to be ready...
timeout /t 60 /nobreak

echo.
echo Step 7: Testing endpoints...
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
echo Fix completed!
echo ========================================
pause
