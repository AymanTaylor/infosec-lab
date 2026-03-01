function Get-FirewallAudit {
param($Output)

"`n=== FIREWALL ===" | Out-File $Output -Append

Get-NetFirewallProfile |
Select Name, Enabled, DefaultInboundAction |
Format-Table | Out-File $Output -Append
}