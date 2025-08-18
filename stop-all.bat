@echo off
chcp 65001 >nul
echo Stopping All Workout Services...
echo.
echo This will stop:
echo - Backend application
echo - PostgreSQL database
echo - Keycloak authentication server
echo.
echo Press any key to continue...
pause >nul
echo.
echo 1. Stopping full stack services...
docker-compose down
if %errorlevel% neq 0 (
    echo [WARNING] Failed to stop full stack services
)
echo.
echo 2. Stopping development stack services...
docker-compose -f docker-compose-dev.yml down
if %errorlevel% neq 0 (
    echo [WARNING] Failed to stop development stack services
)
echo.
echo 3. Stopping any remaining containers...
docker stop workout_backend workout_postgres workout_keycloak workout_postgres_dev workout_keycloak_dev 2>nul
echo.
echo 4. Removing containers...
docker rm workout_backend workout_postgres workout_keycloak workout_postgres_dev workout_keycloak_dev 2>nul
echo.
echo 5. Checking for running containers...
docker ps --filter "name=workout_"
echo.
echo 6. Service status:
echo - Port 8080 (Backend): 
netstat -an | findstr :8080 | findstr LISTENING >nul && echo "IN USE" || echo "FREE"
echo - Port 8081 (Keycloak): 
netstat -an | findstr :8081 | findstr LISTENING >nul && echo "IN USE" || echo "FREE"
echo - Port 5432 (PostgreSQL): 
netstat -an | findstr :5432 | findstr LISTENING >nul && echo "IN USE" || echo "FREE"
echo.
echo All services stopped!
echo.
echo To start services again:
echo - Full stack: start-full-stack.bat
echo - Development only: start-dev-stack.bat
echo - Infrastructure only: start-infrastructure.bat
echo.
pause
