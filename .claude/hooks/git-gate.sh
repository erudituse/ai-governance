#!/usr/bin/env bash
# PreToolUse(Bash, if git *) — gate the two git actions the policy cares about.
#   git push   -> ASK (CLAUDE.md §12: pushing/deploying needs explicit user
#                 instruction + a human diff review; the maker never approves
#                 its own work).
#   git commit -> ASK only when source is staged with no spec staged in the same
#                 change set (requirements-first at commit time).
# Everything else passes. Fail-open: missing jq / non-git all allow.
set -uo pipefail
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=_governance-lib.sh
. "$DIR/_governance-lib.sh"

command -v jq >/dev/null 2>&1 || exit 0
input=$(cat)
cmd=$(printf '%s' "$input" | jq -r '.tool_input.command // empty')
[ -z "$cmd" ] && exit 0

if printf '%s' "$cmd" | grep -qE '\bgit\s+push\b'; then
  emit_decision ask \
"Governance §12 — pushing/deploying must be on explicit user instruction, after a human has read the diff (shared-code / auth / data changes especially). Confirm the user asked for this push before proceeding."
  exit 0
fi

if printf '%s' "$cmd" | grep -qE '\bgit\s+commit\b'; then
  if staged_source_without_spec; then
    emit_decision ask \
"Requirements-first — you're committing source with no story/spec staged in the same change set. Stage the story (what + why + acceptance criteria, or the close-out annotation: acceptance criterion ↔ test ↔ file:line) alongside the code. See CLAUDE.md §9."
    exit 0
  fi
fi

exit 0
