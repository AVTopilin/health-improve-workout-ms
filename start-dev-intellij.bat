@echo off
echo Запуск приложения в dev режиме через IntelliJ IDEA...
echo.
echo 1. Откройте проект workout_backend_new в IntelliJ IDEA
echo.
echo 2. Найдите файл WorkoutApplication.java
echo.
echo 3. Нажмите правой кнопкой мыши на класс WorkoutApplication
echo.
echo 4. Выберите "Modify Run Configuration..."
echo.
echo 5. В поле "VM options" добавьте:
echo    -Dspring.profiles.active=dev
echo.
echo 6. Нажмите "OK"
echo.
echo 7. Запустите приложение (Shift+F10)
echo.
echo Альтернативно:
echo - Run -> Edit Configurations...
echo - Нажмите "+" -> Application
echo - Main class: com.workout.WorkoutApplication
echo - VM options: -Dspring.profiles.active=dev
echo - Working directory: C:\Dev\workout\workout_backend_new
echo.
echo После запуска проверьте:
echo - http://localhost:8080/ (должен вернуть JSON)
echo - http://localhost:8080/swagger-ui/index.html (Swagger UI)
echo.
pause
