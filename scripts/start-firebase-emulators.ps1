# Start Firebase Emulators
Write-Host "🔥 Starting Firebase Emulators..." -ForegroundColor Yellow

# Check if Firebase CLI is installed
if (!(Get-Command firebase -ErrorAction SilentlyContinue)) {
    Write-Host "❌ Firebase CLI not found. Please install it first:" -ForegroundColor Red
    Write-Host "npm install -g firebase-tools" -ForegroundColor Cyan
    exit 1
}

# Start emulators
try {
    Set-Location "d:\Flutter\Insta"
    firebase emulators:start --only auth,firestore,storage
} catch {
    Write-Host "❌ Failed to start Firebase emulators: $_" -ForegroundColor Red
    Write-Host "💡 Make sure you're in the correct directory and Firebase is configured" -ForegroundColor Yellow
}
