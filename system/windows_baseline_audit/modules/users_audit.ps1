function Get-UsersAudit {
param($Output)

"`n=== USERS & PRIVILEGE AUDIT ===" | Out-File $Output -Append

Get-LocalUser |
Select Name, Enabled, PasswordRequired, LastLogon |
Format-Table | Out-File $Output -Append

"Admins:" | Out-File $Output -Append

Get-LocalGroupMember Administrators |
Select Name, ObjectClass |
Format-Table | Out-File $Output -Append
}