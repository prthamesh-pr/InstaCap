# PowerShell script to fix withOpacity deprecation warnings
# Replace .withOpacity(value) with .withValues(alpha: value)

$files = @(
    "lib\screens\history\history_screen.dart",
    "lib\screens\home\home_screen.dart", 
    "lib\screens\home\main_navigation_screen.dart",
    "lib\screens\settings\settings_screen.dart",
    "lib\screens\trending\trending_screen.dart"
)

foreach ($file in $files) {
    if (Test-Path $file) {
        Write-Host "Processing $file..."
        
        # Read the file content
        $content = Get-Content $file -Raw
        
        # Replace withOpacity patterns
        $content = $content -replace '\.withOpacity\(([0-9]*\.?[0-9]+)\)', '.withValues(alpha: $1)'
        
        # Write back to file
        Set-Content $file -Value $content -NoNewline
        
        Write-Host "Fixed $file"
    } else {
        Write-Host "File not found: $file"
    }
}

Write-Host "All withOpacity fixes completed!"
