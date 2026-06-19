# Waiver / exception template — the documented, time-boxed gap

Copy this whenever a control cannot be met now. The rule (guide 13): an **undocumented gap
is a finding; a documented, approved, time-boxed waiver with a compensating control is a
managed risk.** A waiver is never a permanent excuse — it has an expiry, and an expired
waiver is escalated, never auto-renewed.

Keep all waivers in one register so currency and expiry are visible at a glance.

---

## The skeleton

```markdown
---
waiver-id: W-NNN
control: <which control/guide is not being met — e.g. S-03 non-author review>
status: proposed | approved | expired | closed
raised-by: <name>
approved-by: <accountable owner — must have authority to accept the risk>
date-raised: YYYY-MM-DD
expiry: YYYY-MM-DD          # REQUIRED — no open-ended waivers
---

# Waiver W-NNN: <one-line title>

## What is excepted
<The control, and precisely what is not being met. Scope it tightly.>

## Why (and why it can't be met now)
<The constraint — headcount, sequencing, vendor limitation, etc.>

## Risk accepted
<Likelihood × impact if the gap is exploited or the control's absence bites — state BOTH
halves (base playbook house rule). Who bears the risk.>

## Compensating control
<What partially mitigates in the meantime — e.g. mandatory post-hoc peer review of all of
this person's merges where author=approver is forced.>

## Remediation plan
<What closes the waiver, the owner, and the target date — should be ≤ expiry.>

## Review log
- YYYY-MM-DD: <raised / approved / reviewed / extended-with-reason / closed>
```

---

## Accuracy contract

- **Every waiver has an expiry.** A waiver with no expiry is not a waiver — it's a silent
  gap wearing a label.
- The approver has the authority to accept the stated risk; risk is stated as
  likelihood **and** impact.
- Expired-and-open waivers are surfaced by `checks/assurance-checks.sh` and escalated.
- When the remediation lands, mark `closed` with the evidence — don't just let it expire.
