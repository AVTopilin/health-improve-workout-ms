# PowerShell script to get JWT token from Keycloak
# Usage: powershell -ExecutionPolicy Bypass -File Get-JWTToken.ps1

function Get-JWTToken {
    try {
        Write-Host "Getting JWT token from Keycloak..." -ForegroundColor Cyan
        
        # Prepare request body as form data (not JSON)
        $body = @{
            grant_type = 'password'
            client_id = 'workout-client'
            username = 'testuser'
            password = 'test123'
        }
        
        Write-Host "Request parameters:" -ForegroundColor Gray
        $body | Format-Table -AutoSize
        
        # Make request to Keycloak with form data
        $response = Invoke-RestMethod -Uri 'http://localhost:8081/realms/workout-realm/protocol/openid-connect/token' -Method POST -Body $body -ContentType 'application/x-www-form-urlencoded'
        
        Write-Host "✅ Token received successfully!" -ForegroundColor Green
        Write-Host ""
        Write-Host "Access Token:" -ForegroundColor Yellow
        Write-Host $response.access_token -ForegroundColor White
        Write-Host ""
        Write-Host "Token Type:" -ForegroundColor Yellow
        Write-Host $response.token_type -ForegroundColor White
        Write-Host ""
        Write-Host "Expires In:" -ForegroundColor Yellow
        Write-Host $response.expires_in -ForegroundColor White
        Write-Host ""
        Write-Host "Now you can use token in Authorization header:" -ForegroundColor Cyan
        Write-Host "Authorization: Bearer $($response.access_token)" -ForegroundColor White
        Write-Host ""
        Write-Host "Test command:" -ForegroundColor Green
        Write-Host "curl -H 'Authorization: Bearer $($response.access_token)' http://localhost:8080/api/workouts" -ForegroundColor Gray
        
    } catch {
        Write-Host "❌ Token retrieval failed:" -ForegroundColor Red
        Write-Host $_.Exception.Message -ForegroundColor Red
        Write-Host ""
        Write-Host "Possible reasons:" -ForegroundColor Yellow
        Write-Host "1. User 'testuser' not created in Keycloak" -ForegroundColor White
        Write-Host "2. Client 'workout-client' not created" -ForegroundColor White
        Write-Host "3. Realm 'workout-realm' not created" -ForegroundColor White
        Write-Host ""
        Write-Host "Create required resources in Keycloak Admin Console:" -ForegroundColor Cyan
        Write-Host "http://localhost:8081" -ForegroundColor White
        Write-Host ""
        Write-Host "Setup steps:" -ForegroundColor Yellow
        Write-Host "1. Login as admin/admin" -ForegroundColor White
        Write-Host "2. Create realm 'workout-realm'" -ForegroundColor White
        Write-Host "3. Create client 'workout-client' (confidential)" -ForegroundColor White
        Write-Host "4. Create user 'testuser' with password 'test123'" -ForegroundColor White
    }
}

# Execute the function
Get-JWTToken
