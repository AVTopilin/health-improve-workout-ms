@echo off
chcp 65001 >nul
echo Building Spring Boot Application...
echo.
echo This will build the JAR file locally using Maven
echo.
echo Prerequisites:
echo - Java 17+ must be installed
echo - Maven 3.6+ must be installed
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
echo 3. Building application...
mvn clean package -DskipTests
if %errorlevel% neq 0 (
    echo [ERROR] Failed to build application
    pause
    exit /b 1
)
echo.
echo 4. Checking JAR file...
if exist "target\*.jar" (
    echo [OK] Application built successfully!
    echo JAR file location: target\
    dir target\*.jar
    echo.
    echo Next steps:
    echo - Run start-full-stack.bat to start the full stack
    echo - Or run start-dev-stack.bat for development
) else (
    echo [ERROR] JAR file not found after build
)
echo.
pause
