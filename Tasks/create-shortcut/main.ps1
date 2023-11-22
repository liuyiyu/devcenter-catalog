param(
    [Parameter()]
    [string]$RootDirectory,
    [Parameter()]
    [string]$FileName,
    [Parameter()]
    [string]$Command
 )

function create_shortcut($RootDirectory,$FileName)
{
    $TargetFile="C:/Windows/System32/WindowsPowerShell/v1.0/powershell.exe"
    $ShortcutFile="C:/Users/Public/Desktop/$FileName.lnk"
    $WScriptObj=New-Object -ComObject ("WScript.Shell")
    $shortcut=$WscriptObj.CreateShortcut($ShortcutFile)
    $shortcut.WorkingDirectory="C:/Windows/System32/WindowsPowerShell/v1.0"
    $shortcut.TargetPath=$TargetFile
    $shortcut.Arguments=" -noexit -ExecutionPolicy Bypass -File $RootDirectory/$FileName.ps1"
    $shortcut.Save()
    $bytes=[System.IO.File]::ReadAllBytes($ShortcutFile);$bytes[0x15]=$bytes[0x15] -bor 0x20
    [System.IO.File]::WriteAllBytes($ShortcutFile, $bytes)
}

New-Item $RootDirectory -ItemType Directory -Force
Set-Content -Path "$RootDirectory/$FileName.ps1" -Value $($Command)
create_shortcut $RootDirectory $FileName