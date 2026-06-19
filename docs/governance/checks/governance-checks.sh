#!/usr/bin/env bash
#
# Portable SDLC governance gates — the greppable subset of the playbook's
# "How to verify" checks. Read-only: nothing here mutates your repo. Exits
# non-zero if any gate fails, so it drops into a pre-commit hook, a make
# target, or a CI step. See ./README.md.
#
# SCOPE — what this script is and is NOT:
#   * Section A (self-lint) checks the PLAYBOOK's own docs are well-formed.
#     Only relevant when you are editing the governance docs themselves.
#   * Section B (governance gates) are the two project-level checks that NO
#     off-the-shelf tool does: requirements-first pairing, and honest story
#     close-out.
#   * Secret scanning and SAST (PII-in-logs, XSS sinks, eval, etc.) are NOT
#     here — they are done far better by gitleaks + semgrep, wired as required
#     CI checks. See ci.yml.sample and semgrep-governance.yml. A hand-rolled
#     regex is not the control; the real scanners are.
#
# Adopt by copying docs/governance/ into your repo and editing the CONFIG block.
#
set -uo pipefail

# ====================== CONFIG — edit for your project ======================
# Words from a previous project that must NOT leak into the portable playbook.
# Replace with YOUR prior project's domain terms, client names, and identifiers.
PROJECT_TERMS="your-project-name|your-client|your-domain-term"

# Extensions that count as "source" for the requirements-first reminder.
SOURCE_EXTS="py ts tsx js jsx go rb java rs"

# Path fragments where specs/requirements live; a staged change under any of
# these satisfies the requirements-first reminder.
SPEC_PATHS="docs/ requirements/ stories/"
# ===========================================================================

PLAYBOOK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PASS=0; FAIL=0; SKIP=0
red()   { printf '\033[31m%s\033[0m\n' "$*"; }
grn()   { printf '\033[32m%s\033[0m\n' "$*"; }
yel()   { printf '\033[33m%s\033[0m\n' "$*"; }
ok()    { grn "  PASS  $*"; PASS=$((PASS+1)); }
bad()   { red "  FAIL  $*"; FAIL=$((FAIL+1)); }
skip()  { yel "  SKIP  $*"; SKIP=$((SKIP+1)); }

in_git() { git rev-parse --is-inside-work-tree >/dev/null 2>&1; }

echo "== SDLC governance gates =="
echo "governance: $PLAYBOOK_DIR"
echo
echo "Secret + SAST scanning live in CI (gitleaks + semgrep), not here — see ci.yml.sample."
echo

# ============================================================================
# SECTION A — Playbook self-lint (only relevant when editing the playbook docs)
# ============================================================================
echo "--- A. Playbook self-lint (the governance docs are well-formed) ---"

# --- A1: playbook is de-projected (no prior-project terms) ------------------
echo "[A1] De-projection — playbook contains no prior-project identifiers"
hits=$(grep -riE "$PROJECT_TERMS" "$PLAYBOOK_DIR" --include='*.md' 2>/dev/null \
        | grep -vi '/checks/' || true)
if [ -z "$hits" ]; then ok "no project-specific terms in guides"
else bad "project terms leaked into the playbook:"; echo "$hits" | sed 's/^/        /'; fi

# --- A2: every guide follows the six-section contract -----------------------
echo "[A2] Format contract — each guide has the six sections"
for f in "$PLAYBOOK_DIR"/0*.md; do
  [ -e "$f" ] || continue
  n=$(grep -cE '^## (Principle|Why it matters|The rule|War story|How to verify|Adopt on a new project)' "$f")
  if [ "$n" -ge 6 ]; then ok "$(basename "$f") ($n section headings)"
  else bad "$(basename "$f") has only $n/6 contract sections"; fi
done

# --- A3: every guide declares the phase Hat (the role to wear) --------------
echo "[A3] Hat — each guide names the role to wear for its phase"
for f in "$PLAYBOOK_DIR"/0*.md; do
  [ -e "$f" ] || continue
  if grep -qE '^\*\*Hat — ' "$f"; then ok "$(basename "$f") declares a Hat"
  else bad "$(basename "$f") is missing its **Hat — …** standfirst"; fi
done

# --- A4: every guide has --- section breaks ---------------------------------
echo "[A4] Section structure — each guide is split by --- section breaks"
for f in "$PLAYBOOK_DIR"/0*.md; do
  [ -e "$f" ] || continue
  n=$(grep -c '^---$' "$f")
  if [ "$n" -ge 3 ]; then ok "$(basename "$f") ($n section breaks)"
  else bad "$(basename "$f") has too few section breaks ($n)"; fi
done

# --- A5: fill-in templates are present --------------------------------------
echo "[A5] Templates — phase skeletons present"
for t in story.md design-decision.md code-review.md change-checklist.md; do
  if [ -e "$PLAYBOOK_DIR/templates/$t" ]; then ok "templates/$t present"
  else bad "templates/$t missing"; fi
done

echo
# ============================================================================
# SECTION B — Governance gates (project-level; no off-the-shelf equivalent)
# ============================================================================
echo "--- B. Governance gates (project changes; what scanners can't check) ---"

# --- B1: requirements-first — source touched ⇒ spec touched -----------------
# Heuristic, not proof: it cannot know a doc *describes* a given source change.
# It catches the common "code, no story at all" case; a reviewer still confirms
# the spec actually documents the change.
echo "[B1] Requirements-first (heuristic) — staged source change has an accompanying spec change"
if in_git; then
  staged=$(git diff --cached --name-only 2>/dev/null || true)
  if [ -z "$staged" ]; then skip "no staged changes to inspect"
  else
    src_re=$(printf '%s' "$SOURCE_EXTS" | tr ' ' '|')
    src_changed=$(printf '%s\n' "$staged" | grep -E "\.($src_re)$" || true)
    spec_re=$(printf '%s' "$SPEC_PATHS" | tr ' ' '|' | sed 's/\//\\\//g')
    spec_changed=$(printf '%s\n' "$staged" | grep -E "$spec_re" || true)
    if [ -z "$src_changed" ]; then ok "no source files staged"
    elif [ -n "$spec_changed" ]; then ok "source change has an accompanying spec/doc change (reviewer confirms it documents the change)"
    else bad "source staged with no spec/doc change — write the story first:"; printf '%s\n' "$src_changed" | sed 's/^/        /'; fi
  fi
else skip "not a git repo"; fi

# --- B2: story close-out — shipped stories cite resolvable code refs ---------
# Catches the "AI said it was done, but the ticket never matched the code"
# failure: a story in a terminal build status must point at file:symbol /
# file:line that ACTUALLY exist — file present AND the symbol/line present.
echo "[B2] Close-out — shipped/implemented stories cite resolvable code references"
root="$(in_git && git rev-parse --show-toplevel 2>/dev/null || echo .)"
story_files=$(grep -rilE '^status:[[:space:]]*(implemented|partially-shipped|shipped)' \
              $SPEC_PATHS --include='*.md' 2>/dev/null || true)
if [ -z "$story_files" ]; then skip "no shipped/implemented story files found"
else
  miss=""
  for sf in $story_files; do
    # code references look like `path/to/file.ext::symbol` or `path/to/file.ext:line`
    refs=$(grep -oE '`[A-Za-z0-9_./-]+\.[A-Za-z0-9]+(::|:)[A-Za-z0-9_]+`' "$sf" 2>/dev/null \
            | tr -d '`' | sort -u || true)
    for ref in $refs; do
      if printf '%s' "$ref" | grep -q '::'; then
        path="${ref%%::*}"; sym="${ref##*::}"
        locator="symbol $sym"
      else
        path="${ref%:*}"; sym="${ref##*:}"
        locator="line $sym"
      fi
      # resolve the file (repo-root-relative or cwd-relative)
      file=""
      [ -e "$root/$path" ] && file="$root/$path"
      [ -z "$file" ] && [ -e "$path" ] && file="$path"
      if [ -z "$file" ]; then
        miss="$miss
        $sf -> missing file: $path"
      elif printf '%s' "$ref" | grep -q '::'; then
        grep -qw "$sym" "$file" 2>/dev/null || miss="$miss
        $sf -> $path exists but $locator not found in it"
      else
        # line ref: file must have at least that many lines
        total=$(wc -l < "$file" 2>/dev/null | tr -d ' ')
        if ! printf '%s' "$sym" | grep -qE '^[0-9]+$' || [ "${total:-0}" -lt "$sym" ]; then
          miss="$miss
        $sf -> $path exists but $locator is out of range"
        fi
      fi
    done
  done
  if [ -z "$miss" ]; then ok "shipped stories' code references resolve to real files + symbols"
  else bad "shipped story cites code that doesn't resolve (stale close-out):"; printf '%s\n' "$miss"; fi
fi

echo
echo "== summary: $PASS passed, $FAIL failed, $SKIP skipped =="
echo "Reminder: secret + SAST enforcement is gitleaks + semgrep in CI, not this script."
[ "$FAIL" -eq 0 ] && { grn "All gates green."; exit 0; } || { red "Gates failed — fix before merge."; exit 1; }
