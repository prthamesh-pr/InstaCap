# Start Flutter App
Write-Host "📱 Starting Flutter App..." -ForegroundColor Yellow

try {
    Set-Location "d:\Flutter\Insta\Frontend\insta_cap"
    
    # Get dependencies
    Write-Host "📦 Getting Flutter dependencies..." -ForegroundColor Cyan
    flutter pub get
    
    # Start the app
    Write-Host "🚀 Starting Flutter web app..." -ForegroundColor Green
    flutter run -d chrome --web-port 57707
} catch {
    Write-Host "❌ Failed to start Flutter app: $_" -ForegroundColor Red
    Write-Host "💡 Make sure Flutter is installed and you're in the correct directory" -ForegroundColor Yellow
}
