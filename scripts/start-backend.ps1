# Start Backend Server
Write-Host "🚀 Starting Backend Server..." -ForegroundColor Yellow

try {
    Set-Location "d:\Flutter\Insta\Backend"
    
    # Check if node_modules exists
    if (!(Test-Path "node_modules")) {
        Write-Host "📦 Installing dependencies..." -ForegroundColor Cyan
        npm install
    }
    
    # Start the server
    Write-Host "🌐 Starting server on http://localhost:3000" -ForegroundColor Green
    npm start
} catch {
    Write-Host "❌ Failed to start backend server: $_" -ForegroundColor Red
    Write-Host "💡 Make sure Node.js is installed and you're in the correct directory" -ForegroundColor Yellow
}
