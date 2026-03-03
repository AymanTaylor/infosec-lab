# Linux Baseline Audit

[![Bash](https://img.shields.io/badge/Built%20With-Bash-4EAA25?style=for-the-badge\&logo=gnu-bash\&logoColor=white)](https://www.gnu.org/software/bash/)
[![Platform](https://img.shields.io/badge/Platform-Linux-FCC624?style=for-the-badge\&logo=linux\&logoColor=white)](https://www.kernel.org/)
[![License](https://img.shields.io/badge/License-Unlicense-lightgrey?style=for-the-badge)](#)
[![Status](https://img.shields.io/badge/Status-Production--Ready-success?style=for-the-badge)](#)

> Check a Linux machine for baseline security weaknesses and generate a clear audit report.

---

## 1. Mission Brief

Linux systems often drift from secure configurations over time.

**Goal:** Scan the local system and produce a readable report highlighting security risks.

**Success criteria:**

* Script runs without errors
* Report is generated with timestamp
* Misconfigurations and high-risk issues are clearly visible

---

## 2. Context

* **Target environment:** Kali, Ubuntu, Debian, CentOS
* **Assumptions:**

  * Run as root or with sudo
  * Bash shell available
* **Constraints:**

  * Local machine only
  * No database
  * Read-only checks (no system changes)

---

## 3. System Topology

**Layers:**

* Interface Layer: Bash script (`audit.sh`)
* Audit Modules: `/checks` directory
* Persistence Layer: Text report saved in `/reports`
* External Integrations: Built-in Linux commands (users, SSH, firewall, services)

**Data Flow Summary:**
User runs script → Modules collect data → Data is filtered → Results written to report → Report saved to disk

---

## 4. Design Rationale

* **Stack choice:** Bash is installed on all Linux distributions by default
* **Storage model:** Simple text files for readability and archiving
* **Trade-offs:**

  * No GUI
  * No real-time monitoring
* **Alternatives rejected:**

  * Third-party tools (overkill for baseline audit)
  * Databases (not required for single-host checks)

---

## 5. Core Mechanisms

**Mechanism A – User & Privilege Check**

* Trigger: Script execution
* Logic: List local users, UID 0 accounts, shell types
* Output: Table of privileged and interactive accounts

**Mechanism B – SSH & Service Check**

* Trigger: Script execution
* Logic: Detect risky SSH configurations and listening services
* Output: Flagged entries in report

**Mechanism C – System Security Check**

* Trigger: Script execution
* Logic: Verify firewall, world-writable files, kernel security settings
* Output: Summary of system security posture

---

## 6. Data Contracts

**Primary Entities:**

`User_Record`

* name (string | required)
* uid (integer | required)
* shell (string)
* role (admin/standard)

`Service_Record`

* name (string | required)
* status (running/stopped)
* port (integer)

**Integrity Rules:**

* Read-only checks
* Errors logged in report
* Missing access clearly indicated

---

## 7. Execution Model

* Stateless
* Synchronous
* Single execution per run

**Resource profile:**

* CPU usage: Low
* Memory usage: Minimal
* I/O: Writes one report file per execution

---

## 8. Execution

**Local Execution:**

```bash
sudo ./audit.sh
```

**Containerized:**

```bash
# Can run inside Linux container with Bash
```

---

## 9. Observability

* **Logging:** Structured sections in report
* **Error classification:** Access denied, missing components, enumeration failures
* **Monitoring hooks:** Can be scheduled with cron
* **Audit capability:** Timestamped report per execution

---

## 10. Failure Surfaces

* **Input abuse:** Running without root/sudo
* **Race conditions:** Service changes during scan
* **Data corruption:** Interrupted file write
* **Dependency failure:** Missing core Linux commands

**Mitigations:**

* Check root/sudo privileges before running
* Pre-create report file before writing data

---

## 11. Validation Strategy

**Testing tiers:**

* Unit: Each check module separately
* Integration: Full audit script execution
* Edge-case: Disabled services, empty admin groups
* Performance: Measure execution time

Example:

```bash
bash checks/users.sh
```

Coverage target: ≥ 85%

---

## 12. Operational Limits

* Not optimized for multi-host enterprise scanning
* No real-time monitoring
* Designed for single-machine auditing

---

## Maintainer

Ayman Taylor
