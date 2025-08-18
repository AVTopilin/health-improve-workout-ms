@echo off
chcp 65001 >nul
echo Debugging JWT Configuration Issues...
echo.
echo This script will help diagnose JWT-related problems
echo.
echo Press any key to continue...
pause >nul
echo.
echo 1. Checking Docker containers status...
docker-compose ps
echo.
echo 2. Checking backend logs for JWT errors...
docker-compose logs --tail=50 backend | findstr -i "jwt\|oauth\|security\|error"
echo.
echo 3. Checking Keycloak logs...
docker-compose logs --tail=30 keycloak | findstr -i "error\|warn\|started"
echo.
echo 4. Testing Keycloak connectivity from backend container...
docker-compose exec backend curl -v http://keycloak:8080/health
echo.
echo 5. Testing Keycloak realm endpoint...
docker-compose exec backend curl -v http://keycloak:8080/realms/workout-realm
echo.
echo 6. Testing JWT certificates endpoint...
docker-compose exec backend curl -v http://keycloak:8080/realms/workout-realm/protocol/openid-connect/certs
echo.
echo 7. Checking backend environment variables...
docker-compose exec backend env | findstr -i "jwt\|oauth\|keycloak\|spring"
echo.
echo 8. Testing backend health endpoint...
curl -v http://localhost:8080/health
echo.
echo 9. Testing backend with JWT token...
echo.
echo To get a JWT token, run: get-token-simple.bat
echo Then test with: curl -H "Authorization: Bearer YOUR_TOKEN" http://localhost:8080/api/workouts
echo.
echo 10. Common JWT issues and solutions:
echo.
echo Issue: JwtDecoderInitializationException
echo Solution: Check Keycloak connectivity and realm configuration
echo.
echo Issue: Invalid issuer
echo Solution: Verify KEYCLOAK_ISSUER_URI matches Keycloak realm
echo.
echo Issue: Connection refused
echo Solution: Ensure Keycloak is running and accessible from backend container
echo.
echo 11. Keycloak setup verification:
echo - Open http://localhost:8081 in browser
echo - Login with admin/admin
echo - Check if workout-realm exists
echo - Check if workout-client exists and is configured correctly
echo.
pause
