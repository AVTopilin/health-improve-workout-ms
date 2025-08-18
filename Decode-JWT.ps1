# JWT Token Decoder for Workout Backend
# This script helps decode JWT tokens to verify issuer and other claims

param(
    [string]$Token,
    [string]$TokenFile
)

function Decode-JWT {
    param([string]$JWTToken)
    
    try {
        # Split the JWT token into parts
        $parts = $JWTToken.Split('.')
        
        if ($parts.Length -ne 3) {
            Write-Host "❌ Invalid JWT token format. Expected 3 parts, got $($parts.Length)" -ForegroundColor Red
            return
        }
        
        # Decode header
        $header = [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($parts[0]))
        $headerObj = $header | ConvertFrom-Json
        
        # Decode payload
        $payload = [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($parts[1]))
        $payloadObj = $payload | ConvertFrom-Json
        
        # Display results
        Write-Host "🔐 JWT Token Decoded Successfully" -ForegroundColor Green
        Write-Host "=====================================" -ForegroundColor Cyan
        
        Write-Host "📋 Header:" -ForegroundColor Yellow
        $headerObj | ConvertTo-Json -Depth 10 | Write-Host -ForegroundColor White
        
        Write-Host "`n📄 Payload:" -ForegroundColor Yellow
        $payloadObj | ConvertTo-Json -Depth 10 | Write-Host -ForegroundColor White
        
        Write-Host "`n🔍 Key Claims:" -ForegroundColor Cyan
        Write-Host "   Issuer (iss): $($payloadObj.iss)" -ForegroundColor White
        Write-Host "   Audience (aud): $($payloadObj.aud)" -ForegroundColor White
        Write-Host "   Subject (sub): $($payloadObj.sub)" -ForegroundColor White
        Write-Host "   Expires (exp): $($payloadObj.exp)" -ForegroundColor White
        Write-Host "   Issued At (iat): $($payloadObj.iat)" -ForegroundColor White
        
        # Check issuer validity
        Write-Host "`n✅ Issuer Validation:" -ForegroundColor Cyan
        $expectedIssuer = "http://keycloak:8080/realms/workout-realm"
        if ($payloadObj.iss -eq $expectedIssuer) {
            Write-Host "   ✅ Issuer matches expected: $expectedIssuer" -ForegroundColor Green
        } else {
            Write-Host "   ❌ Issuer mismatch!" -ForegroundColor Red
            Write-Host "      Expected: $expectedIssuer" -ForegroundColor Red
            Write-Host "      Actual:   $($payloadObj.iss)" -ForegroundColor Red
            Write-Host "`n💡 Solution: Check Keycloak KC_HOSTNAME configuration" -ForegroundColor Yellow
        }
        
        # Check expiration
        if ($payloadObj.exp) {
            $expDate = [DateTimeOffset]::FromUnixTimeSeconds($payloadObj.exp).DateTime
            $now = [DateTime]::Now
            if ($expDate -gt $now) {
                Write-Host "   ✅ Token is valid until: $expDate" -ForegroundColor Green
            } else {
                Write-Host "   ❌ Token expired at: $expDate" -ForegroundColor Red
            }
        }
        
        # Check roles if present
        if ($payloadObj.realm_access -and $payloadObj.realm_access.roles) {
            Write-Host "`n👥 Roles:" -ForegroundColor Cyan
            $payloadObj.realm_access.roles | ForEach-Object {
                Write-Host "   - $_" -ForegroundColor White
            }
        }
        
    } catch {
        Write-Host "❌ Error decoding JWT token: $($_.Exception.Message)" -ForegroundColor Red
    }
}

# Main execution
Write-Host "🔐 JWT Token Decoder for Workout Backend" -ForegroundColor Green
Write-Host "=============================================" -ForegroundColor Cyan

if ($Token) {
    Write-Host "Decoding token from parameter..." -ForegroundColor Yellow
    Decode-JWT -JWTToken $Token
} elseif ($TokenFile -and (Test-Path $TokenFile)) {
    Write-Host "Reading token from file: $TokenFile" -ForegroundColor Yellow
    $tokenContent = Get-Content $TokenFile -Raw
    if ($tokenContent) {
        Decode-JWT -JWTToken $tokenContent.Trim()
    } else {
        Write-Host "❌ File is empty or could not be read" -ForegroundColor Red
    }
} else {
    Write-Host "Usage examples:" -ForegroundColor Yellow
    Write-Host "  .\Decode-JWT.ps1 -Token 'eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9...'" -ForegroundColor White
    Write-Host "  .\Decode-JWT.ps1 -TokenFile 'token.txt'" -ForegroundColor White
    Write-Host "`nOr run without parameters to decode a token from clipboard:" -ForegroundColor Yellow
    
    try {
        $clipboardToken = Get-Clipboard
        if ($clipboardToken -and $clipboardToken.Contains('.')) {
            Write-Host "`n📋 Found token in clipboard. Decoding..." -ForegroundColor Yellow
            Decode-JWT -JWTToken $clipboardToken
        } else {
            Write-Host "`n📋 No valid JWT token found in clipboard" -ForegroundColor Yellow
        }
    } catch {
        Write-Host "`n📋 Could not read clipboard" -ForegroundColor Yellow
    }
}
