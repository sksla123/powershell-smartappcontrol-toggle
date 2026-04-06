$scriptName = "Toggle_SAC.ps1"
$shortcutName = "Toggle Smart App Control.lnk"
$currentDir = $PSScriptRoot
$scriptPath = Join-Path $currentDir $scriptName
$shortcutPath = Join-Path $env:APPDATA "Microsoft\Windows\Start Menu\Programs\$shortcutName"

if (-not (Test-Path $scriptPath)) {
    Write-Host "[!] Error: $scriptName not found in $currentDir" -ForegroundColor Red
    Pause
    exit
}

$shell = New-Object -ComObject WScript.Shell
$shortcut = $shell.CreateShortcut($shortcutPath)
$shortcut.TargetPath = "powershell.exe"
$shortcut.Arguments = "-ExecutionPolicy Bypass -File `"$scriptPath`""
$shortcut.WorkingDirectory = $currentDir
$shortcut.Description = "Toggle Windows Smart App Control ON/OFF"

# imageres.dll의 79번 인덱스 (노란색 경고 방패) 적용
$shortcut.IconLocation = "C:\Windows\System32\imageres.dll, 79"

$shortcut.Save()

# 관리자 권한으로 실행 설정 (LNK 바이너리 수정)
$bytes = [System.IO.File]::ReadAllBytes($shortcutPath)
$bytes[0x15] = $bytes[0x15] -bor 0x20
[System.IO.File]::WriteAllBytes($shortcutPath, $bytes)

Write-Host "-----------------------------------------------" -ForegroundColor Cyan
Write-Host "Success: Shortcut created with Yellow Shield Icon." -ForegroundColor Green
Write-Host "-----------------------------------------------"
Pause