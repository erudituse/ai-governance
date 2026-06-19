# Control-matrix template — owner, cadence, evidence per control

Copy this and fill one row per control you adopt (from base guides B-00–07 and scale guides
S-00–13). It is the backbone of control operation (guide 13): **every control has one named
owner, a monitoring cadence, and a named evidence artifact.** No null owners. This is what
turns a folder of good rules into a set of *operating* controls an auditor can sample.

Pair with `framework-crosswalk.md` (which standard each control satisfies) — the matrix
says *who runs it and how you know it ran*; the crosswalk says *what it's for*.

---

## RACI key

**R** Responsible (does the work) · **A** Accountable (one person, owns the outcome) ·
**C** Consulted · **I** Informed. Exactly one **A** per control.

---

## The skeleton

```markdown
# Control matrix — <project>   (last reviewed: YYYY-MM-DD by <name>)

| Control | Guide | Owner (A) | R / C / I | Cadence | Evidence artifact | Last operated | Status |
|---|---|---|---|---|---|---|---|
| Non-author PR review | S-03/06 | <name> | R: devs · I: lead | per change | branch-protection + PR approvals | <date> | OK |
| Recorded release approval | S-05/07 | <name> | R: releaser | per release | change-authorization records | <date> | OK |
| Periodic access review | S-08 | <name> | C: owners | quarterly | access-review records | <date> | OK |
| Penetration test | S-09 | <name> | C: vendor | annual + on change | pen-test report + retest | <date> | OK |
| Restore drill | S-10 | <name> | R: SRE | <cadence> | restore-drill artifact | <date> | OK |
| Key rotation | S-11 | <name> | R: crypto owner | <crypto-period> | rotation log | <date> | OK |
| Retention / disposal | S-11 | <name> | C: DPO | <cadence> | disposal evidence | <date> | OK |
| Security training | S-12 | <name> | I: all | annual | training roster | <date> | OK |
| Vendor/subservice review | S-12 | <name> | C: security | annual | vendor register + SOC2 reviews | <date> | OK |
| Log review | S-13 | <name> | R: secops | <cadence> | log-review records | <date> | OK |
| CVE / dependency pass | B-05/S-09 | <name> | R: devs | monthly | scan results + ignore register | <date> | OK |
| Internal audit | S-13 | <name> | A: compliance | <cadence> | internal-audit records | <date> | OK |
| ... | ... | ... | ... | ... | ... | ... | ... |

Status: OK (operating, evidence current) · DUE (within grace) · OVERDUE (escalate) · WAIVED (link W-NNN)
```

---

## Accuracy contract

- **Exactly one Accountable per control; zero null owners** (guide 00).
- `Last operated` is a real date from the evidence artifact — not "ongoing."
- `OVERDUE` rows are escalated; `WAIVED` rows link a live, unexpired waiver (`waiver.md`).
- The matrix itself is reviewed on a cadence; bump `last reviewed` each pass.
