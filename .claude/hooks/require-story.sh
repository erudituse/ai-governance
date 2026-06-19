#!/usr/bin/env bash
# PreToolUse(Edit|Write) — enforce requirements-first.
# Blocks editing a SOURCE file when no story/spec change is in progress. The
# agent unblocks itself the intended way: write/amend the story first (which
# creates an uncommitted change under docs/ , requirements/ or stories/), then
# the source edit is allowed.
#
# Fail-open by design: non-source files, missing jq, and non-git repos all pass.
set -uo pipefail
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=_governance-lib.sh
. "$DIR/_governance-lib.sh"

command -v jq >/dev/null 2>&1 || exit 0
input=$(cat)
fp=$(printf '%s' "$input" | jq -r '.tool_input.file_path // empty')

# Only gate real source files; everything else passes silently.
{ [ -z "$fp" ] || ! is_source_file "$fp"; } && exit 0

# A story/spec change already in the working set → allow.
spec_in_progress && exit 0

emit_decision deny \
"Requirements-first (CLAUDE.md §9 · guide 01): editing source is blocked because no story/spec change is in progress. FIRST write or amend a story under docs/ , requirements/ or stories/ — capture the what + why and testable acceptance criteria (and derive the test cases) — THEN make this code change. Once the story file is in the working tree, this edit is allowed automatically."
