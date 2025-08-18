@echo off
echo Создание тестовых данных для API...
echo.
echo 1. Создание пользователя (автоматически в dev режиме):
echo    - Пользователь создается автоматически при первом запросе
echo    - Keycloak ID: dev-user
echo    - Email: dev@example.com
echo.
echo 2. Создание тренировки:
echo    curl -X POST http://localhost:8080/api/workouts \
echo         -H "Content-Type: application/json" \
echo         -d "{\"name\":\"Тестовая тренировка\",\"description\":\"Описание тестовой тренировки\"}"
echo.
echo 3. Создание упражнения (после создания тренировки):
echo    curl -X POST http://localhost:8080/api/exercises \
echo         -H "Content-Type: application/json" \
echo         -d "{\"workoutId\":1,\"name\":\"Жим лежа\",\"sets\":3,\"reps\":10,\"weight\":80.0,\"restTime\":120,\"exerciseOrder\":1,\"notes\":\"Тестовое упражнение\"}"
echo.
echo 4. Создание расписания:
echo    curl -X POST http://localhost:8080/api/schedule \
echo         -H "Content-Type: application/json" \
echo         -d "{\"workoutId\":1,\"dayOfWeek\":1,\"isActive\":true}"
echo.
echo 5. Создание прогрессии:
echo    curl -X POST http://localhost:8080/api/progressions \
echo         -H "Content-Type: application/json" \
echo         -d "{\"exerciseId\":1,\"type\":\"WEIGHT_INCREASE\",\"amount\":2.5,\"frequency\":\"EVERY_WORKOUT\",\"isActive\":true}"
echo.
echo 6. Создание сессии тренировки:
echo    curl -X POST http://localhost:8080/api/workout-sessions \
echo         -H "Content-Type: application/json" \
echo         -d "{\"workoutId\":1,\"startTime\":1704067200000,\"status\":\"IN_PROGRESS\",\"currentExerciseIndex\":0,\"currentSetIndex\":0}"
echo.
echo 7. Создание подхода:
echo    curl -X POST http://localhost:8080/api/exercise-sets \
echo         -H "Content-Type: application/json" \
echo         -d "{\"sessionId\":1,\"exerciseId\":1,\"setNumber\":1,\"reps\":10,\"weight\":80.0,\"completedAt\":1704067200000,\"notes\":\"Первый подход\"}"
echo.
echo После создания данных проверьте GET endpoints:
echo - GET /api/workouts - должен вернуть созданную тренировку
echo - GET /api/exercises/workout/1 - должен вернуть упражнения
echo - GET /api/schedule - должен вернуть расписание
echo.
pause
