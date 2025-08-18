@echo off
chcp 65001 >nul
echo Restarting Stack with JWT Fix...
echo.
echo This script will:
echo 1. Stop all services
echo 2. Clean up containers and volumes
echo 3. Rebuild and restart with fixed JWT configuration
echo 4. Test JWT issuer configuration
echo.
echo Press any key to continue...
pause >nul
echo.
echo 1. Stopping all services...
docker-compose down
echo.
echo 2. Removing containers and volumes...
docker-compose down -v
echo.
echo 3. Cleaning up any remaining containers...
docker stop workout_backend workout_postgres workout_keycloak 2>nul
docker rm workout_backend workout_postgres workout_keycloak 2>nul
echo.
echo 4. Checking if JAR file exists...
if not exist "target\*.jar" (
    echo [ERROR] JAR file not found
    echo Please run build-jar.bat first
    pause
    exit /b 1
)
echo [OK] JAR file found
echo.
echo 5. Starting services with fixed configuration...
docker-compose up -d
if %errorlevel% neq 0 (
    echo [ERROR] Failed to start services
    pause
    exit /b 1
)
echo [OK] Services started
echo.
echo 6. Waiting for services to be ready...
timeout /t 45 /nobreak >nul
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
echo 9. Testing JWT configuration...
echo.
echo Testing Keycloak realm endpoint:
docker-compose exec backend curl -s http://keycloak:8080/realms/workout-realm | findstr "realm"
echo.
echo Testing JWT certificates:
docker-compose exec backend curl -s http://keycloak:8080/realms/workout-realm/protocol/openid-connect/certs | findstr "keys"
echo.
echo 10. Service URLs:
echo - Backend API: http://localhost:8080
echo - Swagger UI: http://localhost:8080/swagger-ui/index.html
echo - Keycloak Admin: http://localhost:8081
echo - PostgreSQL: localhost:5432
echo.
echo 11. Next steps:
echo - Setup Keycloak realm and client: setup-keycloak.bat
echo - Check JWT issuer: check-jwt-issuer.bat
echo - Get JWT token: get-token-simple.bat
echo - Test API: test-api.html
echo.
echo 12. Important JWT Configuration Notes:
echo - Keycloak KC_HOSTNAME is now set to 'keycloak'
echo - Backend expects issuer: http://keycloak:8080/realms/workout-realm
echo - JWT tokens should now have correct issuer claim
echo.
echo If you still have JWT issues, run: debug-jwt.bat
echo.
pause
