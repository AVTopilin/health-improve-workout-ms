@echo off
chcp 65001 >nul
echo Building and Running Full Stack...
echo.
echo This script will:
echo 1. Build the Spring Boot application locally
echo 2. Start the full Docker stack
echo.
echo Prerequisites:
echo - Java 17+ must be installed
echo - Maven 3.6+ must be installed
echo - Docker Desktop must be running
echo - Ports 5432, 8080, 8081 must be available
echo.
echo Press any key to continue...
pause >nul
echo.
echo 1. Checking Java version...
java -version
if %errorlevel% neq 0 (
    echo [ERROR] Java is not installed or not in PATH
    echo Please install Java 17+ and add it to PATH
    pause
    exit /b 1
)
echo.
echo 2. Checking Maven version...
mvn -version
if %errorlevel% neq 0 (
    echo [ERROR] Maven is not installed or not in PATH
    echo Please install Maven 3.6+ and add it to PATH
    pause
    exit /b 1
)
echo.
echo 3. Building Spring Boot application...
mvn clean package -DskipTests
if %errorlevel% neq 0 (
    echo [ERROR] Failed to build application
    pause
    exit /b 1
)
echo [OK] Application built successfully
echo.
echo 4. Checking JAR file...
if not exist "target\*.jar" (
    echo [ERROR] JAR file not found in target directory
    pause
    exit /b 1
)
echo [OK] JAR file found
echo.
echo 5. Starting Docker stack...
docker-compose up -d
if %errorlevel% neq 0 (
    echo [ERROR] Failed to start Docker stack
    pause
    exit /b 1
)
echo [OK] Docker stack started
echo.
echo 6. Waiting for services to be ready...
timeout /t 30 /nobreak >nul
echo.
echo 7. Checking service status...
docker-compose ps
echo.
echo 8. Checking service health...
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
echo 9. Service URLs:
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
