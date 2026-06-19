#!/usr/bin/env bash
# Shared config + helpers for the governance hooks.
# ============================ EDIT FOR YOUR PROJECT ============================
# Extensions that count as "source" (a story must exist before editing these).
SOURCE_EXTS="py ts tsx js jsx go rb java rs php cs cpp cc c h kt swift scala vue svelte"
# Path fragments where specs/stories live. A change under any of these = "spec touched".
SPEC_PATHS="docs/ requirements/ stories/"
# ==============================================================================

# is_source_file PATH -> 0 if PATH is source code (and NOT under a spec path)
is_source_file() {
  local p="$1" ext e sp
  for sp in $SPEC_PATHS; do
    case "$p" in "$sp"*|*/"$sp"*) return 1;; esac
  done
  case "$p" in *.*) ext="${p##*.}";; *) return 1;; esac
  for e in $SOURCE_EXTS; do [ "$ext" = "$e" ] && return 0; done
  return 1
}

# spec_in_progress -> 0 if any file under SPEC_PATHS has an uncommitted change.
# Fail-open: not a git repo -> treated as in-progress (don't block).
spec_in_progress() {
  git rev-parse --is-inside-work-tree >/dev/null 2>&1 || return 0
  local status sp
  status=$(git status --porcelain 2>/dev/null) || return 0
  for sp in $SPEC_PATHS; do
    printf '%s\n' "$status" | grep -qE "^.{3}${sp}" && return 0
  done
  return 1
}

# staged_source_without_spec -> 0 if the commit stages source but no spec change.
staged_source_without_spec() {
  git rev-parse --is-inside-work-tree >/dev/null 2>&1 || return 1
  local staged f has_src="" sp
  staged=$(git diff --cached --name-only 2>/dev/null) || return 1
  [ -z "$staged" ] && return 1
  while IFS= read -r f; do
    [ -n "$f" ] && is_source_file "$f" && has_src="x"
  done <<EOF
$staged
EOF
  [ -z "$has_src" ] && return 1
  for sp in $SPEC_PATHS; do
    printf '%s\n' "$staged" | grep -qE "^${sp}" && return 1   # spec staged -> fine
  done
  return 0
}

# emit_decision DECISION REASON  -> print the PreToolUse hook JSON (deny|ask|allow)
emit_decision() {
  if command -v jq >/dev/null 2>&1; then
    jq -n --arg d "$1" --arg r "$2" \
      '{hookSpecificOutput:{hookEventName:"PreToolUse",permissionDecision:$d,permissionDecisionReason:$r}}'
  else
    # jq missing: fail open (allow) so enforcement degrades, never breaks
    printf '{"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"allow"}}\n'
  fi
}
