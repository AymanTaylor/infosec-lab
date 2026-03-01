function Get-NetworkAudit {
param($Output)

"`n=== NETWORK EXPOSURE ===" | Out-File $Output -Append

Get-NetTCPConnection -State Listen |
Where {$SuspiciousPorts -contains $_.LocalPort} |
Select LocalAddress, LocalPort, State |
Format-Table | Out-File $Output -Append
}