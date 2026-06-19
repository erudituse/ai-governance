#!/usr/bin/env bash
#
# Portable SDLC *assurance* gates — mechanises the "How to verify" checks the
# scale guides cite, on top of the base playbook's governance-checks.sh.
# Read-only: nothing here mutates your repo. Exits non-zero if any gate fails,
# so it drops into a pre-merge run, a make target, or required CI.
#
# This is the audit tier: unlike the base script (advisory + local), these gates
# are meant to run as ENFORCED CI status checks (guide 07) — a bypassable gate is
# no audit evidence. Wire it where the author cannot skip it.
#
# Adopt by copying docs/governance/scale/ into your repo and editing CONFIG.
#
set -uo pipefail

# ====================== CONFIG — edit for your project ======================
# Words from a previous project that must NOT leak into the portable playbook.
# Replace with YOUR prior project's domain terms, client names, and identifiers.
PROJECT_TERMS="your-project-name|your-client|your-domain-term"

# Where your root governance file lives (must declare assurance tier + frameworks).
CLAUDE_MD="CLAUDE.md"

# Strings that prove Part 2 declares scope (edit to your wording).
SCOPE_MARKERS="assurance tier|in-scope framework|in scope:"

# Living-evidence registers that must exist and be reasonably fresh.
CONTROL_MATRIX="docs/governance/control-matrix.md"
WAIVER_REGISTER="docs/governance/waivers.md"

# Max age (days) before a "last reviewed:" date in the control matrix is stale.
MATRIX_MAX_AGE_DAYS=120
# ===========================================================================

SCALE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
REPO_ROOT="$(git rev-parse --show-toplevel 2>/dev/null || echo .)"
PASS=0; FAIL=0; SKIP=0
red()  { printf '\033[31m%s\033[0m\n' "$*"; }
grn()  { printf '\033[32m%s\033[0m\n' "$*"; }
yel()  { printf '\033[33m%s\033[0m\n' "$*"; }
ok()   { grn "  PASS  $*"; PASS=$((PASS+1)); }
bad()  { red "  FAIL  $*"; FAIL=$((FAIL+1)); }
skip() { yel "  SKIP  $*"; SKIP=$((SKIP+1)); }

echo "== SDLC assurance gates (scale tier) =="
echo "governance/scale: $SCALE_DIR"
echo

# --- Gate 1: de-projection (no prior-project terms in the scale playbook) ----
echo "[1] De-projection — scale playbook contains no prior-project identifiers"
hits=$(grep -riE "$PROJECT_TERMS" "$SCALE_DIR" --include='*.md' 2>/dev/null \
        | grep -vi '/checks/' || true)
if [ -z "$hits" ]; then ok "no project-specific terms in the scale guides"
else bad "project terms leaked into the scale playbook:"; echo "$hits" | sed 's/^/        /'; fi

# --- Gate 2: six-section contract + Hat on each scale guide ------------------
echo "[2] Format contract — each scale guide has the six sections + a Hat"
for f in "$SCALE_DIR"/[0-9][0-9]-*.md; do
  [ -e "$f" ] || continue
  n=$(grep -cE '^## (Principle|Why it matters|The rule|War story|How to verify|Adopt on a new project)' "$f")
  h=$(grep -cE '^\*\*Hat — ' "$f")
  if [ "$n" -ge 6 ] && [ "$h" -ge 1 ]; then ok "$(basename "$f") ($n sections, Hat present)"
  else bad "$(basename "$f"): $n/6 sections, Hat=$h (need 6 + a Hat)"; fi
done

# --- Gate 3: supporting artifacts present ------------------------------------
echo "[3] Artifacts — governance extension + crosswalk + evidence templates present"
[ -e "$SCALE_DIR/CLAUDE.md" ] \
  && ok "CLAUDE.md (audit-tier extension) present" \
  || bad "CLAUDE.md (audit-tier extension) missing"
[ -e "$SCALE_DIR/crosswalk/framework-crosswalk.md" ] \
  && ok "crosswalk/framework-crosswalk.md present" \
  || bad "crosswalk/framework-crosswalk.md missing"
for t in change-authorization.md access-review.md waiver.md control-matrix.md bcp-dr-plan.md vendor-assessment.md; do
  if [ -e "$SCALE_DIR/templates/$t" ]; then ok "templates/$t present"
  else bad "templates/$t missing"; fi
done

# --- Gate 4: scope declared in the root governance file ----------------------
echo "[4] Scope — Part 2 declares the assurance tier + in-scope frameworks"
if [ -e "$REPO_ROOT/$CLAUDE_MD" ]; then
  if grep -qiE "$SCOPE_MARKERS" "$REPO_ROOT/$CLAUDE_MD"; then ok "$CLAUDE_MD declares assurance scope"
  else bad "$CLAUDE_MD has no assurance-tier / in-scope-framework declaration (guide 06)"; fi
else skip "$CLAUDE_MD not found at repo root"; fi

# --- Gate 5: control matrix exists and is not stale -------------------------
echo "[5] Control matrix — exists, every control owned, reviewed recently"
if [ -e "$REPO_ROOT/$CONTROL_MATRIX" ]; then
  ok "$CONTROL_MATRIX present"
  # crude null-owner check: a table cell that is empty or 'TBD'/'TODO' in an owner column
  if grep -qiE '\|\s*(TBD|TODO|\?|)\s*\|.*\|.*cadence' "$REPO_ROOT/$CONTROL_MATRIX" 2>/dev/null; then
    yel "  note: possible empty owner cell — review the matrix manually"
  fi
  rev=$(grep -oiE 'last reviewed:?[[:space:]]*[0-9]{4}-[0-9]{2}-[0-9]{2}' "$REPO_ROOT/$CONTROL_MATRIX" | grep -oE '[0-9]{4}-[0-9]{2}-[0-9]{2}' | head -1 || true)
  if [ -z "$rev" ]; then bad "no 'last reviewed: YYYY-MM-DD' date in $CONTROL_MATRIX"
  else
    # portable date diff (GNU or BSD date)
    now=$(date +%s)
    then_ts=$(date -d "$rev" +%s 2>/dev/null || date -j -f "%Y-%m-%d" "$rev" +%s 2>/dev/null || echo "")
    if [ -z "$then_ts" ]; then skip "could not parse review date '$rev'"
    else
      age=$(( (now - then_ts) / 86400 ))
      if [ "$age" -le "$MATRIX_MAX_AGE_DAYS" ]; then ok "control matrix reviewed ${age}d ago (<= ${MATRIX_MAX_AGE_DAYS})"
      else bad "control matrix is stale: reviewed ${age}d ago (> ${MATRIX_MAX_AGE_DAYS})"; fi
    fi
  fi
else skip "$CONTROL_MATRIX not found — stand it up (templates/control-matrix.md)"; fi

# --- Gate 6: no expired-and-open waivers ------------------------------------
echo "[6] Waivers — none expired and still open"
if [ -e "$REPO_ROOT/$WAIVER_REGISTER" ]; then
  today=$(date +%Y-%m-%d)
  expired=$(grep -iE 'expiry:?[[:space:]]*[0-9]{4}-[0-9]{2}-[0-9]{2}' "$REPO_ROOT/$WAIVER_REGISTER" \
            | grep -oE '[0-9]{4}-[0-9]{2}-[0-9]{2}' \
            | awk -v t="$today" '$0 < t' || true)
  if [ -z "$expired" ]; then ok "no expired waiver dates found"
  else bad "expired waiver(s) — escalate or close (guide 13):"; echo "$expired" | sed 's/^/        /'; fi
else skip "$WAIVER_REGISTER not found — no waivers, or stand the register up"; fi

# --- Gate 7: SoD heuristic — no obvious self-approval in recent merges -------
echo "[7] Segregation of duties — recent merges have an approver (heuristic)"
if git -C "$REPO_ROOT" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  # This is only a smell test; real SoD evidence is your forge's PR approval records.
  unsigned=$(git -C "$REPO_ROOT" log --merges -n 20 --pretty='%h %an %s' 2>/dev/null | grep -iE 'Merge pull request|Merge branch' | head -5 || true)
  if [ -n "$unsigned" ]; then
    yel "  note: verify each merge below had a NON-AUTHOR approver in your forge (guide 06):"
    echo "$unsigned" | sed 's/^/        /'
    ok "merge history present — confirm approver≠author in PR records (config is the real control)"
  else skip "no merge commits found to sample"; fi
else skip "not a git repo"; fi

echo
echo "== summary: $PASS passed, $FAIL failed, $SKIP skipped =="
[ "$FAIL" -eq 0 ] && { grn "All assurance gates green."; exit 0; } || { red "Assurance gates failed — fix before merge."; exit 1; }
