# Deploy at Scale
## Approved promotions, release roles, and owned day-2

*SDLC Governance Playbook for Scale · Guide 05 — extends base `../05-deployment-and-day2.md`*

**Hat — Release Engineer / SRE:** ship small, reversible, scanned, validated (base rule), and at scale make promotion an *approved* step by someone who didn't write the change, with named on-call ownership after go-live.

---

## Principle

> **Every deploy stays small, reversible, scanned, validated, with a written rollback
> (base rules). At scale, promotion to production is an *authorized* action — performed or
> approved by someone other than the author — and day-2 operations have *named owners*, not
> "whoever notices."**

This is where coding's segregation of duties (guide 03) reaches its sharpest point:
**the person who wrote a change does not unilaterally release it to production.**

---

## Why it matters

**Likelihood: Every release.** Deploys remain the most frequent way a healthy system turns
unhealthy. At scale you add the failure mode of *uncontrolled* release: anyone pushing to
prod, no record of who authorized it, no one owning what happens next.

**Impact: Direct user harm plus the central SOX finding.** A bad deploy is downtime or
data corruption for real users (base impact). The scale-specific impact is audit-fatal:
"developers can deploy their own code to production without independent approval" is the
single most common SOX ITGC change-management exception there is.

---

## The rule(s)

1. **Promotion is authorized and recorded.** Production release requires a recorded
   authorization (`templates/change-authorization.md`) by a named approver who is **not the
   author** of the change. The base playbook's "deploy only on explicit instruction"
   becomes "deploy only on *recorded, independent* authorization."
2. **Release roles are named.** Who builds, who approves, who executes, who is on-call —
   named per release (or per rota), so accountability is never ambiguous after the fact.
3. **Reversible, multi-deploy steps (base rule, enforced).** Schema add-nullable →
   backfill → flip; API add → deprecate → remove; gold-masters preserved unless intended.
   Never one irreversible production-data mutation.
4. **Infra invariants abort the deploy (base rule).** Security-critical invariants
   (firewall closed, TLS required, no secrets baked) are checked *in the pipeline* and
   abort on violation — never weakened, in any environment, for anyone. At scale these run
   in shared CD, not one laptop's script.
5. **Every non-trivial release carries a `Rollback:` line and a watch list** — how to undo
   in under five minutes, and what to watch in logs/metrics for the first 24h. Both are
   recorded with the release.
6. **Day-2 is owned.** Incident severities + response procedure (base), plus a named
   on-call rota, alerting on the controls whose silent failure hurts most, and a monthly
   pass (deferred CVEs, rotations, infra invariants, restore drills — guides 09/10).
7. **Emergency releases follow the break-glass path (guide 07)** — never an excuse to skip
   approval, only to *reorder* it (act, then retroactively review within a fixed window).

---

## War story

*Composite — a pattern auditors see repeatedly at this stage.*

A startup let any engineer deploy to prod from their laptop — fast, and fine until the
SOC 2 audit. The auditor's first ITGC test: *show me, for ten changes, the independent
approval to release.* There was none — authors shipped their own work, no record existed.
Every change in the period became a control exception. The remediation wasn't more
process for its own sake: a CD pipeline where promotion required a recorded approval from
someone other than the author, release roles named, and emergency changes routed through a
break-glass path with retroactive review. Velocity barely moved; the audit passed.

---

## How to verify

- **Independent promotion:** a sampled production release shows a recorded approver ≠ author.
- **Invariant gate:** a deploy that would weaken a guarded invariant aborts in the pipeline.
- **Rollback present:** sampled non-trivial releases carry a `Rollback:` line + watch list.
- **On-call named:** the current rota and incident-severity matrix are written and current.
- **Break-glass used correctly:** any emergency release has a retroactive review on file
  within the window (guide 07).

---

## Adopt on a new project

- [ ] Require recorded, independent authorization for production promotion (no self-release).
- [ ] Name the release roles and the on-call rota; write the incident-severity matrix.
- [ ] Move infra-invariant checks into shared CD so they gate every release.
- [ ] Require a `Rollback:` line + 24h watch list on non-trivial releases.
- [ ] Define the break-glass path now (guide 07) — before the first emergency.

> Next guide: **06 — Segregation of Duties** (the assurance layer begins).
