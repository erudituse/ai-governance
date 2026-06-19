# Change Management
## Authorized, evidenced, enforced — and a break-glass path for emergencies

*SDLC Governance Playbook for Scale · Guide 07 — assurance layer*

**Hat — Change Manager / Release Engineer:** make every production change traceable to a recorded authorization, gate it with controls that *cannot be silently bypassed*, and run a real emergency path.

---

## Principle

> **Every production change is authorized before it ships, evidenced by a retained record,
> and gated by controls that *operated* — not controls that *could* be skipped. Emergencies
> reorder the steps (act, then review within a fixed window); they never delete them.**

This guide is where the base playbook's biggest scale-tension resolves: the base keeps
gates *local, opt-in, and bypassable* (right for a solo project). At an audit tier, a
bypassable gate is — to an auditor — **no control at all**. Here, gates become enforced
and evidence-retaining.

---

## Why it matters

**Likelihood: Continuous and sampled.** Change is the highest-volume audited activity; an
auditor pulls a sample across the whole period and tests each one. A control that ran on
*most* changes still fails on the one the sample lands on.

**Impact: The control evaporates exactly when claimed.** `--no-verify` exists; a local
hook one person installs is one person's habit, not a control; git history can be rewritten.
"We have a pre-commit gate" is worthless as evidence if it is optional, local, and leaves
no retained artifact. The gap is not the missing rule — it is the *missing proof the rule
ran*.

---

## The rule(s)

1. **Authorization before change.** Every production change traces to an authorized story
   (guide 01) and a recorded release approval (`templates/change-authorization.md`) by a
   non-author (guide 06). No authorization, no production.
2. **Gates are enforced, not advisory.** The pre-merge and pre-deploy checks run in
   **shared CI/CD that the author cannot bypass** — required status checks on a protected
   branch, not a local hook + honour system. The base playbook's `checks/` scripts are the
   *content*; at this tier they execute server-side where no `--no-verify` reaches them.
3. **Evidence is retained and tamper-evident.** Each change's record — authorization,
   reviews, CI result, deploy log — is stored where it cannot be silently edited
   (append-only / protected), with a defined retention period (align to your audit scope;
   commonly ≥ 12 months). Git history alone, being rewritable, is not sufficient evidence.
4. **A real emergency / break-glass path.** A defined procedure for urgent fixes: who may
   invoke it, what is allowed, and the **retroactive review within a fixed window** (e.g.
   one business day). Break-glass *reorders* author→review→release; it never removes the
   review. Every invocation is logged and reviewed — an unreviewed break-glass is an incident.
5. **Standard / normal / emergency change classes.** Classify changes: *standard*
   (pre-approved low-risk pattern), *normal* (full authorization), *emergency*
   (break-glass). The class determines the approval path; the class is recorded.
6. **The change record links the whole chain.** Story → design/ADR → PR + reviewer →
   CI result → release approval → deploy → rollback note. One sample pull should surface
   the entire lineage.

---

## War story

*Composite — a pattern auditors see repeatedly at this stage.*

A team pointed proudly at its governance script: "every commit runs the gates." The
auditor asked two questions. *Can a developer commit without it?* — yes, `--no-verify`.
*Where is the retained proof it ran on change #3,417?* — nowhere; it ran on a laptop and
left no artifact. Both answers turned a real, well-designed control into zero audit
evidence. Nothing about the *checks* was wrong; everything about their *enforcement and
retention* was. The fix moved the identical checks into required CI status, with results
retained per change — same rules, now provable.

---

## How to verify

- **Bypass attempt fails:** a change that skips the gates cannot reach the protected branch
  / production (config-enforced, not honour system).
- **Evidence retained:** a sampled change from months ago still has its authorization,
  review, CI result, and deploy log, in tamper-evident storage.
- **Lineage complete:** one sampled production change resolves to its full chain
  (story → ADR → PR/reviewer → CI → release approval → deploy → rollback).
- **Break-glass reviewed:** every emergency change has a retroactive review on file within
  the window; none are open past it.

---

## Adopt on a new project

- [ ] Move the gates from local/opt-in to **enforced shared CI/CD** as required status checks.
- [ ] Adopt `templates/change-authorization.md`; require a recorded non-author release approval.
- [ ] Define retention + tamper-evident storage for change evidence (≥ your audit window).
- [ ] Write the break-glass procedure with a fixed retroactive-review window — before you need it.
- [ ] Classify changes (standard/normal/emergency) and record the class per change.

> Next guide: **08 — Access & Identity.**
