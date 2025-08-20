@echo off
echo Quick restart of workout backend...

echo Stopping containers...
docker-compose down

echo Starting containers...
docker-compose up -d

echo Waiting for services to be ready...
timeout /t 30 /nobreak

echo Testing health endpoint...
curl -v http://localhost:8080/health

echo Done!
pause
