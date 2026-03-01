function Get-AutorunsAudit {
param($Output)

"`n=== AUTORUN ENTRIES ===" | Out-File $Output -Append

Get-CimInstance Win32_StartupCommand |
Select Name, Command, Location |
Format-Table | Out-File $Output -Append
}