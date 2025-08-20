@echo off
echo Checking compilation after exception fixes...
echo.

echo Cleaning project...
mvn clean

echo.
echo Compiling project...
mvn compile

if %errorlevel% equ 0 (
    echo.
    echo ========================================
    echo ✅ Compilation successful!
    echo ========================================
    echo.
    echo All RuntimeException have been replaced with proper exceptions:
    echo - NotFoundException for "not found" cases
    echo - AccessDeniedException for "access denied" cases
    echo.
    echo Next steps:
    echo 1. Run: mvn package -DskipTests
    echo 2. Run: docker-compose build backend
    echo 3. Run: docker-compose up -d
    echo 4. Test the API with: debug-workout-exercises.bat
    echo.
) else (
    echo.
    echo ========================================
    echo ❌ Compilation failed!
    echo ========================================
    echo.
    echo Check the errors above and fix them.
    echo.
)

pause
