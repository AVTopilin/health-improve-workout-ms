@echo off
echo Checking compilation after nested progression fixes...
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
    echo All compilation errors have been fixed:
    echo - Added missing fields to ProgressionDto
    echo - Fixed enum type mismatches
    echo - Updated ExerciseController for nested progression
    echo - Fixed ProgressionCalculationService constants
    echo - Updated ProgressionService for compatibility
    echo.
    echo Next steps:
    echo 1. Run: mvn package -DskipTests
    echo 2. Run: docker-compose build backend
    echo 3. Run: docker-compose up -d
    echo 4. Test the API with: test-nested-progression.bat
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
