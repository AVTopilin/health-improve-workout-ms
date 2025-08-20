@echo off
echo Rebuilding application after isActive flags fix...
echo.

echo 1. Stopping Docker containers...
docker-compose down

echo.
echo 2. Cleaning Maven project...
mvn clean

echo.
echo 3. Compiling project...
mvn compile

if %errorlevel% neq 0 (
    echo Compilation failed! Check the errors above.
    pause
    exit /b 1
)

echo.
echo 4. Building JAR file...
mvn package -DskipTests

if %errorlevel% neq 0 (
    echo Build failed! Check the errors above.
    pause
    exit /b 1
)

echo.
echo 5. Building Docker image...
docker-compose build backend

echo.
echo 6. Starting containers...
docker-compose up -d

echo.
echo 7. Waiting for application to start...
timeout /t 10 /nobreak >nul

echo.
echo 8. Testing health endpoint...
curl -s http://localhost:8080/health

echo.
echo 9. Testing isActive flags...
echo.
echo Testing Equipment API:
curl -s -H "Authorization: Bearer $(Get-Content jwt_token_simple.txt -Raw)" http://localhost:8080/api/equipment | jq '.[0] | {id, name, isActive}' 2>nul || echo "jq not available, showing raw response"

echo.
echo Testing Muscle Group API:
curl -s -H "Authorization: Bearer $(Get-Content jwt_token_simple.txt -Raw)" http://localhost:8080/api/muscle-groups | jq '.[0] | {id, name, isActive}' 2>nul || echo "jq not available, showing raw response"

echo.
echo ========================================
echo Rebuild completed! Check the results above.
echo ========================================
pause
