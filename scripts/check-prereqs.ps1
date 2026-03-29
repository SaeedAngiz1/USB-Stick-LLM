param(
    [Parameter(Mandatory = $true)]
    [string]$UsbRoot
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

function Write-Check {
    param(
        [string]$Label,
        [bool]$Ok,
        [string]$Details
    )

    if ($Ok) {
        Write-Host "[OK]   $Label - $Details" -ForegroundColor Green
    } else {
        Write-Host "[WARN] $Label - $Details" -ForegroundColor Yellow
    }
}

Write-Host "`nUSB LLM Prerequisite Check`n" -ForegroundColor Cyan

$resolvedUsbRoot = [System.IO.Path]::GetFullPath($UsbRoot)
Write-Host "Target path: $resolvedUsbRoot"

$drive = (Get-Item $resolvedUsbRoot).PSDrive
if (-not $drive) {
    throw "Could not resolve drive for path: $resolvedUsbRoot"
}

$driveLetter = $drive.Name
$volume = Get-Volume -DriveLetter $driveLetter
$os = Get-CimInstance Win32_OperatingSystem
$memoryGb = [math]::Round((Get-CimInstance Win32_ComputerSystem).TotalPhysicalMemory / 1GB, 2)
$freeGb = [math]::Round($drive.Free / 1GB, 2)

Write-Check -Label "Windows Version" -Ok ($os.Caption -match "Windows") -Details $os.Caption
Write-Check -Label "Physical RAM" -Ok ($memoryGb -ge 16) -Details "$memoryGb GB (16+ recommended)"
Write-Check -Label "USB Filesystem" -Ok ($volume.FileSystem -eq "exFAT") -Details "$($volume.FileSystem) (exFAT recommended)"
Write-Check -Label "Free Space" -Ok ($freeGb -ge 20) -Details "$freeGb GB free (20+ GB recommended)"

Write-Host "`nModel guidance:" -ForegroundColor Cyan
Write-Host "- Dense models: <= 14B is a practical baseline for many systems."
Write-Host "- Quantized GGUF (Q4/Q5) usually gives better speed-memory tradeoffs."

Write-Host "`nCheck complete.`n" -ForegroundColor Cyan
