param(
    [Parameter(Mandatory=$true)]
    [ValidateSet("prod", "debug", "dev")]
    [string]$Profile
)

Write-Host "🔄 Switching Spring profile..." -ForegroundColor Yellow

switch ($Profile) {
    "prod" {
        Write-Host "🔒 Setting profile to PRODUCTION (with JWT auth)" -ForegroundColor Red
        $content = Get-Content docker-compose.yml -Raw
        $content = $content -replace 'SPRING_PROFILES_ACTIVE: .*', '      SPRING_PROFILES_ACTIVE: prod'
        Set-Content docker-compose.yml $content
        Write-Host "✅ Profile set to PRODUCTION" -ForegroundColor Green
    }
    "debug" {
        Write-Host "🐛 Setting profile to DEBUG (without JWT auth)" -ForegroundColor Yellow
        $content = Get-Content docker-compose.yml -Raw
        $content = $content -replace 'SPRING_PROFILES_ACTIVE: .*', '      SPRING_PROFILES_ACTIVE: debug'
        Set-Content docker-compose.yml $content
        Write-Host "✅ Profile set to DEBUG" -ForegroundColor Green
    }
    "dev" {
        Write-Host "🛠️ Setting profile to DEVELOPMENT (without JWT auth)" -ForegroundColor Cyan
        $content = Get-Content docker-compose.yml -Raw
        $content = $content -replace 'SPRING_PROFILES_ACTIVE: .*', '      SPRING_PROFILES_ACTIVE: dev'
        Set-Content docker-compose.yml $content
        Write-Host "✅ Profile set to DEVELOPMENT" -ForegroundColor Green
    }
}

Write-Host "`n📋 Current profile:" -ForegroundColor Cyan
Get-Content docker-compose.yml | Select-String "SPRING_PROFILES_ACTIVE"

Write-Host "`n⚠️ Remember to restart containers with:" -ForegroundColor Yellow
Write-Host "docker-compose down && docker-compose up -d" -ForegroundColor White

Read-Host "Press Enter to continue..."
