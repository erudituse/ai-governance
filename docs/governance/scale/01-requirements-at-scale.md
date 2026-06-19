# Requirements at Scale
## A shared backlog with stable IDs, authorized before build

*SDLC Governance Playbook for Scale · Guide 01 — extends base `../01-requirements.md`*

**Hat — Product Manager / Business Analyst:** own the shared backlog, keep IDs stable, and get each story *authorized* by an accountable owner before it enters build.

---

## Principle

> **Documentation is still the spec (base rule, unchanged). At scale the spec also
> becomes a *shared, governed* artifact: stable IDs that survive many authors, and an
> explicit *authorization* before a story is built.**

The base playbook already says: requirements first, testable acceptance criteria, tests
derived at spec time, approval ≠ skip the spec. None of that changes. This guide adds
only what a *team* needs on top.

---

## Why it matters

**Likelihood: High once many people write stories.** Independent authors renumber, reuse
IDs, and duplicate work that already has a story somewhere. Traceability — the backbone of
every audit — breaks the moment an ID is reused or a counter is renumbered.

**Impact: Lost traceability and unauthorized scope.** SOX and SOC 2 want every change to
trace to an authorized request; an internal auditor pulls a sample of changes and asks
*"show me the approved story this implements."* No stable ID, or no authorization record,
is a finding — and silent scope creep (work with no story) is the same finding twice.

---

## The rule(s)

1. **One shared backlog, one ID scheme.** `Feature → Epic → Story → Task` with the stable
   IDs from `../templates/story.md`. **Never renumber; never reuse a counter** —
   orphan, deprecate, or supersede, but the number is permanent.
2. **Stories are authorized before build.** Beyond "approval approves the decision" (base
   rule), at scale that approval is *recorded*: a named product/business owner marks the
   story ready-for-build, dated. Build with no authorized story is out of process.
3. **Backlog refinement is a shared step.** Stories are refined with the people who will
   build and test them, so acceptance criteria are agreed, not handed down — and the AI
   reads the agreed criteria, not a half-written stub.
4. **Cross-team stories declare their dependency.** A story whose delivery depends on
   another team names the dependency and the interface it relies on (links to the design
   contract — guide 02).
5. **The traceability register is forward *and* reverse.** Story → tests/code, and
   code/tests → story. The reverse index is the most-forgotten and the one auditors test.

---

## War story

*Composite — a pattern auditors see repeatedly at this stage.*

Two squads kept their own story numbers. Both reached `US-101`. A release note referenced
"US-101 — done"; the auditor pulling evidence found *two* US-101s, one shipped and one
abandoned, and could no longer prove which change the deploy implemented. Nothing was
technically broken — but the audit trail had collapsed, and rebuilding it cost more than
the feature. The fix was a single backlog with globally unique, never-reused IDs and a
recorded authorization per story.

---

## How to verify

- **ID uniqueness:** no ID appears twice across the backlog; counters are never reused.
- **Authorization sample:** a sampled in-build story has a dated ready-for-build sign-off
  by the accountable owner.
- **Traceability both ways:** a sampled story resolves to its tests/code *and* a sampled
  changed file resolves back to a story.
- **No orphan work:** a sampled merged change names the authorized story it implements.

---

## Adopt on a new project

- [ ] Declare one shared backlog and the single ID scheme; ban renumbering in writing.
- [ ] Add an **authorization** field/sign-off to the story template; require it before build.
- [ ] Stand up the forward **and** reverse traceability register on day one.
- [ ] Define the refinement step and who must be in it (build + test + product).
- [ ] Require cross-team stories to name their dependency + interface contract.

> Next guide: **02 — Design at scale.**
