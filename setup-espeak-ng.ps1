# espeak-ng Download and Setup Script for Ostrea App
# This script downloads espeak-ng binaries for Android and sets them up in the project

$projectRoot = Get-Location
$jniLibsPath = "$projectRoot\android\app\src\main\jniLibs"
$assetsPath = "$projectRoot\android\app\src\main\assets"

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "espeak-ng Android Setup" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Create directories
New-Item -ItemType Directory -Path "$jniLibsPath\arm64-v8a" -Force | Out-Null
New-Item -ItemType Directory -Path "$jniLibsPath\armeabi-v7a" -Force | Out-Null
New-Item -ItemType Directory -Path "$assetsPath\espeak-ng" -Force | Out-Null

Write-Host "Step 1: Downloading espeak-ng binaries..." -ForegroundColor Yellow
Write-Host ""

# Note: Replace these URLs with actual espeak-ng releases when available
$binaries = @(
    @{
        arch = "arm64-v8a"
        filename = "libespeak-ng.so"
        url = "https://github.com/espeak-ng/espeak-ng/releases/download/1.51/libespeak-ng-arm64-v8a.so"
    },
    @{
        arch = "armeabi-v7a"
        filename = "libespeak-ng.so"
        url = "https://github.com/espeak-ng/espeak-ng/releases/download/1.51/libespeak-ng-armeabi-v7a.so"
    }
)

foreach ($binary in $binaries) {
    $outputPath = "$jniLibsPath\$($binary.arch)\$($binary.filename)"
    
    if (Test-Path $outputPath) {
        Write-Host "✓ Already exists: $($binary.arch)/$($binary.filename)" -ForegroundColor Green
    } else {
        Write-Host "Downloading: $($binary.arch)/$($binary.filename)"
        Write-Host "  URL: $($binary.url)"
        
        try {
            # Create the directory if it doesn't exist
            $dir = "$jniLibsPath\$($binary.arch)"
            New-Item -ItemType Directory -Path $dir -Force | Out-Null
            
            # Download the file
            Invoke-WebRequest -Uri $binary.url -OutFile $outputPath -UseBasicParsing
            Write-Host "  ✓ Downloaded" -ForegroundColor Green
        } catch {
            Write-Host "  ✗ Failed to download" -ForegroundColor Red
            Write-Host "  Error: $_" -ForegroundColor Red
            Write-Host "  Please download manually from: $($binary.url)" -ForegroundColor Yellow
        }
    }
}

Write-Host ""
Write-Host "Step 2: Setting up language data..." -ForegroundColor Yellow
Write-Host ""

# Create placeholder for language data
$languageDataPath = "$assetsPath\espeak-ng\data"
New-Item -ItemType Directory -Path $languageDataPath -Force | Out-Null

Write-Host "Language data directory created at: $languageDataPath" -ForegroundColor Green
Write-Host "  Add espeak-ng voice files here if not using system voices"

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Setup Summary" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Binaries location:"
Write-Host "  - $jniLibsPath" -ForegroundColor Cyan
Write-Host ""
Write-Host "Assets location:"
Write-Host "  - $assetsPath\espeak-ng" -ForegroundColor Cyan
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Yellow
Write-Host "1. Verify binaries are in: android/app/src/main/jniLibs/{arm64-v8a,armeabi-v7a}/" -ForegroundColor White
Write-Host "2. Run: flutter build apk --debug" -ForegroundColor White
Write-Host "3. Install and test on Android device" -ForegroundColor White
Write-Host ""

# Check if binaries exist
$binariesExist = (Test-Path "$jniLibsPath\arm64-v8a\libespeak-ng.so") -or (Test-Path "$jniLibsPath\armeabi-v7a\libespeak-ng.so")

if ($binariesExist) {
    Write-Host "Ready to build! Run: flutter build apk --debug" -ForegroundColor Green
} else {
    Write-Host "WARNING: No espeak-ng binaries found!" -ForegroundColor Red
    Write-Host "Please download them manually and place in jniLibs/" -ForegroundColor Yellow
}
