# Deployment & Day-2 Ops
## Shipping a fix should never be the source of an outage

*SDLC Governance Playbook · Guide 05*

**Hat — Release Engineer / SRE:** promote in small reversible steps through gated stages, and own what happens after go-live.

---

## Principle

> **Every deploy is small, reversible, scanned, and validated against live state — with
> a written rollback — and the system stays healthy *after* launch, not just at it.**

Deployment and day-2 operations are one continuum: how you ship, and how you keep it
running once shipped.

---

## Why it matters

**Likelihood: Every release.** Deploys are the most frequent way a healthy system
becomes an unhealthy one. The risk is not rare events; it's the routine ones done
without guardrails.

**Impact: Direct user harm.** A bad deploy is downtime or data corruption for real
people. A non-reversible schema migration can be unrecoverable. A weakened infra
invariant (say, a database firewall opened "just for testing") can be a breach. And a
backup nobody has *restored* is not a backup — it's a hope.

---

## The rule(s)

1. **A defined promotion pipeline.** Local gates → staging → a scan checkpoint → prod.
   Gating lives where you control it (locally), not bolted onto a third party.
2. **Reversible, multi-deploy steps.** Schema: add-nullable → backfill → flip
   NOT-NULL across deploys. API: add → deprecate → remove. Calculations: preserve gold-masters
   unless intended. Never one migration that mutates production data irreversibly.
3. **Validate deploy-script edits against live state.** Full-replace flags (e.g.
   `--set-env-vars`) make a silent omission a real outage — confirm current live values
   before editing, and explain the diff.
4. **Scan gates that block promotion.** Dependency audits and container scans pass
   before ship; runtime deps install hash-pinned.
5. **A `Rollback:` line on every non-trivial change.** Answer "how do I undo this in
   under five minutes?" *before* merge.
6. **Enforce infra invariants in the script itself.** The security-critical ones (e.g.
   a database's firewall staying closed, TLS required) abort the deploy if violated —
   and are *never* weakened, in any environment, for any reason.
7. **Day-2: classify, watch, drill.** Incidents have pre-agreed severities and a
   response procedure; alerts cover the controls whose silent failure hurts most;
   backups are tested by an actual restore drill; a monthly pass re-checks deferred
   CVEs, rotations, and infra invariants.

---

## War story

*Drawn from a production application built on this model.*

An offsite-backup capability was marked **done**. Months later, a routine day-2 review
asked the unglamorous question — *"has anyone actually confirmed the backup target
exists?"* It did not. The separate destination had never been created. The status was
honestly downgraded from *shipped* to *partially-shipped*, and the residual risk was
named and explicitly accepted rather than silently carried.

Two lessons, both day-2: a "done" you haven't *verified in production* isn't done; and
a backup you haven't *restored* isn't a backup. The discipline that caught it was a
standing re-audit habit, not luck.

---

## How to verify

- **Invariant gate:** attempt a deploy that would weaken a guarded invariant → the
  deploy script aborts.
- **Env-edit provenance:** an env-var change commit cites the live value it replaces.
- **Artifact hygiene:** the deploy diff contains no secrets and no source maps.
- **Restore drill:** a dated restore-drill artifact exists; residual risks reference an
  explicit accepted-risk entry.
- **Trigger honoured:** a change in a re-audit trigger class has a matching audit-doc
  update in the same change set.

---

## Adopt on a new project

- [ ] Write the promotion pipeline down; keep gating where you control it.
- [ ] Adopt multi-deploy schema/API patterns from the first migration.
- [ ] Require a `Rollback:` line on non-trivial commits.
- [ ] Encode security-critical infra invariants as deploy-aborting checks — never as docs alone.
- [ ] Define incident severities, alerts on the controls that matter, and a restore-drill cadence *before* go-live.

> Next guide: **06 — Security, Privacy & Compliance.**
