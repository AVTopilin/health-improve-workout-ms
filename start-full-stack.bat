@echo off
chcp 65001 >nul
echo Starting Full Stack (Backend + PostgreSQL + Keycloak)...
echo.
echo This will start:
echo - PostgreSQL database
echo - Keycloak authentication server
echo - Backend application (Spring Boot)
echo.
echo Prerequisites:
echo - Docker Desktop must be running
echo - Ports 5432, 8080, 8081 must be available
echo - JAR file must be built (use build-and-run.bat first)
echo.
echo Press any key to continue...
pause >nul
echo.
echo 1. Checking if JAR file exists...
if not exist "target\*.jar" (
    echo [ERROR] JAR file not found in target directory
    echo.
    echo Please run build-and-run.bat first to build the application
    echo Or manually run: mvn clean package -DskipTests
    echo.
    pause
    exit /b 1
)
echo [OK] JAR file found
echo.
echo 2. Stopping existing services if running...
docker-compose down >nul 2>&1
echo [OK] Existing services stopped
echo.
echo 3. Building Docker image and starting all services...
docker-compose up -d --build
if %errorlevel% neq 0 (
    echo [ERROR] Failed to start services
    pause
    exit /b 1
)
echo [OK] Services started
echo.
echo 4. Waiting for services to be ready...
timeout /t 30 /nobreak >nul
echo.
echo 5. Checking service status...
docker-compose ps
echo.
echo 6. Checking service health...
echo.
echo PostgreSQL health:
docker-compose exec postgres pg_isready -U postgres
echo.
echo Keycloak health:
curl -s http://localhost:8081/health
echo.
echo Backend health:
curl -s http://localhost:8080/health
echo.
echo 7. Service URLs:
echo - Backend API: http://localhost:8080
echo - Swagger UI: http://localhost:8080/swagger-ui/index.html
echo - Keycloak Admin: http://localhost:8081
echo - PostgreSQL: localhost:5432
echo.
echo Full stack is now running!
echo.
echo To view logs:
echo - All services: docker-compose logs -f
echo - Backend only: docker-compose logs -f backend
echo - Keycloak only: docker-compose logs -f keycloak
echo - PostgreSQL only: docker-compose logs -f postgres
echo.
echo To stop all services: docker-compose down
echo.
pause
