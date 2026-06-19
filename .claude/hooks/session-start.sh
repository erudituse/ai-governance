#!/usr/bin/env bash
# SessionStart hook — inject the governance checklist into the agent's context
# every session, so the rules are present at coding time (not buried in a file
# the agent may not re-read). Fail-open: if jq is missing, emit nothing.
set -uo pipefail
command -v jq >/dev/null 2>&1 || exit 0

read -r -d '' CHECKLIST <<'EOF'
GOVERNANCE — this project follows the SDLC Governance Playbook (root CLAUDE.md is the law; docs/governance/00–07 is the detail). Before acting, every session:

1. Requirements first. Write or amend a story (what + why + TESTABLE acceptance criteria) BEFORE editing source. "ok / go / proceed" approves the direction, never skipping the spec.
2. Blast radius before shared-code changes. List downstream consumers; if you can't name them, decompose the change.
3. Backend-only business logic; default-deny authorization; never hardcode secrets (use the typed config accessor).
4. No hallucinated symbols. Every call/import resolves in this repo or an INSTALLED dependency; cite file:line for any claim about existing behaviour (code is the source of truth).
5. Green test baseline before AND after. New behaviour ships with a test. Report "before: X passing, after: X+N."
6. Never read client-data files or endpoints (.db/.sqlite/.csv dumps, PII logs, /users//accounts paths). If you need data context, STOP and ask the user to describe what they see.
7. STOP and ask before: deleting/migrating data or schema, pushing/deploying, touching shared code used by >1 feature, needing new credentials, or anything of uncertain reversibility.
8. The maker never certifies its own work. A human reads the diff before merge on shared-code / auth / data changes — even solo. Your self-review is an input, not the approval.
9. On ship, update the ORIGIN story to match the code (acceptance criterion ↔ test ↔ file:line; record divergences). Verify "done" against the code, not your own word.
10. Flag any security / data-exposure / compliance concern immediately, even if out of scope. Never silently work around a problem.

Two hooks enforce this: source edits are blocked until a story/spec is in progress; git push and spec-less commits ask for human confirmation. These are guardrails, not a substitute for the rules above.
EOF

jq -n --arg c "$CHECKLIST" \
  '{hookSpecificOutput:{hookEventName:"SessionStart",additionalContext:$c}}'
