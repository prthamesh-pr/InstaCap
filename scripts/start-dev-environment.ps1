# Start Complete Development Environment
Write-Host "🚀 Starting InstaCap Development Environment" -ForegroundColor Green
Write-Host "==========================================" -ForegroundColor Green

# Function to start a process in a new window
function Start-ProcessInNewWindow {
    param(
        [string]$FilePath,
        [string]$Arguments,
        [string]$WorkingDirectory,
        [string]$WindowTitle
    )
    
    $processArgs = @{
        FilePath = "powershell.exe"
        ArgumentList = @("-NoExit", "-Command", "& '$FilePath' $Arguments")
        WorkingDirectory = $WorkingDirectory
        WindowStyle = "Normal"
    }
    
    Start-Process @processArgs
    Write-Host "✅ Started $WindowTitle" -ForegroundColor Green
}

# Start Firebase Emulators
Write-Host "1. Starting Firebase Emulators..." -ForegroundColor Yellow
Start-ProcessInNewWindow -FilePath "d:\Flutter\Insta\scripts\start-firebase-emulators.ps1" -WorkingDirectory "d:\Flutter\Insta" -WindowTitle "Firebase Emulators"

# Wait a bit for emulators to start
Start-Sleep -Seconds 3

# Start Backend Server
Write-Host "2. Starting Backend Server..." -ForegroundColor Yellow
Start-ProcessInNewWindow -FilePath "d:\Flutter\Insta\scripts\start-backend.ps1" -WorkingDirectory "d:\Flutter\Insta\Backend" -WindowTitle "Backend Server"

# Wait a bit for backend to start
Start-Sleep -Seconds 2

# Start Flutter App
Write-Host "3. Starting Flutter App..." -ForegroundColor Yellow
Start-ProcessInNewWindow -FilePath "d:\Flutter\Insta\scripts\start-flutter.ps1" -WorkingDirectory "d:\Flutter\Insta\Frontend\insta_cap" -WindowTitle "Flutter App"

Write-Host ""
Write-Host "🎉 Development environment is starting up!" -ForegroundColor Green
Write-Host ""
Write-Host "📊 Services will be available at:" -ForegroundColor Cyan
Write-Host "   • Firebase Emulator UI: http://localhost:4000" -ForegroundColor White
Write-Host "   • Firebase Auth Emulator: http://localhost:9099" -ForegroundColor White
Write-Host "   • Firestore Emulator: http://localhost:8080" -ForegroundColor White
Write-Host "   • Storage Emulator: http://localhost:9199" -ForegroundColor White
Write-Host "   • Backend API: http://localhost:3000" -ForegroundColor White
Write-Host "   • Flutter Web App: http://localhost:57707" -ForegroundColor White
Write-Host ""
Write-Host "💡 Each service is running in its own terminal window" -ForegroundColor Yellow
Write-Host "💡 Close the terminal windows to stop the services" -ForegroundColor Yellow
