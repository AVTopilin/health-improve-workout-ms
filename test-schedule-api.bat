@echo off
echo ========================================
echo Testing Workout Schedule API Endpoints
echo ========================================
echo.

REM Получаем JWT токен
echo 1. Getting JWT token...
call get-token-simple.bat
if %errorlevel% neq 0 (
    echo Failed to get JWT token
    pause
    exit /b 1
)

REM Читаем токен из файла
set /p JWT_TOKEN=<jwt_token_simple.txt
echo JWT token obtained successfully
echo.

REM Тестируем генерацию расписания (предварительный просмотр)
echo 2. Testing schedule generation (preview)...
curl -X POST "http://localhost:8080/api/schedule/generate?startDate=2024-01-01&weeksCount=4" ^
  -H "Authorization: Bearer %JWT_TOKEN%" ^
  -H "Content-Type: application/json" ^
  -d "{\"id\":1,\"name\":\"Test Workout\",\"exercises\":[{\"exerciseTemplateId\":1,\"weight\":50,\"reps\":10,\"sets\":3,\"restTime\":60,\"progression\":{\"weightProgressionEnabled\":true,\"weightPeriodicity\":\"EVERY_WORKOUT\",\"weightIncrementType\":\"INCREMENT\",\"weightIncrementValue\":2.5}}]}" ^
  -s | jq .
echo.

REM Тестируем получение всех расписаний
echo 3. Testing get all schedules...
curl -X GET "http://localhost:8080/api/schedule" ^
  -H "Authorization: Bearer %JWT_TOKEN%" ^
  -s | jq .
echo.

REM Тестируем получение расписания по ID (если есть)
echo 4. Testing get schedule by ID...
curl -X GET "http://localhost:8080/api/schedule/1" ^
  -H "Authorization: Bearer %JWT_TOKEN%" ^
  -s | jq .
echo.

REM Тестируем получение расписания для конкретной тренировки
echo 5. Testing get schedules by workout...
curl -X GET "http://localhost:8080/api/schedule/workout/1" ^
  -H "Authorization: Bearer %JWT_TOKEN%" ^
  -s | jq .
echo.

REM Тестируем получение расписания в диапазоне дат
echo 6. Testing get schedules by date range...
curl -X GET "http://localhost:8080/api/schedule/range?startDate=2024-01-01&endDate=2024-01-31" ^
  -H "Authorization: Bearer %JWT_TOKEN%" ^
  -s | jq .
echo.

echo ========================================
echo Testing completed!
echo ========================================
pause
