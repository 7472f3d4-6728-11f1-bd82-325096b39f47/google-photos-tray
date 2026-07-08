# install_startup.ps1 — Windows 起動時に Google フォトのトレイ常駐を自動起動する
# ショートカットを作成する。
#   実行:  powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\install_startup.ps1
#   解除:  上記に  -Uninstall  を付けて実行
param([switch]$Uninstall)

$ErrorActionPreference = "Stop"

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$vbs       = Join-Path $scriptDir "photos_tray_hidden.vbs"
$startup   = [Environment]::GetFolderPath("Startup")
$lnk       = Join-Path $startup "Google Photos Tray.lnk"

if ($Uninstall) {
    if (Test-Path -LiteralPath $lnk) { Remove-Item -LiteralPath $lnk -Force; Write-Host "removed: $lnk" }
    else { Write-Host "not installed (nothing to remove)." }
    return
}

if (-not (Test-Path -LiteralPath $vbs)) { throw "not found: $vbs" }

$wsh = New-Object -ComObject WScript.Shell
$sc  = $wsh.CreateShortcut($lnk)
$sc.TargetPath       = "$env:SystemRoot\System32\wscript.exe"
$sc.Arguments        = "`"$vbs`""
$sc.WorkingDirectory = $scriptDir
$sc.WindowStyle      = 7        # 最小化
$sc.Description      = "Google フォトをタスクトレイに常駐起動"
$sc.Save()

Write-Host "installed: $lnk"
Write-Host "→ 次回 PC 起動時から自動でトレイに常駐します。今すぐ試すには photos_tray_hidden.vbs を実行してください。"
