@echo off
echo Testing Equipment API without JWT...
echo.

echo Testing GET /health...
curl -s http://localhost:8080/health
echo.

echo Testing GET /api/equipment (should return 401)...
curl -s http://localhost:8080/api/equipment
echo.

echo Testing GET /api/equipment/1 (should return 401)...
curl -s http://localhost:8080/api/equipment/1
echo.

pause
