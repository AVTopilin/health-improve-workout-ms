@echo off
echo Switching Spring profile...

if "%1"=="prod" (
    echo Setting profile to PRODUCTION (with JWT auth)
    powershell -Command "(Get-Content docker-compose.yml) -replace 'SPRING_PROFILES_ACTIVE: .*', '      SPRING_PROFILES_ACTIVE: prod' | Set-Content docker-compose.yml"
    echo Profile set to PRODUCTION
) else if "%1"=="debug" (
    echo Setting profile to DEBUG (without JWT auth)
    powershell -Command "(Get-Content docker-compose.yml) -replace 'SPRING_PROFILES_ACTIVE: .*', '      SPRING_PROFILES_ACTIVE: debug' | Set-Content docker-compose.yml"
    echo Profile set to DEBUG
) else if "%1"=="dev" (
    echo Setting profile to DEVELOPMENT (without JWT auth)
    powershell -Command "(Get-Content docker-compose.yml) -replace 'SPRING_PROFILES_ACTIVE: .*', '      SPRING_PROFILES_ACTIVE: dev' | Set-Content docker-compose.yml"
    echo Profile set to DEVELOPMENT
) else (
    echo Usage: switch-profile.bat [prod^|debug^|dev]
    echo Current profile:
    findstr "SPRING_PROFILES_ACTIVE" docker-compose.yml
    exit /b 1
)

echo.
echo Current profile:
findstr "SPRING_PROFILES_ACTIVE" docker-compose.yml

echo.
echo Remember to restart containers with: docker-compose down && docker-compose up -d
pause
