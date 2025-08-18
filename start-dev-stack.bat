@echo off
chcp 65001 >nul
echo Starting Development Stack (PostgreSQL + Keycloak only)...
echo.
echo This will start:
echo - PostgreSQL database
echo - Keycloak authentication server
echo.
echo Backend will NOT be started - run it locally in your IDE
echo.
echo Prerequisites:
echo - Docker Desktop must be running
echo - Ports 5432, 8081 must be available
echo.
echo Press any key to continue...
pause >nul
echo.
echo 1. Starting infrastructure services...
docker-compose -f docker-compose-dev.yml up -d
if %errorlevel% neq 0 (
    echo [ERROR] Failed to start infrastructure services
    pause
    exit /b 1
)
echo [OK] Infrastructure services started
echo.
echo 2. Waiting for services to be ready...
timeout /t 30 /nobreak >nul
echo.
echo 3. Checking service status...
docker-compose -f docker-compose-dev.yml ps
echo.
echo 4. Checking service health...
echo.
echo PostgreSQL health:
docker-compose -f docker-compose-dev.yml exec postgres pg_isready -U postgres
echo.
echo Keycloak health:
curl -s http://localhost:8081/health
echo.
echo 5. Service URLs:
echo - Keycloak Admin: http://localhost:8081
echo - PostgreSQL: localhost:5432
echo.
echo 6. Next steps:
echo - Backend is ready to run locally
echo - Use profile: dev or local
echo - Database will be available at localhost:5432
echo - Keycloak will be available at localhost:8081
echo.
echo Development stack is now running!
echo.
echo To view logs:
echo - All services: docker-compose -f docker-compose-dev.yml logs -f
echo - Keycloak only: docker-compose -f docker-compose-dev.yml logs -f keycloak
echo - PostgreSQL only: docker-compose -f docker-compose-dev.yml logs -f postgres
echo.
echo To stop services: docker-compose -f docker-compose-dev.yml down
echo.
pause
