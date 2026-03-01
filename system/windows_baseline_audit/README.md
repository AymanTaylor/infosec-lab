# Windows Advanced Baseline Audit

Blue Team oriented Windows auditing toolkit.

## Checks
- Privileged Users
- Firewall posture
- Patch status
- Autorun persistence
- High risk services
- Security logging configuration
- Listening suspicious ports

## Usage

Run as Administrator:

` Set-ExecutionPolicy Bypass -Scope Process ./audit.ps1 `

Reports generated inside `/reports`.