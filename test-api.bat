@echo off
echo Тестирование API endpoints...
echo.
echo Приложение должно быть запущено на http://localhost:8080
echo.
echo 1. Проверка основного endpoint:
echo    curl -X GET http://localhost:8080/
echo.
echo 2. Проверка Swagger UI:
echo    Откройте: http://localhost:8080/swagger-ui/index.html
echo.
echo 3. Проверка API документации:
echo    curl -X GET http://localhost:8080/v3/api-docs
echo.
echo 4. Тестирование workouts endpoint (без аутентификации в dev режиме):
echo    curl -X GET http://localhost:8080/api/workouts
echo.
echo 5. Тестирование exercises endpoint:
echo    curl -X GET http://localhost:8080/api/exercises/workout/1
echo.
echo 6. Тестирование schedule endpoint:
echo    curl -X GET http://localhost:8080/api/schedule
echo.
echo 7. Тестирование progressions endpoint:
echo    curl -X GET "http://localhost:8080/api/progressions?exerciseId=1"
echo.
echo 8. Тестирование workout-sessions endpoint:
echo    curl -X GET http://localhost:8080/api/workout-sessions
echo.
echo 9. Тестирование exercise-sets endpoint:
echo    curl -X GET http://localhost:8080/api/exercise-sets
echo.
echo 10. Тестирование generate-workouts endpoint:
echo     curl -X POST http://localhost:8080/api/generate-workouts \
echo          -H "Content-Type: application/json" \
echo          -d "{\"startDate\":\"2024-01-01\",\"numberOfWorkouts\":3}"
echo.
echo Примечания:
echo - В dev режиме аутентификация отключена
echo - Некоторые endpoints могут возвращать пустые списки (нет данных)
echo - Для создания данных используйте POST запросы
echo.
pause
