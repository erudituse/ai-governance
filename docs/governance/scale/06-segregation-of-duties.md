# Segregation of Duties
## No one — and no AI — approves their own work

*SDLC Governance Playbook for Scale · Guide 06 — assurance layer*

**Hat — Security Architect / Control Owner:** design the maker-checker boundaries so that no single actor can author, approve, and release the same change — and so AI-authored work always has a named human checker.

---

## Principle

> **Authorship and approval are different people. A change is *made* by one actor and
> *checked* by another; releasing to production is a third gate. No single human — and
> never the AI — holds the whole chain. The AI is always a *maker*, never a *checker* of
> its own output.**

Segregation of duties (SoD) is the control that every framework here leans on — SOX ITGC,
SOC 2 CC8, PCI 6, ISO A.5/A.8. It is also the control most distorted by AI, because the AI
can produce *and appear to review* a change. This guide draws the line.

---

## Why it matters

**Likelihood: Certain to be tested.** SoD is the first thing an ITGC auditor checks and
the easiest exception to find: pull any change, look for an approver who isn't the author.
With an AI in the loop, the natural-but-wrong pattern — the AI writes it, the human who
prompted it clicks approve — *looks* like review and isn't.

**Impact: Audit-fatal, and a real fraud/error control.** "Authors approve their own
changes" voids change management for the whole period. Beyond audit, SoD is a genuine
defence: it is how an honest mistake (or a malicious one) gets a second set of eyes before
it reaches production money, data, or access.

---

## The rule(s)

1. **Maker ≠ checker.** The person who authors a change is not the person who approves it.
   Approval is by a qualified reviewer with no authorship stake in that change.
2. **The AI is a maker, never a checker.** AI-generated code, designs, or configs are
   *proposals*. **The AI never provides the approving review.** And the human who prompted
   the AI is the *author* of that output — not an independent checker of it. Independent
   review means a *different* qualified human.
3. **Release is a distinct gate.** Author → reviewer → release-approver. On small teams one
   person may hold two *non-adjacent* roles only with a documented compensating control;
   author-and-sole-release-approver is never an acceptable combination.
4. **Provenance & attestation are recorded.** Every change records: who/what authored it
   (human, or human-directed AI — disclosed), who reviewed it, who authorized release. The
   merging/releasing human *attests* they reviewed the work — accountability never reads
   "the AI did it" (base `CLAUDE.md` §12).
5. **Privileged actions need a second actor too.** SoD isn't only code: production data
   changes, access grants, key operations, and deploy-script edits each need a second
   authorized person (guides 05, 08, 11).
6. **Compensating controls are documented, not assumed.** Where headcount truly forces a
   role overlap, write the compensating control (e.g. mandatory post-hoc review of all of
   that person's merges by a peer) and put it in the control matrix — a known, accepted,
   evidenced exception, not a silent gap.

---

## War story

*Composite — a pattern auditors see repeatedly at this stage.*

A four-person team adopted an AI assistant and, reasonably, treated its output as
"reviewed" because a human had read the prompt and the diff. The SOC 2 auditor disagreed:
the human who *commissioned* the change is its author, so every AI change had been
self-approved. Worse, the same engineers deployed their own merges. Two SoD exceptions,
one root cause. The fix wasn't to slow down — it was to require a *second* engineer's
approval on every PR (AI-authored or not), make release a separate recorded approval, and
record provenance (authored-by / reviewed-by / released-by) on each change.

---

## How to verify

- **Author ≠ approver:** sampled changes show an approving reviewer who is not the author
  (and not the AI or its prompter).
- **Three-gate sample:** a sampled production change shows distinct author, reviewer, and
  release-approver — or a documented compensating control where roles overlap.
- **Provenance complete:** authored-by (incl. AI disclosure), reviewed-by, released-by are
  all recorded.
- **Privileged second-actor:** a sampled access grant / key operation / prod-data change
  shows a second authorized actor.

---

## Adopt on a new project

- [ ] Write the SoD rule: maker ≠ checker; AI is always maker, never checker.
- [ ] Enforce non-author approval in branch protection (guide 03) and recorded release
      approval (guide 05).
- [ ] Record provenance (authored/reviewed/released) on every change; require human attestation.
- [ ] Extend SoD to privileged non-code actions (access, keys, prod data).
- [ ] Document any forced role-overlap as a compensating control in the control matrix.

> Next guide: **07 — Change Management.**
