param(
    [Parameter(Mandatory = $true)]
    [string]$UsbRoot
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$resolvedUsbRoot = [System.IO.Path]::GetFullPath($UsbRoot)

if (-not (Test-Path $resolvedUsbRoot)) {
    Write-Host "Creating USB root: $resolvedUsbRoot" -ForegroundColor Cyan
    New-Item -ItemType Directory -Path $resolvedUsbRoot | Out-Null
}

$folders = @(
    "bin",
    "models",
    "launchers",
    "logs",
    "scripts",
    "templates",
    "docs"
)

foreach ($folder in $folders) {
    $path = Join-Path $resolvedUsbRoot $folder
    if (-not (Test-Path $path)) {
        New-Item -ItemType Directory -Path $path | Out-Null
        Write-Host "Created: $path" -ForegroundColor Green
    } else {
        Write-Host "Exists : $path" -ForegroundColor DarkGray
    }
}

Write-Host "`nNext steps:" -ForegroundColor Cyan
Write-Host "1) Copy llamafile executable to: $(Join-Path $resolvedUsbRoot 'bin\llamafile.exe')"
Write-Host "2) Copy GGUF model files to:     $(Join-Path $resolvedUsbRoot 'models')"
Write-Host "3) Generate launcher .bat files with create-model-launcher.ps1"
Write-Host ""
