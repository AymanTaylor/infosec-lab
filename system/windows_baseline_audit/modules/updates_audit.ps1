function Get-UpdatesAudit {
param($Output)

"`n=== PATCH STATUS ===" | Out-File $Output -Append

Get-HotFix |
Sort InstalledOn -Descending |
Select -First 10 HotFixID, InstalledOn |
Format-Table | Out-File $Output -Append
}