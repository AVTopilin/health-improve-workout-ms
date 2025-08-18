@echo off
chcp 65001 >nul
echo Opening Swagger UI in browser...
echo.
echo URL: http://localhost:8080/swagger-ui/index.html
echo.
echo Make sure the backend application is running on port 8080
echo.
echo For JWT token setup guide, open: swagger-guide.html
echo.
start http://localhost:8080/swagger-ui/index.html
echo.
echo Swagger UI opened in browser!
echo.
echo To add JWT token:
echo 1. Click "Authorize" button (🔒) in top-right corner
echo 2. Enter: Bearer YOUR_JWT_TOKEN_HERE
echo 3. Click "Authorize"
echo.
pause
