@echo off
chcp 65001 >nul
echo Keycloak Setup Guide for Workout Backend
echo ========================================
echo.
echo This script will guide you through setting up Keycloak for the workout backend.
echo.
echo Prerequisites:
echo - Keycloak must be running on http://localhost:8081
echo - Docker containers must be started
echo.
echo Press any key to continue...
pause >nul
echo.
echo Step 1: Access Keycloak Admin Console
echo -------------------------------------
echo 1. Open your browser and go to: http://localhost:8081
echo 2. Click on "Administration Console"
echo 3. Login with:
echo    - Username: admin
echo    - Password: admin
echo.
echo Press any key to continue to next step...
pause >nul
echo.
echo Step 2: Create Realm
echo --------------------
echo 1. In the top-left corner, click on the dropdown (shows "master")
echo 2. Click "Create Realm"
echo 3. Enter Realm name: workout-realm
echo 4. Click "Create"
echo.
echo Press any key to continue to next step...
pause >nul
echo.
echo Step 3: Create Client
echo ---------------------
echo 1. In the left menu, click "Clients"
echo 2. Click "Create"
echo 3. Fill in the form:
echo    - Client ID: workout-client
echo    - Client Protocol: openid-connect
echo    - Click "Save"
echo 4. In the Settings tab:
echo    - Access Type: confidential
echo    - Valid Redirect URIs: *
echo    - Web Origins: *
echo    - Click "Save"
echo 5. Go to "Credentials" tab and copy the Client Secret
echo.
echo Press any key to continue to next step...
pause >nul
echo.
echo Step 4: Create User
echo -------------------
echo 1. In the left menu, click "Users"
echo 2. Click "Add user"
echo 3. Fill in the form:
echo    - Username: testuser
echo    - Email: test@example.com
echo    - First Name: Test
echo    - Last Name: User
echo    - Email Verified: ON
echo    - Click "Save"
echo 4. Go to "Credentials" tab:
echo    - New Password: test123
echo    - Password Confirmation: test123
echo    - Temporary: OFF
echo    - Click "Save"
echo.
echo Press any key to continue to next step...
pause >nul
echo.
echo Step 5: Test Configuration
echo --------------------------
echo Now you can test the configuration:
echo.
echo 1. Run: get-token-simple.bat
echo 2. Or test manually with curl:
echo    curl -X POST http://localhost:8081/realms/workout-realm/protocol/openid-connect/token ^
echo         -H "Content-Type: application/x-www-form-urlencoded" ^
echo         -d "grant_type=password&client_id=workout-client&username=testuser&password=test123"
echo.
echo Configuration Summary:
echo - Realm: workout-realm
echo - Client: workout-client (confidential)
echo - User: testuser / test123
echo - Token endpoint: http://localhost:8081/realms/workout-realm/protocol/openid-connect/token
echo.
echo Setup completed! You can now test JWT token retrieval.
echo.
pause
