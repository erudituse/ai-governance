# BCP / DR plan template — recover in the time you promised

Copy this per system (or per product). It is the evidence that resilience (guide 10) is a
*tested plan*, not a hope: defined RTO/RPO, a recovery runbook, and a record that you have
**exercised** it. SOC 2 Availability (A1) samples this; ISO A.5.29–A.5.30 require it.

A plan written once and shelved is not a plan — schedule the drill.

---

## The skeleton

```markdown
---
system: <system / product>
owner: <business-continuity owner>
last-updated: YYYY-MM-DD
last-exercised: YYYY-MM-DD     # a drill/tabletop date — not just authored
---

# BCP/DR plan: <system>

## Recovery targets
- RTO (max acceptable downtime): <e.g. 4h>      # how fast back
- RPO (max acceptable data loss): <e.g. 1h>     # how much data you can lose
- Derivation: <the business need these come from — not "whatever infra does">

## Backups (must meet RPO)
- What is backed up: <data stores / config / secrets references>
- Frequency: <meets RPO?>   Storage/resilience: <cross-region / etc.>
- Restore procedure: <step-by-step, runnable by on-call>
- Last restore drill: YYYY-MM-DD — time-to-restore: <...> — result: pass/fail

## Failure scenarios & response
| Scenario | Detection (alert) | Response runbook | Owner |
|---|---|---|---|
| Region/infra outage | <alert> | <failover steps> | <name> |
| Data corruption from deploy | <alert> | <restore-to-point steps> | <name> |
| Critical dependency / subservice-org down | <alert> | <degrade/queue steps> | <name> |
| Secret / certificate expiry | <expiry alert> | <rotation steps> | <name> |

## Decision to failover
- Who decides: <role>   Criteria: <thresholds that trigger failover>
- Communication path: <status page / users / stakeholders>

## Dependencies & capacity
- Critical external dependencies: <list + their failure mode in your story>
- Known scaling limits: <...>

## Residual risk (named + accepted — guide 10)
- <gap> — accepted by <owner> on YYYY-MM-DD — revisit: YYYY-MM-DD
```

---

## Accuracy contract

- RTO/RPO are **written and owned**; `last-exercised` is a real drill date, not the authoring date.
- The restore procedure has actually been run (a drill artifact exists with a time-to-restore).
- Alerts referenced in the scenario table are wired and received by on-call (guide 10).
- Any carried gap is an explicit accepted-risk entry with an owner — never silent.
