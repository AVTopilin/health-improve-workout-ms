Write-Host "🧪 Testing DEBUG profile without JWT authentication..." -ForegroundColor Cyan

Write-Host "`n🏗️ Step 1: Building application..." -ForegroundColor Green
mvn clean package -DskipTests

Write-Host "`n🐳 Step 2: Building Docker image..." -ForegroundColor Green
docker-compose build --no-cache

Write-Host "`n▶️ Step 3: Starting containers..." -ForegroundColor Green
docker-compose up -d

Write-Host "`n⏳ Step 4: Waiting for services to be ready..." -ForegroundColor Yellow
Start-Sleep -Seconds 60

Write-Host "`n🧪 Step 5: Testing endpoints..." -ForegroundColor Cyan

Write-Host "`n🏥 Testing health endpoint..." -ForegroundColor Cyan
try {
    $response = Invoke-WebRequest -Uri "http://localhost:8080/health" -Method GET
    Write-Host "✅ Health check successful: $($response.StatusCode)" -ForegroundColor Green
    Write-Host "Response: $($response.Content)" -ForegroundColor Gray
} catch {
    Write-Host "❌ Health check failed: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host "`n📝 Testing JSON endpoint..." -ForegroundColor Cyan
try {
    $testData = @{ test = "data" } | ConvertTo-Json
    $response = Invoke-RestMethod -Uri "http://localhost:8080/test-json" -Method POST -Body $testData -ContentType "application/json"
    Write-Host "✅ JSON test successful: $($response.message)" -ForegroundColor Green
} catch {
    Write-Host "❌ JSON test failed: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host "`n🚀 Testing API endpoint (should work without JWT in debug mode)..." -ForegroundColor Cyan
try {
    $workoutData = @{
        name = "test"
        dayOfWeek = "MONDAY"
        weeksCount = 1
        startDate = "2025-08-18"
    } | ConvertTo-Json
    $response = Invoke-RestMethod -Uri "http://localhost:8080/api/workouts" -Method POST -Body $workoutData -ContentType "application/json"
    Write-Host "✅ API test successful: $($response.name)" -ForegroundColor Green
} catch {
    Write-Host "❌ API test failed: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "🎉 Debug profile test completed!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Read-Host "Press Enter to continue..."
