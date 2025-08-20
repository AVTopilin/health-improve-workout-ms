Write-Host '🧪 Testing ALL API endpoints...' -ForegroundColor Cyan

Write-Host "`n========================================" -ForegroundColor Yellow
Write-Host '1. Testing Health and Basic Endpoints' -ForegroundColor Yellow
Write-Host '========================================' -ForegroundColor Yellow

Write-Host "`n🏥 Testing /health..." -ForegroundColor Green
try {
    $response = Invoke-WebRequest -Uri 'http://localhost:8080/health' -Method GET
    Write-Host "✅ Health check successful: $($response.StatusCode)" -ForegroundColor Green
    Write-Host "Response: $($response.Content)" -ForegroundColor Gray
} catch {
    Write-Host "❌ Health check failed: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host "`n🏠 Testing /..." -ForegroundColor Green
try {
    $response = Invoke-WebRequest -Uri 'http://localhost:8080/' -Method GET
    Write-Host "✅ Root endpoint successful: $($response.StatusCode)" -ForegroundColor Green
    Write-Host "Response: $($response.Content)" -ForegroundColor Gray
} catch {
    Write-Host "❌ Root endpoint failed: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host "`n📝 Testing /test-json..." -ForegroundColor Green
try {
    $testData = @{ test = 'data' } | ConvertTo-Json
    $response = Invoke-RestMethod -Uri 'http://localhost:8080/test-json' -Method POST -Body $testData -ContentType 'application/json'
    Write-Host "✅ Test JSON successful: $($response.message)" -ForegroundColor Green
} catch {
    Write-Host "❌ Test JSON failed: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host "`n========================================" -ForegroundColor Yellow
Write-Host '2. Testing Workout API' -ForegroundColor Yellow
Write-Host '========================================' -ForegroundColor Yellow

Write-Host "`n🏋️ Creating workout..." -ForegroundColor Green
try {
    $workoutData = @{
        name = 'API Test Workout'
        dayOfWeek = 'MONDAY'
        weeksCount = 2
        startDate = '2025-08-19'
    } | ConvertTo-Json
    $response = Invoke-RestMethod -Uri 'http://localhost:8080/api/workouts' -Method POST -Body $workoutData -ContentType 'application/json'
    Write-Host "✅ Workout created: $($response.name) (ID: $($response.id))" -ForegroundColor Green
} catch {
    Write-Host "❌ Workout creation failed: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host "`n📋 Getting all workouts..." -ForegroundColor Green
try {
    $response = Invoke-RestMethod -Uri 'http://localhost:8080/api/workouts' -Method GET
    Write-Host "✅ Workouts retrieved: $($response.Count) workouts found" -ForegroundColor Green
} catch {
    Write-Host "❌ Get workouts failed: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host "`n========================================" -ForegroundColor Yellow
Write-Host '3. Testing Exercise API' -ForegroundColor Yellow
Write-Host '========================================' -ForegroundColor Yellow

Write-Host "`n💪 Creating exercise..." -ForegroundColor Green
try {
    $exerciseData = @{
        name = 'API Test Exercise'
        description = 'Test exercise for API testing'
        sets = 3
        reps = 10
        weight = 50.5
        workoutId = 1
    } | ConvertTo-Json
    $response = Invoke-RestMethod -Uri 'http://localhost:8080/api/exercises' -Method POST -Body $exerciseData -ContentType 'application/json'
    Write-Host "✅ Exercise created: $($response.name) (ID: $($response.id))" -ForegroundColor Green
} catch {
    Write-Host "❌ Exercise creation failed: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host "`n📋 Getting all exercises..." -ForegroundColor Green
try {
    $response = Invoke-RestMethod -Uri 'http://localhost:8080/api/exercises' -Method GET
    Write-Host "✅ Exercises retrieved: $($response.Count) exercises found" -ForegroundColor Green
} catch {
    Write-Host "❌ Get exercises failed: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host "`n========================================" -ForegroundColor Yellow
Write-Host '4. Testing Exercise Template API' -ForegroundColor Yellow
Write-Host '========================================' -ForegroundColor Yellow

Write-Host "`n📋 Creating exercise template..." -ForegroundColor Green
try {
    $templateData = @{
        name = 'API Test Template'
        description = 'Test template for API testing'
        difficultyLevel = 'BEGINNER'
        muscleGroupId = 1
    } | ConvertTo-Json
    $response = Invoke-RestMethod -Uri 'http://localhost:8080/api/exercise-templates' -Method POST -Body $templateData -ContentType 'application/json'
    Write-Host "✅ Template created: $($response.name) (ID: $($response.id))" -ForegroundColor Green
} catch {
    Write-Host "❌ Template creation failed: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host "`n📋 Getting all exercise templates..." -ForegroundColor Green
try {
    $response = Invoke-RestMethod -Uri 'http://localhost:8080/api/exercise-templates' -Method GET
    Write-Host "✅ Templates retrieved: $($response.Count) templates found" -ForegroundColor Green
} catch {
    Write-Host "❌ Get templates failed: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host "`n========================================" -ForegroundColor Yellow
Write-Host '5. Testing Muscle Group API' -ForegroundColor Yellow
Write-Host '========================================' -ForegroundColor Yellow

Write-Host "`n💪 Creating muscle group..." -ForegroundColor Green
try {
    $muscleData = @{
        name = 'API Test Muscle Group'
        description = 'Test muscle group for API testing'
    } | ConvertTo-Json
    $response = Invoke-RestMethod -Uri 'http://localhost:8080/api/muscle-groups' -Method POST -Body $muscleData -ContentType 'application/json'
    Write-Host "✅ Muscle group created: $($response.name) (ID: $($response.id))" -ForegroundColor Green
} catch {
    Write-Host "❌ Muscle group creation failed: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host "`n📋 Getting all muscle groups..." -ForegroundColor Green
try {
    $response = Invoke-RestMethod -Uri 'http://localhost:8080/api/muscle-groups' -Method GET
    Write-Host "✅ Muscle groups retrieved: $($response.Count) groups found" -ForegroundColor Green
} catch {
    Write-Host "❌ Get muscle groups failed: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host "`n========================================" -ForegroundColor Yellow
Write-Host '6. Testing Equipment API' -ForegroundColor Yellow
Write-Host '========================================' -ForegroundColor Yellow

Write-Host "`n🏋️ Creating equipment..." -ForegroundColor Green
try {
    $equipmentData = @{
        name = 'API Test Equipment'
        description = 'Test equipment for API testing'
        equipmentType = 'DUMBBELL'
    } | ConvertTo-Json
    $response = Invoke-RestMethod -Uri 'http://localhost:8080/api/equipment' -Method POST -Body $equipmentData -ContentType 'application/json'
    Write-Host "✅ Equipment created: $($response.name) (ID: $($response.id))" -ForegroundColor Green
} catch {
    Write-Host "❌ Equipment creation failed: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host "`n📋 Getting all equipment..." -ForegroundColor Green
try {
    $response = Invoke-RestMethod -Uri 'http://localhost:8080/api/equipment' -Method GET
    Write-Host "✅ Equipment retrieved: $($response.Count) items found" -ForegroundColor Green
} catch {
    Write-Host "❌ Get equipment failed: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host "`n========================================" -ForegroundColor Yellow
Write-Host '7. Testing Progression API' -ForegroundColor Yellow
Write-Host '========================================' -ForegroundColor Yellow

Write-Host "`n📈 Creating progression..." -ForegroundColor Green
try {
    $progressionData = @{
        exerciseId = 1
        incrementType = 'WEIGHT'
        incrementValue = 2.5
        periodicityType = 'WEEKLY'
        periodicityValue = 1
    } | ConvertTo-Json
    $response = Invoke-RestMethod -Uri 'http://localhost:8080/api/progressions' -Method POST -Body $progressionData -ContentType 'application/json'
    Write-Host "✅ Progression created: $($response.incrementType) (ID: $($response.id))" -ForegroundColor Green
} catch {
    Write-Host "❌ Progression creation failed: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host "`n📋 Getting all progressions..." -ForegroundColor Green
try {
    $response = Invoke-RestMethod -Uri 'http://localhost:8080/api/progressions' -Method GET
    Write-Host "✅ Progressions retrieved: $($response.Count) progressions found" -ForegroundColor Green
} catch {
    Write-Host "❌ Get progressions failed: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host "`n========================================" -ForegroundColor Yellow
Write-Host '8. Testing User API' -ForegroundColor Yellow
Write-Host '========================================' -ForegroundColor Yellow

Write-Host "`n👤 Getting all users..." -ForegroundColor Green
try {
    $response = Invoke-RestMethod -Uri 'http://localhost:8080/api/users' -Method GET
    Write-Host "✅ Users retrieved: $($response.Count) users found" -ForegroundColor Green
} catch {
    Write-Host "❌ Get users failed: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host "`n========================================" -ForegroundColor Yellow
Write-Host '9. Testing Swagger/OpenAPI' -ForegroundColor Yellow
Write-Host '========================================' -ForegroundColor Yellow

Write-Host "`n📚 Testing Swagger UI..." -ForegroundColor Green
try {
    $response = Invoke-WebRequest -Uri 'http://localhost:8080/swagger-ui.html' -Method GET
    Write-Host "✅ Swagger UI accessible: $($response.StatusCode)" -ForegroundColor Green
} catch {
    Write-Host "❌ Swagger UI failed: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host "`n📖 Testing API docs..." -ForegroundColor Green
try {
    $response = Invoke-WebRequest -Uri 'http://localhost:8080/v3/api-docs' -Method GET
    Write-Host "✅ API docs accessible: $($response.StatusCode)" -ForegroundColor Green
} catch {
    Write-Host "❌ API docs failed: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host '🎉 API Testing Completed!' -ForegroundColor Green
Write-Host '========================================' -ForegroundColor Cyan
Read-Host 'Press Enter to continue'
