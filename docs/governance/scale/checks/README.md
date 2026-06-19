# Assurance gates — the audit-tier checks

This folder mechanises the **How to verify** sections of the *scale* guides, on top of the
base playbook's `../../checks/governance-checks.sh`. A rule without a gate rots;
these are the gates for the audit tier.

Everything here is **read-only**. But unlike the base gates (advisory + local by design),
these are meant to run as **enforced CI status checks** — guide 07 is explicit that a
*bypassable, evidence-less* gate is, to an auditor, no control at all. So: run the base
script for the day-to-day greppable hygiene, and wire **this** one into required CI where
the author cannot skip it.

## Run both

```bash
# base hygiene (de-projection, requirements-first, secrets, PII-in-logs)
bash "docs/governance/checks/governance-checks.sh"

# audit-tier assurance (scope declared, evidence current, no expired waivers, SoD smell)
bash "docs/governance/scale/checks/assurance-checks.sh"
```

## What `assurance-checks.sh` checks

| Gate | Guide it enforces | What it does |
|---|---|---|
| 1 · De-projection | S-00 | The scale playbook contains none of your previous project's domain terms |
| 2 · Format contract | S-00–13 | Every scale guide has the six sections **and** a Hat |
| 3 · Artifacts | S-13 / crosswalk | The crosswalk and all six evidence templates are present |
| 4 · Scope declared | S-06 | Your root `CLAUDE.md` Part 2 declares the assurance tier + in-scope frameworks |
| 5 · Control matrix | S-13 | The matrix exists and was reviewed within `MATRIX_MAX_AGE_DAYS` |
| 6 · Waivers | S-13 | No waiver is expired-and-still-open |
| 7 · SoD smell test | S-06 | Surfaces recent merges to confirm a non-author approver (heuristic only) |

## Configure it (one block, top of the script)

- `PROJECT_TERMS` — previous project's domain words that must not leak in.
- `CLAUDE_MD` — path to your root governance file (must declare scope).
- `SCOPE_MARKERS` — the strings that prove Part 2 declares tier + frameworks.
- `CONTROL_MATRIX` / `WAIVER_REGISTER` — where your living evidence registers live.
- `MATRIX_MAX_AGE_DAYS` — how stale the control matrix may get before it fails.

## What it deliberately does **not** do

The gates that need real system state are not greppable and live where the evidence is —
not in this script:

- **Independent approval / SoD** (guide 06) — your forge's **branch-protection config +
  PR approval records** are the real control; gate 7 is only a smell test.
- **Enforced-not-bypassable** (guide 07) — proven by your **CI required-status-check
  config**, not by this script (which can itself be skipped if run locally).
- **Penetration test, restore drill, access review, key rotation** (guides 08–11) — proven
  by the dated **evidence artifacts** those controls produce (`templates/`), sampled in the
  control matrix.
- **IPE completeness** (guide 13) — that a register covers *all* in-scope events is a
  human/auditor judgement against the source of truth.

The script covers the *mechanical* assurance gates; the rest are your forge configuration,
your CI configuration, and the dated evidence artifacts your controls produce — which is
exactly where an auditor looks.
