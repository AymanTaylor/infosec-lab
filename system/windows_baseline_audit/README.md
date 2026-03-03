# Project Codename: Sentinel Baseline

> Enforce and verify Windows host security baseline integrity through deterministic configuration auditing.

---

## 00. Mission Brief

The problem: Windows endpoints drift from secure baseline configurations over time due to updates, user privilege changes, service modifications, and persistence mechanisms.

Intended outcome: Produce a structured audit report that identifies misconfigurations, privilege escalation exposure, insecure services, logging weaknesses, and network exposure.

Success criteria:

* Deterministic audit execution without runtime errors
* Clear identification of high-risk deviations
* Timestamped, reproducible reports

---

## 01. Operational Context

* Domain: Blue Team / Endpoint Security / Baseline Enforcement
* Target environment: Windows 10/11, Windows Server (PowerShell 5.1+)
* Assumptions:

  * Script executed with administrative privileges
  * Host is domain-joined or standalone enterprise endpoint
* Constraints:

  * No external agents installed
  * No persistent service deployment
  * Local execution only

---

## 02. System Topology

Layers:

* Interface Layer: PowerShell CLI execution (`audit.ps1`)
* Application Core: Modular audit functions under `/modules`
* Persistence Layer: Flat-file report generation in `/reports`
* External Integrations: Native Windows APIs (CIM, WinRM, NetSecurity, EventLog)

Data Flow Summary:
Input → Configuration parameters → Module invocation → Validation & filtering → Report serialization → File output

---

## 03. Design Rationale

* Why this stack?

  * Native PowerShell ensures zero external dependencies and maximum compatibility with enterprise Windows environments.

* Why this data model?

  * Flat structured text output prioritizes portability and forensic preservation over database complexity.

* Trade-offs accepted:

  * No centralized aggregation
  * No real-time monitoring
  * Limited historical diff capability

* Alternatives rejected:

  * Agent-based EDR-style collectors (overhead not required)
  * GUI-based auditing tools (non-automatable)

---

## 04. Core Mechanisms

Mechanism A – Privilege & Account Surface Audit

* Trigger: Execution of `Get-UsersAudit`
* Logic: Enumerate local users, admin group membership, password policies
* Output: Structured table highlighting enabled accounts and privileged identities

Mechanism B – Persistence & Exposure Detection

* Trigger: Execution of autorun, services, and network modules
* Logic: Identify startup commands, high-risk services, listening suspicious ports
* Output: Flagged entries within report for manual review

Mechanism C – Security Posture Validation

* Trigger: Firewall, patch, and logging module execution
* Logic: Validate firewall enablement, recent hotfix presence, Security log configuration
* Output: Compliance snapshot of defensive posture

---

## 05. Data Contracts

Primary Entities:

Audit_Report

* timestamp (datetime | required)
* host_identifier (string | required)
* section_blocks (array | non-null)

User_Record

* name (string | required)
* enabled (bool | required)
* privilege_level (enum | standard/admin)

Service_Record

* name (string | required)
* status (enum | running/stopped)
* start_type (enum | auto/manual/disabled)

Integrity Rules:

* No destructive operations performed
* Read-only enumeration only
* Invalid or inaccessible objects logged, not ignored
* Edge-case handling:

  * Missing modules fail gracefully
  * Access-denied conditions appended to report

---

## 06. Execution Model

Runtime mode:

* Stateless
* Synchronous
* Request-response (single execution lifecycle)

Resource profile:

* CPU considerations: Minimal, primarily enumeration calls
* Memory considerations: Low footprint, no large in-memory datasets
* I/O characteristics: Moderate disk write for report generation

---

## 07. Deployment Blueprint

Local Execution:

```bash
powershell -ExecutionPolicy Bypass -File audit.ps1
```

Containerized:

```bash
# Not applicable (native Windows execution required)
```

Production Assumptions:

* Reverse proxy: Not required
* TLS termination: Not applicable
* Environment isolation: Execution on secured administrative workstation

---

## 08. Observability

* Logging strategy:

  * Structured text sections per audit domain
* Error classification:

  * Access errors
  * Enumeration failures
  * Missing components
* Monitoring hooks:

  * Can be scheduled via Task Scheduler
* Audit capability:

  * Timestamped reports allow longitudinal comparison

---

## 09. Failure Surfaces

* Input abuse:

  * Execution without admin rights
* Race conditions:

  * Service state changes during enumeration
* Data corruption vectors:

  * Interrupted file write
* Dependency failure:

  * Missing PowerShell modules

Mitigations:

* Validation layers:

  * Privilege check before execution
* Transaction controls:

  * Atomic report file creation
* Defensive error handling:

  * Try/Catch wrapping around modules

---

## 10. Validation Strategy

Testing tiers:

* Unit (module-level function validation)
* Integration (full audit execution)
* Adversarial / edge-case (disabled services, corrupted accounts)
* Performance (execution time under load)

Example:

```bash
Invoke-Pester
```

Coverage target:
≥ 85% functional path coverage

---

## 11. Operational Limits

* Not optimized for:

  * Real-time monitoring
* Not designed for:

  * Enterprise-wide aggregation
* Hard scalability ceiling:

  * Single-host execution per run

---

## 12. Evolution Path

Phase I: Baseline validation and structured reporting
Phase II: JSON export and centralized ingestion compatibility
Phase III: Policy-as-code compliance engine with rule scoring

---

## 13. Status Classification

* Production-ready (local auditing scope)

---

## 14. Maintainer

Ayman Asaad Taylor
Security Engineering Student
(Private)
