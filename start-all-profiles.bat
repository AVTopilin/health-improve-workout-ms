@echo off
echo Запуск Workout Backend с разными профилями...
echo.
echo 1. Сначала запустите инфраструктуру:
echo    start-infrastructure.bat
echo.
echo 2. Откройте IntelliJ IDEA
echo 3. File -> Open -> выберите папку workout_backend_new
echo 4. Дождитесь импорта Maven проекта
echo.
echo 5. Создайте Run Configuration для каждого профиля:
echo.
echo === ПРОФИЛЬ LOCAL (рекомендуется для разработки) ===
echo - Name: WorkoutApplication (Local)
echo - Main class: com.workout.WorkoutApplication
echo - VM options: -Dspring.profiles.active=local
echo - Working directory: C:\Dev\workout\workout_backend_new
echo - Особенности: create-drop, debug logging, localhost
echo.
echo === ПРОФИЛЬ DEV ===
echo - Name: WorkoutApplication (Dev)
echo - Main class: com.workout.WorkoutApplication
echo - VM options: -Dspring.profiles.active=dev
echo - Working directory: C:\Dev\workout\workout_backend_new
echo - Особенности: create-drop, debug logging, localhost
echo.
echo === ПРОФИЛЬ PROD ===
echo - Name: WorkoutApplication (Prod)
echo - Main class: com.workout.WorkoutApplication
echo - VM options: -Dspring.profiles.active=prod
echo - Working directory: C:\Dev\workout\workout_backend_new
echo - Особенности: update, production logging, postgres:5432
echo.
echo ВСЕ ПРОФИЛИ используют:
echo - PostgreSQL базу данных
echo - Keycloak для аутентификации
echo - OAuth2 JWT токены
echo.
pause
