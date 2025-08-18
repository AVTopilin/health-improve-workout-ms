@echo off
chcp 65001 >nul
echo Starting infrastructure with fixed docker-compose...
echo.
echo 1. Stopping all containers...
docker-compose down
echo.
echo 2. Removing volumes for complete cleanup...
docker-compose down -v
echo.
echo 3. Starting with fixed docker-compose...
docker-compose -f docker-compose-fixed.yml up -d
echo.
echo 4. Waiting for services to start...
timeout /t 45 /nobreak >nul
echo.
echo 5. Checking service status...
docker-compose -f docker-compose-fixed.yml ps
echo.
echo 6. Checking PostgreSQL...
docker-compose -f docker-compose-fixed.yml exec postgres pg_isready -U postgres
if %errorlevel% equ 0 (
    echo [OK] PostgreSQL is ready
) else (
    echo [ERROR] PostgreSQL is not ready
)
echo.
echo 7. Checking Keycloak...
curl -s http://localhost:8081/health >nul
if %errorlevel% equ 0 (
    echo [OK] Keycloak is available at http://localhost:8081
    echo.
    echo Now you can:
    echo 1. Open Keycloak Admin Console: http://localhost:8081
    echo 2. Login: admin
    echo 3. Password: admin
    echo 4. Create realm "workout-realm"
    echo 5. Create client "workout-backend"
) else (
    echo [ERROR] Keycloak is not available
    echo.
    echo Checking Keycloak logs...
    docker-compose -f docker-compose-fixed.yml logs --tail=20 keycloak
)
echo.
echo 8. Service information:
echo - PostgreSQL: localhost:5432
echo - Keycloak: http://localhost:8081
echo - Database: workout_db
echo.
pause
