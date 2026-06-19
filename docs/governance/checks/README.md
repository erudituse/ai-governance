# Governance gates — the cheap local checks

This folder mechanises the **How to verify** sections of the playbook guides. A rule
without a gate rots; these scripts are the gates.

Everything here is **read-only** and **opt-in**. Nothing installs itself, mutates your
repo, or runs in CI automatically — you wire it in deliberately (a manual run, a `make`
target, or a pre-commit hook you choose to install). This matches the principle that a
manual discipline should not silently become an automatic mechanism.

## What `governance-checks.sh` checks

| Gate | Guide it enforces | What it does |
|---|---|---|
| 1 · De-projection | 00 Operating model | The playbook contains none of your previous project's domain terms |
| 2 · Format contract | 01–06 | Every guide has the six required sections |
| 3 · Section structure | (playbook) | Every guide is split into sections by `---` breaks |
| 4 · Requirements-first | 01 Requirements | A staged *source* change is accompanied by a *spec* change |
| 5 · Secrets | 03 Coding · 06 Security | The staged diff adds no inline credentials |
| 6 · Privacy | 06 Privacy | No raw PII field name appears inside a logging call |

Gates 4 and 5 inspect the **staged** diff, so they are most useful as a pre-commit
hook. Gates 1–3 and 6 scan the repo and run anywhere. Checks that need project context
(no staged changes, not a git repo) **skip** rather than fail.

## Configure it (one block, top of the script)

Open `governance-checks.sh` and edit the `CONFIG` block for your project:

- `PROJECT_TERMS` — the previous project's domain words that must not leak into the playbook.
- `SOURCE_EXTS` — extensions that count as "source" for the requirements-first gate.
- `SPEC_PATHS` — where specs/stories live (a staged change here satisfies gate 4).
- `SECRET_REGEX` — secret-shaped patterns for your stack.
- `PII_FIELDS` — your personal-data field names (gate 6 is word-boundaried, so `sin` won't match `using`).

## Run it

```bash
# manual, anytime
bash docs/governance/checks/governance-checks.sh

# as a make target (add to your Makefile — your choice, not auto-added)
govcheck:
	@bash docs/governance/checks/governance-checks.sh
```

Exit code `0` = all gates green; non-zero = a gate failed (and prints what).

## Install the pre-commit hook (opt-in)

`pre-commit.sample` is a ready hook. Install it deliberately:

```bash
cp docs/governance/checks/pre-commit.sample .git/hooks/pre-commit
chmod +x .git/hooks/pre-commit
```

To remove it: `rm .git/hooks/pre-commit`. It is never installed for you.

## What it deliberately does **not** do

Some guide checks can't be a portable grep — they need project knowledge:

- **Cross-surface consistency** (Guide 04) — a real integration test in your suite.
- **Caller-trace / non-regression** (Guide 03) — your test suite, run before and after.
- **Gold-master** (Guide 04) — your snapshot tests.
- **Deploy invariants** (Guide 05) — checks inside your deploy script.

The script covers the *greppable* gates; the rest live in your test suite and deploy
pipeline, where they belong.
