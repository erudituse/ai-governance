# Resilience & Availability
## RTO/RPO, a tested DR plan, and alerts on what matters

*SDLC Governance Playbook for Scale · Guide 10 — assurance layer*

**Hat — SRE / Business-Continuity Owner:** define the recovery targets, write and *exercise* the DR plan, and alert on the controls whose silent failure hurts most.

---

## Principle

> **Availability is a *committed target* (RTO/RPO), backed by a *tested* recovery plan and
> monitoring that would actually page someone before users notice. A backup you have not
> restored is a hope; an alert you have not fired is a guess.**

The base playbook already insists on tested restore drills and "a 'done' you haven't
verified in production isn't done." This guide formalises that into the availability
program SOC 2 (A1) tests.

---

## Why it matters

**Likelihood: Eventual and certain.** Hardware fails, regions degrade, a deploy corrupts
data, a dependency goes down. The question is never *if* but *whether you recover in the
time you promised*.

**Impact: Outage, data loss, and a broken commitment.** Without a defined RPO you don't
know how much data a failure costs; without a defined RTO you can't tell users when you'll
be back; without a *tested* plan, the first real test is the disaster itself. For SOC 2
Availability these aren't nice-to-haves — they're the criteria.

---

## The rule(s)

1. **Define RTO and RPO per system.** RTO = how fast you must be back; RPO = how much data
   you can afford to lose. Written, owned, and derived from business need — not implied by
   whatever the infrastructure happens to do.
2. **Backups that meet the RPO, and are *tested by restore*.** Backup frequency satisfies
   the RPO; backups are stored resiliently (cross-region or equivalent to your risk
   appetite); a **restore drill on a cadence** proves they work and meet the RTO. A
   restore-drill artifact (date, result, time-to-restore) is retained.
3. **A written BCP/DR plan.** Roles, runbook, communication path, and the
   decision-to-failover criteria (`templates/bcp-dr-plan.md`). It is *exercised* — a
   tabletop or live drill on a cadence — not written once and shelved.
4. **Monitoring & alerting on what matters.** Alerts cover availability (uptime,
   error rate, latency) *and* the controls whose silent failure is worst (guide 05 infra
   invariants, backup success, certificate/secret expiry, the data-protection controls of
   guide 11). An alert no one receives is not monitoring.
5. **Capacity & dependency awareness.** Know your scaling limits and your critical
   external dependencies (and their failure modes); a subservice-org outage (guide 12) is
   part of *your* availability story to users.
6. **Residual risk is named and accepted.** Where a resilience gap is knowingly carried
   (e.g. a DR scenario out of scope for now), it is documented and *explicitly accepted* by
   an accountable owner — never silently held (base playbook's offsite-backup lesson).

---

## War story

*Composite — a pattern auditors see repeatedly at this stage.*

An "offsite backup" capability was marked done and forgotten. A routine resilience review
asked the unglamorous question — *has anyone confirmed the backup target exists and that we
can restore from it?* The destination had never been created; the backups, such as they
were, had never been restored. Status was honestly downgraded, the gap named, and the
residual risk accepted by an owner pending the real fix. The lesson generalised: a backup
isn't a backup until a restore drill proves it, and a recovery plan isn't a plan until a
drill exercises it.

---

## How to verify

- **Targets exist:** each system has a written, owned RTO and RPO.
- **Restore proven:** a dated restore-drill artifact within the cadence shows a successful
  restore meeting the RTO.
- **Plan exercised:** the BCP/DR plan has a recent drill/tabletop record.
- **Alerts fire:** a deliberately tripped critical condition (in a safe environment) pages
  the on-call; backup-failure and expiry alerts are wired.
- **Residual risk owned:** any carried resilience gap references an explicit accepted-risk
  entry with a named owner.

---

## Adopt on a new project

- [ ] Define RTO/RPO per system, owned and derived from business need.
- [ ] Set backup frequency to meet RPO; schedule restore drills; retain the artifacts.
- [ ] Write `templates/bcp-dr-plan.md`; schedule a drill/tabletop cadence.
- [ ] Wire availability + control-failure + expiry alerts to an on-call that receives them.
- [ ] Record and have an owner accept any carried resilience residual risk.

> Next guide: **11 — Data Lifecycle & Crypto.**
