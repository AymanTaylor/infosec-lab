function Get-SystemInfo {
param($Output)
"`n=== SYSTEM INFO ===" | Out-File $Output -Append

Get-ComputerInfo |
Select WindowsProductName, WindowsVersion, CsDomain, CsManufacturer |
Format-List | Out-File $Output -Append
}