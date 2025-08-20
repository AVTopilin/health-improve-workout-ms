Write-Host "🧪 Testing JSON parsing endpoint..." -ForegroundColor Cyan

Write-Host "✅ Testing with valid JSON..." -ForegroundColor Green
$validJson = @{
    createdAt = "2025-08-18T23:10:23.01633"
    dayOfWeek = "MONDAY"
    name = "test1"
    startDate = "2025-08-18"
    updatedAt = "2025-08-18T23:10:23.016382"
    userId = 1
    weeksCount = 1
} | ConvertTo-Json

try {
    $response = Invoke-RestMethod -Uri "http://localhost:8080/test-json" -Method POST -Body $validJson -ContentType "application/json"
    Write-Host "✅ Valid JSON test successful: $($response.message)" -ForegroundColor Green
    Write-Host "Response: $($response | ConvertTo-Json)" -ForegroundColor Gray
} catch {
    Write-Host "❌ Valid JSON test failed: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host "`n❌ Testing with malformed JSON..." -ForegroundColor Yellow
$malformedJson = '{"createdAt":"2025-08-18T23:10:23.01633","dayOfWeek":"MONDAY","name":"test1","startDate":"2025-08-18","updatedAt":"2025-08-18T23:10:23.016382","userId":1,"weeksCount":1'

try {
    $response = Invoke-RestMethod -Uri "http://localhost:8080/test-json" -Method POST -Body $malformedJson -ContentType "application/json"
    Write-Host "✅ Malformed JSON test successful (unexpected): $($response.message)" -ForegroundColor Green
} catch {
    Write-Host "❌ Malformed JSON test failed (expected): $($_.Exception.Message)" -ForegroundColor Yellow
}

Write-Host "`n🏥 Testing health endpoint..." -ForegroundColor Cyan
try {
    $response = Invoke-WebRequest -Uri "http://localhost:8080/health" -Method GET
    Write-Host "✅ Health check successful: $($response.StatusCode)" -ForegroundColor Green
    Write-Host "Response: $($response.Content)" -ForegroundColor Gray
} catch {
    Write-Host "❌ Health check failed: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host "`n🎉 Testing completed!" -ForegroundColor Green
Read-Host "Press Enter to continue..."
