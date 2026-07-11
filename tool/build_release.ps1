param([string]$Flutter = "$env:LOCALAPPDATA\Codex\tools\flutter\bin\flutter.bat")
$ErrorActionPreference = 'Stop'
$date = Get-Date -Format 'yyyy-MM-dd'
& $Flutter pub get
& $Flutter analyze
& $Flutter test
& $Flutter build apk --release --target-platform android-arm64 --dart-define="BUILD_DATE=$date" --no-tree-shake-icons
New-Item -ItemType Directory -Force releases | Out-Null
Copy-Item build\app\outputs\flutter-apk\app-release.apk "releases\Aprender IA 1.9 Beta ARM64.apk" -Force
Write-Host 'APK lista: releases\Aprender IA 1.9 Beta ARM64.apk'
