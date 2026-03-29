param(
    [Parameter(Mandatory = $true)]
    [string]$UsbRoot,

    [Parameter(Mandatory = $true)]
    [string]$ModelFileName,

    [Parameter(Mandatory = $true)]
    [string]$LauncherName,

    [switch]$UseGpuOffload
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$resolvedUsbRoot = [System.IO.Path]::GetFullPath($UsbRoot)
$llamafilePath = Join-Path $resolvedUsbRoot "bin\llamafile.exe"
$modelPath = Join-Path $resolvedUsbRoot "models\$ModelFileName"
$launchersPath = Join-Path $resolvedUsbRoot "launchers"

if (-not (Test-Path $llamafilePath)) {
    throw "Missing llamafile executable: $llamafilePath"
}

if (-not (Test-Path $modelPath)) {
    throw "Missing model file: $modelPath"
}

if (-not (Test-Path $launchersPath)) {
    New-Item -ItemType Directory -Path $launchersPath | Out-Null
}

$gpuArg = ""
if ($UseGpuOffload) {
    $gpuArg = "-ngl 999 "
}

$launcherPath = Join-Path $launchersPath "$LauncherName.bat"
$batch = @"
@echo off
setlocal

set "ROOT=%~dp0.."
set "LLAMAFILE=%ROOT%\bin\llamafile.exe"
set "MODEL=%ROOT%\models\$ModelFileName"
set "LOG=%ROOT%\logs\$LauncherName.log"

if not exist "%LLAMAFILE%" (
  echo [ERROR] llamafile.exe not found at "%LLAMAFILE%"
  pause
  exit /b 1
)

if not exist "%MODEL%" (
  echo [ERROR] Model file not found at "%MODEL%"
  pause
  exit /b 1
)

echo Launching model: %MODEL%
echo Logging to: %LOG%
echo.
"%LLAMAFILE%" $gpuArg--server --model "%MODEL%" 1>>"%LOG%" 2>>&1
"@.Trim()

Set-Content -Path $launcherPath -Value $batch -Encoding ASCII

Write-Host "Created launcher: $launcherPath" -ForegroundColor Green
if ($UseGpuOffload) {
    Write-Host "GPU offload enabled with -ngl 999" -ForegroundColor Cyan
}
