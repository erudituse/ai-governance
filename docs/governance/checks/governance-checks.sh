#!/usr/bin/env bash
#
# Portable SDLC governance gates — mechanises the "How to verify" checks the
# playbook guides cite. Read-only: nothing here mutates your repo. Exits non-zero
# if any gate fails, so it drops straight into a pre-commit hook, a make target,
# or a manual pre-merge run. See ./README.md.
#
# Adopt by copying docs/governance/ into your repo and editing the CONFIG block.
#
set -uo pipefail

# ====================== CONFIG — edit for your project ======================
# Words from a previous project that must NOT leak into the portable playbook.
# Replace with YOUR prior project's domain terms, client names, and identifiers.
PROJECT_TERMS="your-project-name|your-client|your-domain-term"

# Extensions that count as "source" for the requirements-first (spec-with-source) gate.
SOURCE_EXTS="py ts tsx js jsx go rb java rs"

# Path fragments where specs/requirements live; a staged change under any of
# these satisfies the "source touched ⇒ spec touched" gate.
SPEC_PATHS="docs/ requirements/ stories/"

# Secret-ish patterns to flag in a diff (extend for your stack).
SECRET_REGEX='AKIA[0-9A-Z]{16}|BEGIN [A-Z ]*PRIVATE KEY|postgres(ql)?://[^[:space:]]*:[^[:space:]]*@|(password|secret|api_key|token)[[:space:]]*[:=][[:space:]]*["'"'"'][^"'"'"']{6,}'

# Field names that must never appear in a logging call (your PII fields).
PII_FIELDS="sin ssn email phone address dob password"
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

# --- Gate 1: playbook is de-projected (no prior-project terms) --------------
echo "[1] De-projection — playbook contains no prior-project identifiers"
hits=$(grep -riE "$PROJECT_TERMS" "$PLAYBOOK_DIR" --include='*.md' 2>/dev/null \
        | grep -vi '/checks/' || true)
if [ -z "$hits" ]; then ok "no project-specific terms in guides"
else bad "project terms leaked into the playbook:"; echo "$hits" | sed 's/^/        /'; fi

# --- Gate 2: every guide follows the six-section contract --------------------
echo "[2] Format contract — each guide has the six sections"
for f in "$PLAYBOOK_DIR"/0*.md; do
  [ -e "$f" ] || continue
  n=$(grep -cE '^## (Principle|Why it matters|The rule|War story|How to verify|Adopt on a new project)' "$f")
  if [ "$n" -ge 6 ]; then ok "$(basename "$f") ($n section headings)"
  else bad "$(basename "$f") has only $n/6 contract sections"; fi
done

# --- Gate 2b: every guide declares the phase Hat (the role to wear) ----------
echo "[2b] Hat — each guide names the role to wear for its phase"
for f in "$PLAYBOOK_DIR"/0*.md; do
  [ -e "$f" ] || continue
  if grep -qE '^\*\*Hat — ' "$f"; then ok "$(basename "$f") declares a Hat"
  else bad "$(basename "$f") is missing its **Hat — …** standfirst"; fi
done

# --- Gate 3: every guide has --- section breaks -----------------------------
echo "[3] Section structure — each guide is split by --- section breaks"
for f in "$PLAYBOOK_DIR"/0*.md; do
  [ -e "$f" ] || continue
  n=$(grep -c '^---$' "$f")
  if [ "$n" -ge 3 ]; then ok "$(basename "$f") ($n section breaks)"
  else bad "$(basename "$f") has too few section breaks ($n)"; fi
done

# --- Gate 4: requirements-first — source touched ⇒ spec touched -------------
echo "[4] Requirements-first — staged source change is accompanied by a spec change"
if in_git; then
  staged=$(git diff --cached --name-only 2>/dev/null || true)
  if [ -z "$staged" ]; then skip "no staged changes to inspect"
  else
    src_re=$(printf '%s' "$SOURCE_EXTS" | tr ' ' '|')
    src_changed=$(printf '%s\n' "$staged" | grep -E "\.($src_re)$" || true)
    spec_re=$(printf '%s' "$SPEC_PATHS" | tr ' ' '|' | sed 's/\//\\\//g')
    spec_changed=$(printf '%s\n' "$staged" | grep -E "$spec_re" || true)
    if [ -z "$src_changed" ]; then ok "no source files staged"
    elif [ -n "$spec_changed" ]; then ok "source change has an accompanying spec/doc change"
    else bad "source staged with no spec/doc change — write the story first:"; printf '%s\n' "$src_changed" | sed 's/^/        /'; fi
  fi
else skip "not a git repo"; fi

# --- Gate 5: no secrets in the staged diff ----------------------------------
echo "[5] Secrets — staged diff carries no inline credentials"
if in_git; then
  diff=$(git diff --cached 2>/dev/null || true)
  if [ -z "$diff" ]; then skip "no staged changes to inspect"
  else
    leak=$(printf '%s\n' "$diff" | grep -E '^\+' | grep -nEi "$SECRET_REGEX" || true)
    if [ -z "$leak" ]; then ok "no secret-like strings added"
    else bad "possible secret(s) added to the diff:"; printf '%s\n' "$leak" | sed 's/^/        /'; fi
  fi
else skip "not a git repo"; fi

# --- Gate 6: no PII field names inside logging calls -------------------------
echo "[6] Privacy — logging calls reference no raw PII field names"
# word-boundaried so e.g. "sin" does not match inside "using"
pii_re=$(printf '%s' "$PII_FIELDS" | tr ' ' '|')
scan_root="$(in_git && git rev-parse --show-toplevel 2>/dev/null || echo .)"
log_hits=$(grep -rnEi "(log|logger|logging)\.[a-z]+\(.*[^[:alpha:]]($pii_re)[^[:alpha:]]" "$scan_root" \
            --include='*.py' --include='*.ts' --include='*.tsx' 2>/dev/null \
            | grep -viE '/(node_modules|\.venv|venv|dist|build|docs)/' || true)
if [ -z "$log_hits" ]; then ok "no PII field names in logging calls"
else bad "PII field name inside a logging call:"; printf '%s\n' "$log_hits" | sed 's/^/        /'; fi

# --- Gate 7: fill-in templates are present ----------------------------------
echo "[7] Templates — phase skeletons present"
for t in story.md design-decision.md code-review.md change-checklist.md; do
  if [ -e "$PLAYBOOK_DIR/templates/$t" ]; then ok "templates/$t present"
  else bad "templates/$t missing"; fi
done

# --- Gate 8: story close-out — shipped stories cite resolvable code refs -----
echo "[8] Close-out — shipped/implemented stories cite resolvable code references"
# Catches the "AI said it was done, but the ticket never matched the code" failure:
# a story in a terminal build status must point at file:symbol that actually exist.
root="$(in_git && git rev-parse --show-toplevel 2>/dev/null || echo .)"
story_files=$(grep -rilE '^status:[[:space:]]*(implemented|partially-shipped|shipped)' \
              $SPEC_PATHS --include='*.md' 2>/dev/null || true)
if [ -z "$story_files" ]; then skip "no shipped/implemented story files found"
else
  miss=""
  for sf in $story_files; do
    # code references look like `path/to/file.ext::symbol` or `path/to/file.ext:line`
    refs=$(grep -oE '`[A-Za-z0-9_./-]+\.[A-Za-z0-9]+(::|:)[A-Za-z0-9_]+`' "$sf" 2>/dev/null \
            | tr -d '`' | sed -E 's/(::|:)[A-Za-z0-9_]+$//' | sort -u || true)
    for r in $refs; do
      [ -e "$root/$r" ] || [ -e "$r" ] || miss="$miss
        $sf -> missing code ref: $r"
    done
  done
  if [ -z "$miss" ]; then ok "shipped stories' code references resolve to real files"
  else bad "shipped story cites code that doesn't exist (stale close-out):"; printf '%s\n' "$miss"; fi
fi

echo
echo "== summary: $PASS passed, $FAIL failed, $SKIP skipped =="
[ "$FAIL" -eq 0 ] && { grn "All gates green."; exit 0; } || { red "Gates failed — fix before merge."; exit 1; }
