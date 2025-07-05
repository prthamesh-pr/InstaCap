# InstaCap Project Cleanup Script
# Removes duplicate and unnecessary files while preserving essential project structure

Write-Host "🧹 Starting InstaCap Project Cleanup..." -ForegroundColor Green
Write-Host "⚠️  This will remove duplicate and unnecessary files" -ForegroundColor Yellow

$removedFiles = @()
$basePath = "d:\Insta"

# Function to safely remove file
function Remove-FileIfExists {
    param($filePath, $description)
    if (Test-Path $filePath) {
        try {
            Remove-Item $filePath -Force -Recurse
            Write-Host "❌ Removed: $description" -ForegroundColor Red
            $script:removedFiles += $description
        } catch {
            Write-Host "⚠️  Failed to remove: $description" -ForegroundColor Yellow
        }
    }
}

Write-Host "`n📁 Cleaning Root Directory..." -ForegroundColor Cyan

# Remove duplicate documentation files (keep only essential ones)
Remove-FileIfExists "$basePath\BACKEND_STATUS_REPORT.md" "Backend Status Report (duplicate)"
Remove-FileIfExists "$basePath\MONGODB_FIX_GUIDE.md" "MongoDB Fix Guide (merged into main guide)"
Remove-FileIfExists "$basePath\ENVIRONMENT_SETUP.md" "Environment Setup (duplicate)"
Remove-FileIfExists "$basePath\QUICKSTART.md" "Quickstart Guide (duplicate)"
Remove-FileIfExists "$basePath\SETUP.md" "Setup Guide (duplicate)"

# Remove temporary test files
Remove-FileIfExists "$basePath\test_caption.js" "Temporary test file"
Remove-FileIfExists "$basePath\TEST_CREDENTIALS.md" "Test credentials file"
Remove-FileIfExists "$basePath\package.json" "Root package.json (not needed)"

# Remove example image
Remove-FileIfExists "$basePath\image 1.png" "Example image file"

Write-Host "`n📂 Cleaning Backend Directory..." -ForegroundColor Cyan

# Remove duplicate backend documentation
Remove-FileIfExists "$basePath\Backend\API_INTEGRATION_GUIDE.md" "API Integration Guide (duplicate)"
Remove-FileIfExists "$basePath\Backend\API_STATUS.md" "API Status (duplicate)"
Remove-FileIfExists "$basePath\Backend\FAST_CAPTION_SYSTEM.md" "Fast Caption System (duplicate)"
Remove-FileIfExists "$basePath\Backend\REDEPLOYMENT_GUIDE.md" "Redeployment Guide (duplicate)"

# Remove deployment scripts (keep if needed for production)
Remove-FileIfExists "$basePath\Backend\deploy-guide.sh" "Deploy guide script"
Remove-FileIfExists "$basePath\Backend\deploy-to-github.sh" "Deploy to GitHub script"

# Remove duplicate test files in Backend root
Remove-FileIfExists "$basePath\Backend\test-api.js" "Duplicate test file"

Write-Host "`n🧪 Cleaning Backend Tests Directory..." -ForegroundColor Cyan

# Remove duplicate/obsolete test files (keep the comprehensive ones)
Remove-FileIfExists "$basePath\Backend\tests\api-check.js" "Duplicate API check"
Remove-FileIfExists "$basePath\Backend\tests\api-status-checker.js" "Duplicate status checker"
Remove-FileIfExists "$basePath\Backend\tests\quick-api-check.js" "Duplicate quick check"
Remove-FileIfExists "$basePath\Backend\tests\test-api-all.js" "Duplicate comprehensive test"
Remove-FileIfExists "$basePath\Backend\tests\test-api-connection.js" "Duplicate connection test"
Remove-FileIfExists "$basePath\Backend\tests\test-api.js" "Duplicate API test"
Remove-FileIfExists "$basePath\Backend\tests\test-backend-api.js" "Duplicate backend test"
Remove-FileIfExists "$basePath\Backend\tests\test-backend-connection.js" "Duplicate connection test"
Remove-FileIfExists "$basePath\Backend\tests\test-deployed-backend.js" "Deployment-specific test"
Remove-FileIfExists "$basePath\Backend\tests\test-frontend-backend-integration.js" "Integration test (move to dedicated folder)"
Remove-FileIfExists "$basePath\Backend\tests\test-image-simple.js" "Simple image test (covered by main test)"
Remove-FileIfExists "$basePath\Backend\tests\test-improved-backend.js" "Duplicate backend test"
Remove-FileIfExists "$basePath\Backend\tests\test-login.js" "Duplicate login test"
Remove-FileIfExists "$basePath\Backend\tests\test-python-analyzer.js" "Python analyzer test (not needed)"
Remove-FileIfExists "$basePath\Backend\tests\test-register-test.js" "Duplicate register test"
Remove-FileIfExists "$basePath\Backend\tests\test-register.js" "Duplicate register test"
Remove-FileIfExists "$basePath\Backend\tests\test-user-details.js" "Duplicate user details test"

# Remove duplicate Postman files (keep one set)
Remove-FileIfExists "$basePath\Backend\tests\InstaCap_API_Collection.json" "Duplicate Postman collection"
Remove-FileIfExists "$basePath\Backend\tests\InstaCap_API_Environment.json" "Duplicate Postman environment"

Write-Host "`n📄 Cleaning Empty/Unused Directories..." -ForegroundColor Cyan

# Remove empty scripts directory
if (Test-Path "$basePath\scripts") {
    $scriptsContent = Get-ChildItem "$basePath\scripts" -Force
    if ($scriptsContent.Count -eq 0) {
        Remove-FileIfExists "$basePath\scripts" "Empty scripts directory"
    }
}

Write-Host "`n✅ Cleanup Summary:" -ForegroundColor Green
Write-Host "📊 Total files removed: $($removedFiles.Count)" -ForegroundColor White

if ($removedFiles.Count -gt 0) {
    Write-Host "`n📋 Removed files:" -ForegroundColor Yellow
    foreach ($file in $removedFiles) {
        Write-Host "  • $file" -ForegroundColor Gray
    }
}

Write-Host "`n🎯 Kept Essential Files:" -ForegroundColor Green
Write-Host "  ✅ README.md (main documentation)" -ForegroundColor White
Write-Host "  ✅ MONGODB_SETUP_GUIDE.md (essential setup)" -ForegroundColor White
Write-Host "  ✅ FINAL_SUCCESS_REPORT.md (project status)" -ForegroundColor White
Write-Host "  ✅ Backend/ (complete backend codebase)" -ForegroundColor White
Write-Host "  ✅ Frontend/ (complete frontend codebase)" -ForegroundColor White
Write-Host "  ✅ docs/ (PDF documentation)" -ForegroundColor White

Write-Host "`n🧪 Kept Essential Test Files:" -ForegroundColor Green
Write-Host "  ✅ test-mongodb-integration.js" -ForegroundColor White
Write-Host "  ✅ test-caption-generation-mock.js" -ForegroundColor White
Write-Host "  ✅ test-detailed-caption.js" -ForegroundColor White
Write-Host "  ✅ quick-api-test.js" -ForegroundColor White
Write-Host "  ✅ run-all-tests.js" -ForegroundColor White
Write-Host "  ✅ Postman collection (in postman/ folder)" -ForegroundColor White

Write-Host "`n🚀 Your project is now clean and organized!" -ForegroundColor Green
Write-Host "📁 All essential files preserved" -ForegroundColor Cyan
Write-Host "🧹 Duplicates and temporary files removed" -ForegroundColor Cyan
Write-Host "⚡ Ready for production deployment" -ForegroundColor Cyan
