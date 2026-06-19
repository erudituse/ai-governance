# AI Governance & SDLC Playbook

A portable, project-agnostic governance starter-kit for building software **with an AI
coding assistant** — secure, accountable, auditable, and aligned to recognised frameworks
(ISO/IEC 27001 · NIST AI RMF · SOC 2 · SOX ITGC · PCI DSS · OWASP LLM Top 10).

It is two layers you adopt by need, not all at once:

- **Base playbook** — [`docs/governance/`](docs/governance/) — the model **every project
  starts on**: a non-negotiable policy spine (`CLAUDE.md` Part 1), a per-phase guide for
  the SDLC (requirements → design → coding → QA → deploy → security), fill-in templates,
  and opt-in local enforcement gates.
- **Scale extension** — [`docs/governance/scale/`](docs/governance/scale/) — the
  **team-and-audit-grade** layer you adopt *alongside* the base when the project crosses
  into a higher tier. It adds segregation of duties, change-evidence, access lifecycle,
  vulnerability management, resilience, data/crypto lifecycle, supplier assurance, and a
  framework crosswalk for auditors.

## Two switches decide what applies

A project declares its profile on two independent lines in its root `CLAUDE.md` — either
one elevated pulls in the scale extension:

| Switch | Elevated when | Turns on |
|---|---|---|
| `Contributors : solo \| team` | more than one person commits | per-person controls — attribution, maker≠checker, review-by-others, per-person access |
| `Assurance tier : base \| audit` | you owe evidence to a framework | evidence controls — retained records, enforced CI gates, pentest, registers |

So: **solo + base** → base only · **team + base** → base + per-person controls · **solo +
audit** → base + evidence controls (segregation met via a compensating control) · **team +
audit** → the full set.

## Repository layout

```
CLAUDE.md / LICENSE / NOTICE        ← (CLAUDE.md is copied to an adopting repo's root)
docs/governance/
├── CLAUDE.md                       the policy: Part 1 (org spine) + Part 2 (project fill-in)
├── 00–07 *.md                      one guide per SDLC phase
├── templates/                      story · design-decision · code-review · change-checklist
├── checks/                         opt-in local governance gates (shell)
└── scale/                          the audit/team-tier extension
    ├── CLAUDE.md                   Part 1-S (audit controls) + Part 2-S (project fill-in)
    ├── 00–13 *.md                  team + assurance guides
    ├── crosswalk/                  control → SOX/SOC 2/PCI/ISO evidence index
    ├── templates/                  evidence artifacts (control matrix · waiver · access review · …)
    └── checks/                     enforced-in-CI assurance gates
```

## How to adopt it on your project

1. Copy [`docs/governance/`](docs/governance/) into your repo and drop its `CLAUDE.md` in
   as your repository's **root** `CLAUDE.md`. Fill in Part 2 for your project, and set the
   two switches in § 2.1.
2. Read [`docs/governance/00-operating-model.md`](docs/governance/00-operating-model.md)
   first — it explains *why* the rest takes the shape it does.
3. Work through each guide's **Adopt on a new project** checklist; adopt the `templates/`.
4. Wire in the gates (see **Running the gates** below). If either switch is elevated, also
   adopt [`docs/governance/scale/`](docs/governance/scale/) and add
   `@docs/governance/scale/CLAUDE.md` to your root `CLAUDE.md`.

## Running the gates

The `checks/` scripts mechanise each guide's "How to verify" — a rule without a gate rots.
They are **read-only** (they never modify your repo) and **opt-in** (nothing auto-installs).

```bash
# 1. edit the CONFIG block at the top of the script for your project
#    (PROJECT_TERMS, SOURCE_EXTS, SPEC_PATHS, SECRET_REGEX, PII_FIELDS)

# 2. run it anytime — exit 0 = all green, non-zero = a gate failed (and prints why)
bash docs/governance/checks/governance-checks.sh

# 3. (optional) block bad commits — install the sample pre-commit hook
cp docs/governance/checks/pre-commit.sample .git/hooks/pre-commit
chmod +x .git/hooks/pre-commit
```

At the **audit tier**, also run `docs/governance/scale/checks/assurance-checks.sh` as a
**required CI status check the author cannot bypass** — a bypassable gate is, to an
auditor, no control. Full configuration and per-gate detail:
[`docs/governance/checks/README.md`](docs/governance/checks/README.md) and
[`docs/governance/scale/checks/README.md`](docs/governance/scale/checks/README.md).

## Disclaimer

This playbook is **educational guidance, not legal, audit, or compliance advice.** The
framework mappings (ISO, NIST, SOC 2, SOX, PCI, GDPR, EU AI Act, etc.) are illustrative and
do **not** constitute certification or a guarantee of conformance. Adopting this material
does not make any system compliant. Assess your obligations with a qualified auditor,
assessor, or counsel for your jurisdiction and frameworks. War stories are composite,
anonymised illustrations, not accounts of any specific organisation. Provided "AS IS"
without warranty of any kind (see `LICENSE`).

## License

Licensed under the **Apache License, Version 2.0** — see [`LICENSE`](LICENSE) and
[`NOTICE`](NOTICE).
