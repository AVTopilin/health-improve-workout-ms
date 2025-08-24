# Тестирование Workout Schedule API Endpoints
Write-Host "========================================" -ForegroundColor Green
Write-Host "Testing Workout Schedule API Endpoints" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""

# Получаем JWT токен
Write-Host "1. Getting JWT token..." -ForegroundColor Yellow
try {
    & .\get-token-simple.bat
    if ($LASTEXITCODE -ne 0) {
        Write-Host "Failed to get JWT token" -ForegroundColor Red
        Read-Host "Press Enter to continue"
        exit 1
    }
    
    $jwtToken = Get-Content "jwt_token_simple.txt" -ErrorAction Stop
    Write-Host "JWT token obtained successfully" -ForegroundColor Green
} catch {
    Write-Host "Error reading JWT token: $_" -ForegroundColor Red
    Read-Host "Press Enter to continue"
    exit 1
}

Write-Host ""

# Базовый URL и заголовки
$baseUrl = "http://localhost:8080"
$headers = @{
    "Authorization" = "Bearer $jwtToken"
    "Content-Type" = "application/json"
}

# Тестовые данные для тренировки
$testWorkout = @{
    id = 1
    name = "Test Workout - Bench Press"
    exercises = @(
        @{
            exerciseTemplateId = 1
            weight = 50.0
            reps = 10
            sets = 3
            restTime = 60
            progression = @{
                weightProgressionEnabled = $true
                weightPeriodicity = "EVERY_WORKOUT"
                weightIncrementType = "INCREMENT"
                weightIncrementValue = 2.5
                repsProgressionEnabled = $false
                setsProgressionEnabled = $false
            }
        },
        @{
            exerciseTemplateId = 2
            weight = 30.0
            reps = 12
            sets = 4
            restTime = 45
            progression = @{
                weightProgressionEnabled = $true
                weightPeriodicity = "EVERY_WORKOUT"
                weightIncrementType = "CYCLE"
                weightInitialValue = 30.0
                weightFinalValue = 40.0
                repsProgressionEnabled = $true
                repsPeriodicity = "EVERY_WORKOUT"
                repsIncrementType = "INCREMENT"
                repsIncrementValue = 1
                setsProgressionEnabled = $false
            }
        }
    )
}

# Тестируем генерацию расписания (предварительный просмотр)
Write-Host "2. Testing schedule generation (preview)..." -ForegroundColor Yellow
try {
    $response = Invoke-RestMethod -Uri "$baseUrl/api/schedule/generate?startDate=2024-01-01&weeksCount=4" `
        -Method POST -Headers $headers -Body ($testWorkout | ConvertTo-Json -Depth 10)
    
    Write-Host "Schedule generation successful!" -ForegroundColor Green
    Write-Host "Generated schedules: $($response.Count)" -ForegroundColor Green
    
    # Показываем детали первого расписания
    if ($response.Count -gt 0) {
        $firstSchedule = $response[0]
        Write-Host "First schedule details:" -ForegroundColor Cyan
        Write-Host "  Week: $($firstSchedule.weekNumber)" -ForegroundColor Cyan
        Write-Host "  Date: $($firstSchedule.workoutDate)" -ForegroundColor Cyan
        Write-Host "  Exercises: $($firstSchedule.exercises.Count)" -ForegroundColor Cyan
        
        # Показываем детали первого упражнения
        if ($firstSchedule.exercises.Count -gt 0) {
            $firstExercise = $firstSchedule.exercises[0]
            Write-Host "  First exercise:" -ForegroundColor Cyan
            Write-Host "    Weight: $($firstExercise.plannedWeight) kg" -ForegroundColor Cyan
            Write-Host "    Reps: $($firstExercise.plannedReps)" -ForegroundColor Cyan
            Write-Host "    Sets: $($firstExercise.plannedSets)" -ForegroundColor Cyan
        }
    }
    
    # Сохраняем сгенерированные расписания для следующего теста
    $generatedSchedules = $response
    
} catch {
    Write-Host "Error generating schedule: $_" -ForegroundColor Red
    $generatedSchedules = @()
}

Write-Host ""

# Тестируем создание расписаний в БД (если есть сгенерированные)
if ($generatedSchedules.Count -gt 0) {
    Write-Host "3. Testing schedule creation in database..." -ForegroundColor Yellow
    try {
        $response = Invoke-RestMethod -Uri "$baseUrl/api/schedule/create" `
            -Method POST -Headers $headers -Body ($generatedSchedules | ConvertTo-Json -Depth 10)
        
        Write-Host "Schedule creation successful!" -ForegroundColor Green
        Write-Host "Created schedules: $($response.Count)" -ForegroundColor Green
        
        # Показываем ID созданных расписаний
        $scheduleIds = $response | ForEach-Object { $_.id }
        Write-Host "Created schedule IDs: $($scheduleIds -join ', ')" -ForegroundColor Cyan
        
    } catch {
        Write-Host "Error creating schedules: $_" -ForegroundColor Red
    }
} else {
    Write-Host "3. Skipping schedule creation (no generated schedules)" -ForegroundColor Yellow
}

Write-Host ""

# Тестируем получение всех расписаний
Write-Host "4. Testing get all schedules..." -ForegroundColor Yellow
try {
    $response = Invoke-RestMethod -Uri "$baseUrl/api/schedule" -Method GET -Headers $headers
    Write-Host "Get all schedules successful!" -ForegroundColor Green
    Write-Host "Total schedules: $($response.Count)" -ForegroundColor Green
} catch {
    Write-Host "Error getting all schedules: $_" -ForegroundColor Red
}

Write-Host ""

# Тестируем получение расписания для конкретной тренировки
Write-Host "5. Testing get schedules by workout..." -ForegroundColor Yellow
try {
    $response = Invoke-RestMethod -Uri "$baseUrl/api/schedule/workout/1" -Method GET -Headers $headers
    Write-Host "Get schedules by workout successful!" -ForegroundColor Green
    Write-Host "Schedules for workout 1: $($response.Count)" -ForegroundColor Green
} catch {
    Write-Host "Error getting schedules by workout: $_" -ForegroundColor Red
}

Write-Host ""

# Тестируем получение расписания в диапазоне дат
Write-Host "6. Testing get schedules by date range..." -ForegroundColor Yellow
try {
    $response = Invoke-RestMethod -Uri "$baseUrl/api/schedule/range?startDate=2024-01-01&endDate=2024-01-31" -Method GET -Headers $headers
    Write-Host "Get schedules by date range successful!" -ForegroundColor Green
    Write-Host "Schedules in date range: $($response.Count)" -ForegroundColor Green
} catch {
    Write-Host "Error getting schedules by date range: $_" -ForegroundColor Red
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host "Testing completed!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green

Read-Host "Press Enter to continue"
