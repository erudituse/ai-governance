# Governance gates — what's enforced where

A rule without a gate rots. But the gate has to be a *real* control, not a
brittle home-grown grep that pretends to be one. So the checks split three ways:

| Concern | Enforced by | Where |
|---|---|---|
| Secrets in code/history | **gitleaks** | CI (`ci.yml.sample`) — required check |
| PII-in-logs, XSS sinks, `eval`, `target=_blank` | **semgrep** (`semgrep-governance.yml`) | CI — required check |
| Requirements-first · honest story close-out | **`governance-checks.sh`** | local + CI |
| Playbook docs well-formed | **`governance-checks.sh`** (self-lint) | local + CI |

The secret/SAST scanning used to be hand-rolled regex gates inside the script.
They were weak (single-language, staged-diff-only, easily fooled) and a worse
version of tools that already exist. They're gone; `gitleaks` and `semgrep` do
the job properly — full history, every language, maintained rule packs.

`governance-checks.sh` now keeps only what *no* off-the-shelf tool does.

## What `governance-checks.sh` checks

Everything in it is **read-only** — it never modifies your repo.

**Section A — Playbook self-lint** (only relevant when editing the governance docs themselves):

| Gate | What it does |
|---|---|
| A1 · De-projection | The playbook contains none of your previous project's domain terms |
| A2 · Format contract | Every guide has the six required sections |
| A3 · Hat | Every guide declares its phase **Hat** |
| A4 · Section structure | Every guide is split into sections by `---` breaks |
| A5 · Templates | The fill-in phase skeletons are present |

**Section B — Governance gates** (project-level; the checks a scanner can't make):

| Gate | Guide | What it does |
|---|---|---|
| B1 · Requirements-first | 01 | A staged *source* change is accompanied by a *spec* change. **Heuristic** — it catches "code, no story at all"; it cannot know the spec *describes* the change, so a reviewer still confirms that. |
| B2 · Close-out | 01 | A `shipped`/`implemented` story cites `file::symbol` / `file:line` references that actually resolve — the file exists **and** the symbol/line is really in it. Catches the "AI said done, ticket never matched the code" stale close-out. |

Checks that need project context (no staged changes, not a git repo, no story
files) **skip** rather than fail.

## Configure it (one block, top of the script)

- `PROJECT_TERMS` — the previous project's domain words that must not leak into the playbook.
- `SOURCE_EXTS` — extensions that count as "source" for the requirements-first reminder.
- `SPEC_PATHS` — where specs/stories live (a staged change here satisfies gate B1).

(Secret and PII patterns are no longer configured here — they live in
`semgrep-governance.yml` and gitleaks' config.)

## Run it

```bash
# locally, anytime
bash docs/governance/checks/governance-checks.sh

# as a make target
govcheck:
	@bash docs/governance/checks/governance-checks.sh
```

Exit `0` = green; non-zero = a gate failed (and prints what).

## Wire the real enforcement (the part that actually gates a merge)

The local script and pre-commit hook are a *fast feedback loop* the author can
skip (`git commit --no-verify`). The **control of record** is CI:

1. Copy `ci.yml.sample` to `.github/workflows/governance.yml`.
2. Mark `secrets`, `sast`, and `governance` as **required status checks** on your
   protected branch. A required check is one the author cannot bypass — *that* is
   what makes it a control rather than a suggestion.

The opt-in pre-commit hook (`pre-commit.sample`) is still useful for catching the
governance gates before you push; install it deliberately:

```bash
cp docs/governance/checks/pre-commit.sample .git/hooks/pre-commit
chmod +x .git/hooks/pre-commit
```

## What none of this does — by design

Some guide checks need project knowledge and live in *your* suite, not here:

- **Cross-surface consistency** (Guide 04) — a real integration test in your suite.
- **Caller-trace / non-regression** (Guide 03) — your test suite, run before and after.
- **Gold-master** (Guide 04) — your snapshot tests.
- **Deploy invariants** (Guide 05) — checks inside your deploy script.
- **Object-level authz / IDOR** (Guide 06) — a cross-user negative test in your suite.

The scripts and scanners cover the mechanical, portable gates; correctness and
regression coverage live in your test suite and deploy pipeline, where they belong.
