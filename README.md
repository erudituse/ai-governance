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
install.js                          one-command installer — `node install.js` copies the kit into your repo
LICENSE / NOTICE
.claude/
├── settings.json                   wires the agent-side governance hooks
└── hooks/                          SessionStart checklist · requirements-first gate · git push/commit gate
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

> This repo is a **template you copy *from*** — not a project you build *in*. You drop its
> governance files into **your** repository, then code there with Claude Code.

### Quick install — one command, any OS

Download this kit (clone or "Download ZIP"). Then, from inside **your** project directory,
run the installer. Node ships with Claude Code, so it's already on your machine — the same
command works on Windows, macOS, and Linux:

```
node /path/to/this-kit/install.js
```

It copies the governance files into your repo, drops the root `CLAUDE.md`, and adds the
`.gitignore` lines — and it **never overwrites an existing root `CLAUDE.md`** (that holds
your Part 2). Re-running it is safe. Then do **Then (either path)** below.

### Manual install — if you'd rather copy by hand

Copy these from the kit into your repository, keeping the same paths (use your file manager
or whatever copy command your OS has):

| From (this kit) | To (your repo) | What it is |
|---|---|---|
| `docs/governance/` | `docs/governance/` | guides, templates, checks |
| `.claude/settings.json` and `.claude/hooks/` | same paths | the agent-side governance hooks |
| `docs/governance/CLAUDE.md` | `CLAUDE.md` at your repo **root** | the policy — **skip this if you already have a root `CLAUDE.md`**; merge by hand instead |

Then add these lines to your `.gitignore` (so the hooks ship but local state doesn't):

```
.claude/settings.local.json
.claude/*.lock
.claude/projects/
.claude/plans/
.claude/todos/
.claude/shell-snapshots/
```

### Then (either path)

1. **Fill in Part 2 of `CLAUDE.md`** — project name, tech stack, and the two switches in
   § 2.1. If either switch is elevated, also copy
   [`docs/governance/scale/`](docs/governance/scale/) and add
   `@docs/governance/scale/CLAUDE.md` to your root `CLAUDE.md`.
2. **Read [`docs/governance/00-operating-model.md`](docs/governance/00-operating-model.md)**
   first — it explains *why* the rest takes the shape it does — then each guide's
   **Adopt on a new project** checklist.
3. **Open Claude Code in your repo and start coding.** The hooks load automatically: a
   governance checklist is injected each session, source edits are blocked until a story
   exists, and `git push` / spec-less commits ask for confirmation.
4. **(Optional)** Wire the CI gates — see **Running the gates** below.

### On Windows

The installer and the governance **docs** work on Windows with no setup — run the installer
with a Windows path, e.g.:

```
node C:\path\to\this-kit\install.js
```

`CLAUDE.md` and the guides steer the agent on any OS. The **hooks** that *enforce* the
process are shell scripts, so they need a Unix shell plus `jq`. Two quick steps turn them on:

1. **Get `bash`.** Install [Git for Windows](https://git-scm.com/download/win) (gives you
   **Git Bash**) or enable **WSL**. Claude Code uses Git Bash for hooks automatically when
   it's present — no config needed.
2. **Get `jq`.** Install it and make sure it's on your PATH — e.g. `winget install jqlang.jq`
   (or Scoop / Chocolatey). Verify with `jq --version`.

If `bash` or `jq` is missing, the hooks **fail open**: your work is never blocked, but the
hard enforcement (the requirements-first gate and git gates) is simply **off** — only the
written policy in `CLAUDE.md` applies. Install both to switch enforcement on. (To avoid the
shell dependency entirely, the hooks could be ported to Node, which runs natively on Windows
— not done yet.)

## Running the gates

Enforcement splits by what does the job best — a rule without a gate rots, but the
gate has to be a real control, not a home-grown grep pretending to be one:

- **Secrets** → `gitleaks` · **SAST** (PII-in-logs, XSS sinks, `eval`, `target=_blank`)
  → `semgrep` with [`checks/semgrep-governance.yml`](docs/governance/checks/semgrep-governance.yml).
  These run in **CI as required status checks** — the control of record.
- **Governance-specific gates** (requirements-first, honest story close-out) and a
  **playbook self-lint** → [`checks/governance-checks.sh`](docs/governance/checks/governance-checks.sh),
  read-only, runs locally and in CI. It covers only what no off-the-shelf scanner does.

```bash
# the governance-specific gates, locally (edit the CONFIG block first:
# PROJECT_TERMS, SOURCE_EXTS, SPEC_PATHS — secrets/PII patterns live in semgrep now)
bash docs/governance/checks/governance-checks.sh

# the real enforcement: copy the CI workflow and mark its jobs REQUIRED
cp docs/governance/checks/ci.yml.sample .github/workflows/governance.yml
#   then: Settings → Branches → require `secrets`, `sast`, `governance` to pass

# (optional) fast local feedback — install the pre-commit hook
cp docs/governance/checks/pre-commit.sample .git/hooks/pre-commit && chmod +x .git/hooks/pre-commit
```

A required CI check is one the author **cannot bypass**; a local hook is a convenience
they can skip with `--no-verify`. That distinction is the whole point — *a bypassable
gate is, to an auditor, no control*, so the secret/SAST scanners are wired as required
checks, not left to the local script.

At the **audit tier**, also run `docs/governance/scale/checks/assurance-checks.sh` as a
required CI check. Full configuration and per-gate detail:
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
