# Control Operation & Audit
## Owned controls, monitored on a cadence, evidenced on demand

*SDLC Governance Playbook for Scale · Guide 13 — assurance layer*

**Hat — Compliance Officer / Internal Audit liaison:** give every control an owner and a monitoring cadence, run a waiver register for exceptions, and keep the evidence complete enough to survive a sample.

---

## Principle

> **A control that no one owns, no one monitors, and cannot be evidenced on demand does
> not exist — however well it is written. The final layer is *operating* the controls:
> ownership, a monitoring cadence, a waiver register for honest exceptions, and evidence
> complete and accurate enough that any sample an auditor pulls resolves.**

This guide ties the others together. Guides 00–12 define and run individual controls; this
is the management-review layer SOC 2 (CC4) and SOX (management review controls) test —
*how do you know your controls are working?*

---

## Why it matters

**Likelihood: This is the audit itself.** An auditor's method is sampling: pull N items,
ask each to resolve to evidence. The control with no owner is the one that lapsed; the
register that's "mostly complete" is the one the sample lands in the gap of.

**Impact: Pass or fail turns on this.** Beautiful individual controls fail the engagement
if you can't show they *operated consistently over the period* and that your *evidence is
complete and accurate* (IPE — information produced by the entity). "Mapped but not
evidenced," and "evidenced but not complete," are the two ways a real control still fails
an audit.

---

## The rule(s)

1. **A control-ownership matrix (RACI).** Every control from guides 00–12 has one named
   owner, a monitoring cadence, and the evidence artifact it produces
   (`templates/control-matrix.md`). Responsible / Accountable / Consulted / Informed is
   defined for each in-scope change type. No null owners.
2. **Monitoring on a cadence — and recorded.** Each control is reviewed on its cadence
   (e.g. access review quarterly, log review weekly, restore drill per schedule, CVE pass
   monthly). The *review itself* is evidenced — a dated record that it happened and what it
   found, not just that the underlying control exists.
3. **A waiver / exception register.** Where a control can't be met now, a **documented,
   approved, time-boxed** waiver: what is excepted, the compensating control, the risk
   accepted, the owner, and an **expiry date**. Expired waivers are escalated, never
   auto-renewed. An undocumented gap is a finding; a documented, owned, expiring waiver is
   a managed risk.
4. **Evidence is complete and accurate (IPE).** For any register or report used as
   evidence, you can show it captures *every* in-scope event, not a convenient subset —
   the "register-in-the-same-change-set" gates (base playbook) are what make completeness
   demonstrable rather than asserted.
5. **The framework crosswalk is the index.** `crosswalk/framework-crosswalk.md` maps each
   control to the SOX / SOC 2 / PCI / ISO requirement it satisfies and the evidence that
   proves it — kept current, it is the first document an auditor reads.
6. **Audit-log specifics (carried from the base spine, made concrete).** Define the logged
   fields, the retention period (≥ audit window), tamper-evident/append-only storage,
   restricted log access, time synchronisation (NTP) for correlation, and a **log-review
   cadence with a recorded reviewer** — a log no one reviews is storage, not a control.
7. **Periodic internal audit.** On a cadence, sample your own controls the way an external
   auditor would; findings feed the incident→rule loop (base guide 00) and the risk
   register. Catch your gaps before the auditor does.
8. **Metrics, not page-count.** Track gate pass-rate, register freshness, finding-SLA
   adherence, incident MTTR (base guide 07). *If your only evidence of governance is the
   length of the policy, you have none.*

---

## War story

*Composite — a pattern auditors see repeatedly at this stage.*

A team had genuinely good controls — branch protection, scanning, encryption, the lot — and
still struggled in its first audit. Why? No one *owned* each control, so when the auditor
asked "who confirms the access review ran, and where's Q2's?", the answer was a scramble;
the access review had simply been missed in Q2 and nobody's job it was to notice. And a
register the team offered as evidence turned out to cover only one of three repos —
incomplete, so unusable. The controls worked; the *operation* of them wasn't owned,
monitored, or provably complete. The fix was the matrix (owner + cadence + evidence per
control), a recorded monitoring step, and completeness gates so registers couldn't drift.

---

## How to verify

- **No null owners:** every control in the matrix names a person and a cadence.
- **Monitoring evidenced:** a sampled control has a dated record that its periodic review
  ran and what it found — within cadence.
- **Waivers clean:** every exception has an approved, time-boxed waiver with a compensating
  control; none are expired-and-open.
- **Completeness (IPE):** a register offered as evidence demonstrably covers all in-scope
  events (all repos/systems), not a subset.
- **Crosswalk current:** a sampled framework requirement resolves through the crosswalk to a
  control and to evidence that exists and is dated.
- **Logs reviewed:** the log-review cadence has a recorded reviewer; retention and
  tamper-evidence are configured.

---

## Adopt on a new project

- [ ] Build the control-ownership matrix (owner + cadence + evidence) covering guides 00–12.
- [ ] Make each periodic review a *recorded* event, not just a standing control.
- [ ] Stand up the waiver register with approval, compensating control, and expiry.
- [ ] Build and maintain `crosswalk/framework-crosswalk.md` as the audit-evidence index.
- [ ] Define audit-log fields/retention/NTP/access + a log-review cadence; schedule internal audit.
- [ ] Track adherence metrics; review them on a cadence and prune the spine relentlessly.

> Back to **00 — Team Operating Model** for the loop every control runs.
