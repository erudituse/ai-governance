# The SDLC Governance Playbook

A portable, project-agnostic set of governance guides — one per phase of the software
development lifecycle. Copy this folder into a new repository as the governance
starter-kit: it carries the de-projected policy (`CLAUDE.md`), a guide per phase, and
opt-in enforcement gates (`checks/`).

## Why this exists

This is the governance model a project **starts on** — the foundation you adopt on day
one and build with, not something you reverse-engineer after your first outage. Part 1
is the org spine you inherit as-is; Part 2 you fill in for your project; the
incident→rule loop strengthens both as you go.

Every rule in it earned its place in real production practice, so the model is grounded in
practice rather than theory — and it is kept deliberately lean and de-projected so it
stays portable and actually gets followed.

## What's in the folder

| File | Role |
|---|---|
| `CLAUDE.md` | The de-projected governance policy — Part 1 (org standard) + Part 2 (fill-in skeleton). Drop in as a new repo's root `CLAUDE.md`. The single governance-content file; the guides below teach the *why*. |
| `00-operating-model.md` | The meta loop that produces every rule below |
| `01-requirements.md` | Requirements — documentation is the spec |
| `02-design.md` | Design — decision log + blast-radius before build |
| `03-coding.md` | Coding — lean, backend-only logic, least-privilege, secure-by-design |
| `04-qa-and-testing.md` | QA & testing — baselines, gold-masters, consistency, traceability |
| `05-deployment-and-day2.md` | Deployment & day-2 operations |
| `06-security-privacy-compliance.md` | Cross-cutting: security, privacy, compliance |
| `07-scaling.md` | Scaling the model from one project to a team, many teams, a department |
| `templates/` | Fill-in skeletons, one per phase — `story.md` (requirements + test cases), `design-decision.md` (an architectural decision + blast radius), `code-review.md` (the code-quality lens: hallucination + bloat), `change-checklist.md` (the change/PR process lens). |
| `checks/` | Read-only, opt-in scripts that mechanise each guide's "How to verify" |

## The format every guide follows

Above the six sections, each guide opens with a one-line **Hat** — the role to adopt for
that phase (Requirements → Product Manager, Design → Technical Lead / Architect, and so
on; the cross-cutting security guide names several). The summary mapping lives in
`CLAUDE.md` § 2.1.

Each guide is then built from the same six sections, in order — a complete argument read
top-to-bottom:

| Section | What it provides |
|---|---|
| **Principle** | The discipline in one sentence |
| **Why it matters** | The stakes, stated as *likelihood × impact* |
| **The rule(s)** | What to do — adoptable verbatim |
| **War story** | A representative, composite incident — grounded in practice, not opinion |
| **How to verify** | The cheap local check that makes it stick |
| **Adopt on a new project** | The 60-second port |

Stating both *probability of occurrence* and *impact if it occurs* in "Why it matters"
is itself a house rule — a risk without both halves is just an opinion.

## How to adopt this on a new project

1. Copy the entire `docs/governance/` folder into the new repo, and drop `CLAUDE.md` in as
   the repository's root `CLAUDE.md`. Fill in its Part 2 for your project.
2. Read `00-operating-model.md` first — it explains *why* the rest takes the shape it does.
3. Work through each guide's **Adopt on a new project** checklist, filling the
   project-specific blanks (your stack, your data classes, your deploy target). Adopt the
   `templates/` skeletons — `story.md` for every story, `change-checklist.md` per PR.
4. Wire the gates in: edit the config block in `checks/governance-checks.sh` for your
   project, run it manually or as a `make` target, and optionally install the
   `checks/pre-commit.sample` hook. The gates are what keep the rules from rotting —
   see `checks/README.md`. (Nothing auto-installs; adoption is deliberate.)
