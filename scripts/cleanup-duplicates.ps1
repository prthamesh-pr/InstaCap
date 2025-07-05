#!/usr/bin/env powershell

# Script to clean up duplicate files in the InstaCap project
Write-Host "🧹 Cleaning up duplicate files..." -ForegroundColor Green

$basePath = "d:\Insta"

# Files to remove (duplicates/alternatives)
$filesToRemove = @(
    "$basePath\Frontend\insta_cap\pubspec_new.yaml",
    "$basePath\Frontend\insta_cap\pubspec_final.yaml",
    "$basePath\Frontend\insta_cap\lib\screens\splash_screen_new.dart",
    "$basePath\Frontend\insta_cap\lib\screens\settings\settings_screen_new.dart",
    "$basePath\Frontend\insta_cap\lib\screens\profile\profile_screen_new.dart",
    "$basePath\Frontend\insta_cap\lib\screens\onboarding\onboarding_screen_new.dart",
    "$basePath\Frontend\insta_cap\lib\screens\home\main_navigation_screen_new.dart",
    "$basePath\Frontend\insta_cap\lib\screens\home\home_screen_new.dart",
    "$basePath\Frontend\insta_cap\lib\screens\auth\login_screen_new.dart",
    "$basePath\Frontend\insta_cap\lib\screens\history\history_screen_enhanced.dart"
)

$removedCount = 0

foreach ($file in $filesToRemove) {
    if (Test-Path $file) {
        try {
            Remove-Item $file -Force
            Write-Host "❌ Removed: $file" -ForegroundColor Yellow
            $removedCount++
        } catch {
            Write-Host "❗ Failed to remove: $file - $($_.Exception.Message)" -ForegroundColor Red
        }
    } else {
        Write-Host "⚠️  File not found: $file" -ForegroundColor Gray
    }
}

Write-Host "`n✅ Cleanup complete! Removed $removedCount files." -ForegroundColor Green
Write-Host "📁 Your project now uses single, properly named files." -ForegroundColor Blue
