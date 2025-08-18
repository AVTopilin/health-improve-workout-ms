@echo off
echo Запуск Workout Backend в режиме разработки...
echo.
echo Инструкции для IntelliJ IDEA:
echo.
echo 1. Сначала запустите инфраструктуру:
echo    start-infrastructure.bat
echo.
echo 2. Откройте IntelliJ IDEA
echo 3. File -> Open -> выберите папку workout_backend_new
echo 4. Дождитесь импорта Maven проекта
echo 5. Создайте Run Configuration:
echo    - Run -> Edit Configurations...
echo    - + -> Spring Boot
echo    - Name: WorkoutApplication (Local)
echo    - Main class: com.workout.WorkoutApplication
echo    - VM options: -Dspring.profiles.active=local
echo    - Working directory: C:\Dev\workout\workout_backend_new
echo.
echo 6. Запустите приложение
echo.
echo После запуска приложение будет доступно по адресам:
echo - Основная страница: http://localhost:8080
echo - Swagger UI: http://localhost:8080/swagger-ui/index.html
echo - API: http://localhost:8080/api/workouts
echo - PostgreSQL: localhost:5432
echo - Keycloak: http://localhost:8081
echo.
pause
