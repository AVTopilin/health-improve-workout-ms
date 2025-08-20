Write-Host "🔄 Quick restart of workout backend..." -ForegroundColor Yellow

Write-Host "⏹️ Stopping containers..." -ForegroundColor Cyan
docker-compose down

Write-Host "▶️ Starting containers..." -ForegroundColor Green
docker-compose up -d

Write-Host "⏳ Waiting for services to be ready..." -ForegroundColor Yellow
Start-Sleep -Seconds 30

Write-Host "🧪 Testing health endpoint..." -ForegroundColor Cyan
try {
    $response = Invoke-WebRequest -Uri "http://localhost:8080/health" -Method GET
    Write-Host "✅ Health check successful: $($response.StatusCode)" -ForegroundColor Green
    Write-Host "Response: $($response.Content)" -ForegroundColor Gray
} catch {
    Write-Host "❌ Health check failed: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host "🎉 Quick restart completed!" -ForegroundColor Green
Read-Host "Press Enter to continue..."
