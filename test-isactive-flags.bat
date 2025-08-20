@echo off
echo Testing all APIs with isActive flags...
echo.

echo Reading JWT token...
set /p JWT_TOKEN=<jwt_token_simple.txt

echo.
echo ========================================
echo 1. Testing Equipment API (should show isActive)
echo ========================================
echo GET /api/equipment:
curl -s -H "Authorization: Bearer %JWT_TOKEN%" http://localhost:8080/api/equipment
echo.

echo.
echo ========================================
echo 2. Testing Exercise Template API (should show isActive)
echo ========================================
echo GET /api/exercise-templates:
curl -s -H "Authorization: Bearer %JWT_TOKEN%" http://localhost:8080/api/exercise-templates
echo.

echo.
echo ========================================
echo 3. Testing Muscle Group API (should show isActive)
echo ========================================
echo GET /api/muscle-groups:
curl -s -H "Authorization: Bearer %JWT_TOKEN%" http://localhost:8080/api/muscle-groups
echo.

echo.
echo ========================================
echo 4. Testing Progression API (should show isActive)
echo ========================================
echo GET /api/progressions:
curl -s -H "Authorization: Bearer %JWT_TOKEN%" http://localhost:8080/api/progressions
echo.

echo.
echo ========================================
echo 5. Testing specific entities by ID
echo ========================================
echo GET /api/equipment/1:
curl -s -H "Authorization: Bearer %JWT_TOKEN%" http://localhost:8080/api/equipment/1
echo.

echo GET /api/exercise-templates/1:
curl -s -H "Authorization: Bearer %JWT_TOKEN%" http://localhost:8080/api/exercise-templates/1
echo.

echo GET /api/muscle-groups/1:
curl -s -H "Authorization: Bearer %JWT_TOKEN%" http://localhost:8080/api/muscle-groups/1
echo.

echo GET /api/progressions/1:
curl -s -H "Authorization: Bearer %JWT_TOKEN%" http://localhost:8080/api/progressions/1
echo.

echo.
echo ========================================
echo Test completed!
echo ========================================
pause
