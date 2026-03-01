function Get-LoggingAudit {
param($Output)

"`n=== EVENT LOG SETTINGS ===" | Out-File $Output -Append

Get-WinEvent -ListLog Security |
Select LogName, MaximumSizeInBytes, IsEnabled |
Format-List | Out-File $Output -Append
}