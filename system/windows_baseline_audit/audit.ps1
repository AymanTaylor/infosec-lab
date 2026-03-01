. ./config.ps1

$ReportPath = "./reports"
if (!(Test-Path $ReportPath)) {
    New-Item -ItemType Directory -Path $ReportPath | Out-Null
}

$ReportFile = "$ReportPath/audit_$(Get-Date -Format yyyyMMdd_HHmmss).txt"

"Windows Advanced Baseline Audit Report" | Out-File $ReportFile
"Generated: $(Get-Date)" | Out-File $ReportFile -Append
"----------------------------------" | Out-File $ReportFile -Append

Get-ChildItem ./modules/*.ps1 | ForEach-Object { . $_.FullName }

Get-SystemInfo -Output $ReportFile
Get-UsersAudit -Output $ReportFile
Get-FirewallAudit -Output $ReportFile
Get-ServicesAudit -Output $ReportFile
Get-UpdatesAudit -Output $ReportFile
Get-AutorunsAudit -Output $ReportFile
Get-LoggingAudit -Output $ReportFile
Get-NetworkAudit -Output $ReportFile

Write-Host "Audit Completed -> $ReportFile"