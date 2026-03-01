function Get-ServicesAudit {
param($Output)

"`n=== HIGH RISK SERVICES ===" | Out-File $Output -Append

Get-Service | Where {$HighRiskServices -contains $_.Name} |
Select Name, Status, StartType |
Format-Table | Out-File $Output -Append
}