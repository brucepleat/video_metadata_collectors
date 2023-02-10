@Echo Off
If "%*" == "" (
Set _P=%CD%
) Else (
Set _P=%*
)
PowerShell %Utils%\TV_Fetch.ps1 "%_P%"
