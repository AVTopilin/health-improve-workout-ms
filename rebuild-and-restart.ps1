Write-Host "🔨 Rebuilding and restarting workout backend..." -ForegroundColor Yellow

Write-Host "⏹️ Stopping containers..." -ForegroundColor Cyan
docker-compose down

Write-Host "🏗️ Building application..." -ForegroundColor Green
mvn clean package -DskipTests

Write-Host "🐳 Building Docker image..." -ForegroundColor Green
docker-compose build --no-cache

Write-Host "▶️ Starting containers..." -ForegroundColor Green
docker-compose up -d

Write-Host "⏳ Waiting for services to be ready..." -ForegroundColor Yellow
Start-Sleep -Seconds 60

Write-Host "🧪 Testing health endpoint..." -ForegroundColor Cyan
try {
    $response = Invoke-WebRequest -Uri "http://localhost:8080/health" -Method GET
    Write-Host "✅ Health check successful: $($response.StatusCode)" -ForegroundColor Green
    Write-Host "Response: $($response.Content)" -ForegroundColor Gray
} catch {
    Write-Host "❌ Health check failed: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host "🧪 Testing JSON endpoint..." -ForegroundColor Cyan
try {
    $testData = @{ test = "data" } | ConvertTo-Json
    $response = Invoke-RestMethod -Uri "http://localhost:8080/test-json" -Method POST -Body $testData -ContentType "application/json"
    Write-Host "✅ JSON test successful: $($response.message)" -ForegroundColor Green
} catch {
    Write-Host "❌ JSON test failed: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host "🎉 Rebuild and restart completed!" -ForegroundColor Green
Read-Host "Press Enter to continue..."
