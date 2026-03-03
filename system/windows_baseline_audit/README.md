# Windows Baseline Audit

[![PowerShell](https://img.shields.io/badge/Built%20With-PowerShell-5391FE?style=for-the-badge\&logo=powershell\&logoColor=white)](https://learn.microsoft.com/powershell/)
[![Platform](https://img.shields.io/badge/Platform-Windows-0078D6?style=for-the-badge\&logo=windows\&logoColor=white)](https://www.microsoft.com/windows)
[![License](https://img.shields.io/badge/License-Unlicense-lightgrey?style=for-the-badge)](#)
[![Status](https://img.shields.io/badge/Status-Production--Ready-success?style=for-the-badge)](#)

> Check a Windows machine for basic security weaknesses and generate a clear audit report.

---

## 1. Mission Brief

Windows systems often drift away from secure settings over time.

Goal: Scan the local machine and produce a readable report that shows security risks.

Success criteria:

* Script runs without errors
* Report is generated with timestamp
* High-risk findings are clearly visible

---

## 2. Context

* Target environment: Windows 10, Windows 11, Windows Server
* Assumptions:

  * Run as Administrator
  * PowerShell 5.1 or higher
* Constraints:

  * Local machine only
  * No external server
  * No database

---

## 3. System Topology

Layers:

* Interface Layer: PowerShell script (`audit.ps1`)
* Application Core: Audit modules inside `/modules`
* Persistence Layer: Text report saved in `/reports`
* External Integrations: Built-in Windows commands (services, firewall, users, logs)

Data Flow Summary:
User runs script → Modules collect data → Data is filtered → Results written to report → Report saved to disk

---

## 4. Design Rationale

* Why this stack?

  * PowerShell is built into Windows and requires no installation.

* Why this storage model?

  * Simple text files are easy to read and archive.

* Trade-offs accepted:

  * No graphical interface
  * No central dashboard
  * No real-time alerts

* Alternatives rejected:

  * Third-party security tools (overkill for baseline audit)
  * Complex databases (not needed for single-host audit)

---

## 5. Core Mechanisms

Mechanism A – User & Admin Check

* Trigger: Script execution
* Logic: List local users and admin group members
* Output: Table showing enabled accounts and privileged users

Mechanism B – Service & Port Check

* Trigger: Script execution
* Logic: Detect risky services and listening ports
* Output: Flagged services and exposed ports in report

Mechanism C – Security Posture Check

* Trigger: Script execution
* Logic: Verify firewall status, installed updates, and event logging
* Output: Summary of system security state

---

## 6. Data Contracts

Primary Entities:

User_Record

* name (string | required)
* enabled (boolean | required)
* role (standard/admin)

Service_Record

* name (string | required)
* status (running/stopped)
* start_type (auto/manual/disabled)

Integrity Rules:

* No system changes are made
* Read-only checks only
* Errors are written into report
* If access is denied, it is logged clearly

---

## 7. Execution Model

Runtime mode:

* Stateless
* Synchronous
* Single execution per run

Resource profile:

* CPU considerations: Low usage
* Memory considerations: Minimal
* I/O characteristics: Writes one report file per run

---

## 8. Execution

Local Execution:

```bash
powershell -ExecutionPolicy Bypass -File audit.ps1
```

Containerized:

```bash
# Not supported (runs directly on Windows)
```

---

## 9. Observability

* Logging strategy:

  * Structured sections in report
* Error classification:

  * Access denied
  * Missing component
  * Enumeration failure
* Monitoring hooks:

  * Can be scheduled with Windows Task Scheduler
* Audit capability:

  * Each run creates a timestamped report

---

## 10. Failure Surfaces

* Input abuse:

  * Running without admin rights
* Race conditions:

  * Service state changes during scan
* Data corruption vectors:

  * Interrupted file write
* Dependency failure:

  * Disabled PowerShell features

Mitigations:

* Validation layers:

  * Check admin privileges before scan
* Transaction controls:

  * Create report file before writing data

---

## 11. Validation Strategy

Testing tiers:

* Unit (test each module separately)
* Integration (full script execution)
* Edge-case (disabled services, empty admin group)
* Performance (measure execution time)

Example:

```bash
Invoke-Pester
```

Coverage target:
≥ 85%

---

## 12. Operational Limits

* Not optimized for:

  * Enterprise-wide scanning
* Not designed for:

  * Real-time monitoring
* Hard scalability ceiling:

  * One machine per execution


---

## Maintainer

Ayman Taylor

