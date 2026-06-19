# Requirements
## Documentation is the spec — never code before docs

*SDLC Governance Playbook · Guide 01*

**Hat — Product Manager:** define the *what* and *why* — scope and testable acceptance criteria — before any code is written.

---

## Principle

> **The specification is written before the code, and the code conforms to it —
> not the other way around.**

Documentation is the *first* action of any change, however small. It is not a
follow-up written to match whatever got built, and it is not something to ask
permission for.

---

## Why it matters

**Likelihood: High.** The pull to start at code is strongest on the changes that feel
smallest — "it's a one-liner, the spec is overkill." That feeling is wrong precisely
when it's most convincing, so the failure recurs constantly without a hard rule.

**Impact: High, and quiet.** When code ships without a spec:

- There is **nothing to test against** — "correct" is undefined, so bugs are
  indistinguishable from intent.
- The spec gets **back-filled to match the code**, which means it can never catch the
  code being wrong. The audit trail certifies the mistake.
- The next person (or the same person months later) **re-derives intent from the
  feature name** — and gets it wrong, because names are lossy.

A missing spec is not a missing document. It is a missing definition of *correct*.

---

## The rule(s)

Adopt these verbatim. They are ordered; do not start in the middle.

1. **Requirements first.** Every change begins by writing or amending a story / ticket
   with the *what* and the *why*, **before** any edit to source.
2. **Acceptance criteria are testable.** Each criterion is stated so a reader can
   derive a pass/fail check from it. "Works well" is not a criterion; "rejects inputs
   over N characters with a 422" is.
3. **Tests come from the criteria, at spec time.** Derive the test cases when you
   write the story, not after the code exists.
4. **Approval approves the decision, not the shortcut.** "ok", "go", "let's do it"
   green-lights *the direction* — never a licence to skip the spec.
5. **A discovered gap sends you back to the spec.** If implementation reveals the spec
   missed something, amend the spec first, then continue coding.
6. **Consolidate, don't accumulate — stories are history, requirements are current
   truth.** The story log is append-only: you *close* a story by status (`shipped`,
   `cancelled`, `superseded` with a pointer to its successor), never by deleting or
   renumbering it. The engineering source-of-truth is the opposite — it states *current*
   behaviour and is rewritten in place, so two contradictory "live" specs never coexist.
   A superseded need flips the origin story's status and is folded into the requirement,
   not stacked as a second active story. History survives in the IDs + status; the working
   set (`proposed` / `planned` / `partially-shipped`) stays lean enough to actually read.
7. **Close the loop on the *origin* story — truthfully, against the code.** When work
   ships, the story that defined it is updated to match *what was actually built*: every
   acceptance criterion annotated with its real test / `file:line` (or `(no automated
   coverage)`), every divergence from the spec recorded **in that story**, status moved to
   reflect reality. A follow-on change either amends the origin story or opens a new one
   that **links back and flips the origin's status** — never a silent new ticket that
   leaves the original stale. "Done" is true only when the acceptance-criteria → test →
   code links resolve. An assistant reporting "doc updated" or "built to spec" is making a
   *maker's claim, not evidence* — the maker never certifies its own work — so verify it
   against the code before trusting it, or the next reader (you, weeks later) re-derives
   intent by hunting through the source.

---

## War story

*Drawn from a production application built on this model.*

A change looked trivial — a single value surfaced on one more screen. The engineer
heard "ok, go" and read it as permission to just write the code. No story, no
acceptance criteria.

It shipped. Weeks later a reviewer asked the only question that matters: *"How do we
know this is right?"* There was no answer — nothing had ever defined what "right" was.
Reconstructing intent from the feature name produced a *different* answer than the one
in the original engineer's head. The two had quietly disagreed in production the whole
time.

The fix wasn't a code patch. It was promoting **requirements-first** from a habit to a
non-negotiable rule: documentation is the specification the code must conform to, and
it is the first action of every change — no exceptions for "small."

---

## How to verify

The control is a *process*, so the check is a change-set review, not a runtime test —
but it's cheap and mechanical:

- **Diff check:** a change set that touches source must contain a new or amended spec
  in the *same* change set. Source-only, spec-never is a defect, caught at review.
- **Criteria-to-test audit:** any story marked done must have every acceptance
  criterion map to a real test — or be explicitly tagged "(no automated coverage)" so
  the gap is visible, not silent.
- **Close-out check:** a story marked `implemented` / `shipped` must *resolve* — its
  `Code references` point to `file:symbol` that actually exist, and each acceptance
  criterion carries a test link or an explicit no-coverage tag. A shipped story whose code
  references don't resolve is a stale close-out — caught here at review, not by
  code-archaeology weeks later. (Mechanised as a gate in `checks/`.)

If your tooling supports it, make the diff check a pre-commit or PR gate. The gate is
what stops the rule from eroding the first time a change "feels too small to bother."

---

## Adopt on a new project

A 60-second port. Tick each box on day one:

- [ ] Pick the artifact that holds specs (issue tracker, `docs/requirements/`, story files) — and declare it authoritative.
- [ ] Adopt the story template — copy `templates/story.md` and fill its skeleton (*what + why*, scope, **testable** acceptance criteria, and the test cases up front).
- [ ] Establish the rule in writing: *documentation is the first action; approval ≠ skip the spec.*
- [ ] Add the change-set review check: source touched ⇒ spec touched.
- [ ] Decide where tests are derived from criteria, and when (answer: at spec time).
- [ ] Adopt the consolidate-don't-accumulate rule: close stories by status (never delete/renumber); keep requirements as current truth, rewritten in place.
- [ ] Adopt the close-out rule: on ship, update the *origin* story to match the code (AC ↔ test ↔ `file:line`), record divergences, link follow-ons back — and verify "done" against code, never on the assistant's word.

> Next guide: **02 — Design.** Once *what* is specified, design assesses *blast radius*
> and records the decision before a line is built.
