@echo off
echo Testing Schedule Generation API
echo ================================
echo.

REM Получаем JWT токен
echo Getting JWT token...
call get-token-simple.bat
if %errorlevel% neq 0 (
    echo Failed to get JWT token
    pause
    exit /b 1
)

REM Читаем токен
set /p JWT_TOKEN=<jwt_token_simple.txt
echo JWT token obtained
echo.

REM Тестируем генерацию расписания
echo Testing schedule generation...
curl -X POST "http://localhost:8080/api/schedule/generate?startDate=2024-01-01&weeksCount=4" ^
  -H "Authorization: Bearer %JWT_TOKEN%" ^
  -H "Content-Type: application/json" ^
  -d "{\"id\":1,\"name\":\"Test Workout\",\"exercises\":[{\"exerciseTemplateId\":1,\"weight\":50,\"reps\":10,\"sets\":3,\"restTime\":60,\"progression\":{\"weightProgressionEnabled\":true,\"weightPeriodicity\":\"EVERY_WORKOUT\",\"weightIncrementType\":\"INCREMENT\",\"weightIncrementValue\":2.5}}]}" ^
  -s

echo.
echo Test completed!
pause
