$path = "HKLM:\SYSTEM\CurrentControlSet\Control\CI\Policy"
$name = "VerifiedAndReputablePolicyState"

# 1. Administrator Rights Check and Elevation (Modified to close child window)
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Start-Process powershell.exe "-File `"$PSCommandPath`"" -Verb RunAs
    exit
}

try {
    # 2. Get current registry value
    $currentVal = (Get-ItemProperty -Path $path -ErrorAction Stop).$name
    
    if ($currentVal -eq 1) {
        $statusStr = "ON"
        $targetVal = 0
        $actionStr = "Do you want to turn it OFF?"
    } else {
        $statusStr = "OFF"
        $targetVal = 1
        $actionStr = "Do you want to turn it ON?"
    }

    # 3. User Confirmation Prompt
    Write-Host "-------------------------------------------" -ForegroundColor Cyan
    Write-Host "Current Smart App Control Status: $statusStr" -ForegroundColor Yellow
    Write-Host "-------------------------------------------"
    $input = Read-Host "$actionStr (Y/n)"

    # 4. Action only on Y/y (all other inputs treated as 'n')
    if ($input -eq "Y" -or $input -eq "y") {
        Set-ItemProperty -Path $path -Name $name -Value $targetVal
        Write-Host ""
        Write-Host "[!] Registry value changed ($currentVal -> $targetVal)." -ForegroundColor Green
        Write-Host "[!] A system restart may be required for changes to take effect." -ForegroundColor Red
    } else {
        Write-Host ""
        Write-Host "[-] Operation canceled." -ForegroundColor Gray
    }
} catch {
    Write-Host "[!] Error: Registry path not found or access denied." -ForegroundColor Red
}

# 5. Wait for key press before closing
Write-Host ""
Write-Host "Press any key to exit..." -ForegroundColor White
$null = [System.Console]::ReadKey($true)
exit