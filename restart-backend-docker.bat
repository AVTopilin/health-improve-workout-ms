@echo off
chcp 65001 >nul
echo Restarting Backend Docker Image...
echo.
echo This will:
echo 1. Stop only the backend service
echo 2. Rebuild the Docker image with new JAR
echo 3. Start the backend service with new image
echo 4. Keep PostgreSQL and Keycloak running
echo.
echo Prerequisites:
echo - Docker Desktop must be running
echo - JAR file must be built (use build-and-run.bat first)
echo.
echo Press any key to continue...
pause >nul
echo.
echo 1. Checking if JAR file exists...
if not exist "target\*.jar" (
    echo [ERROR] JAR file not found in target directory
    echo.
    echo Please build the application first:
    echo mvn clean package -DskipTests
    echo.
    pause
    exit /b 1
)
echo [OK] JAR file found
echo.
echo 2. Stopping backend service...
docker-compose stop backend
echo [OK] Backend service stopped
echo.
echo 3. Rebuilding Docker image and starting backend...
docker-compose build --no-cache --pull backend
docker-compose up -d --build backend
if %errorlevel% neq 0 (
    echo [ERROR] Failed to rebuild and start backend
    pause
    exit /b 1
)
echo [OK] Backend service restarted with new image
echo.
echo 4. Waiting for backend to be ready...
timeout /t 15 /nobreak >nul
echo.
echo 5. Checking backend health...
curl -s http://localhost:8080/health
echo.
echo Backend Docker image has been rebuilt and restarted!
echo.
echo To view backend logs: docker-compose logs -f backend
echo To stop backend: docker-compose stop backend
echo.
pause
