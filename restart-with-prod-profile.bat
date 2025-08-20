@echo off
echo Restarting workout backend with PRODUCTION profile...

echo Stopping containers...
docker-compose down

echo Building and starting containers with prod profile...
docker-compose up -d --build

echo Waiting for services to be ready...
timeout /t 60 /nobreak

echo Testing health endpoint (should work without auth)...
curl -v http://localhost:8080/health

echo Testing protected endpoint (should require auth)...
curl -v http://localhost:8080/api/workouts

echo Done!
pause
