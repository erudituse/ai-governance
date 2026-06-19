# QA & Testing
## Catch regressions structurally — not by a user spotting a wrong number

*SDLC Governance Playbook · Guide 04*

**Hat — QA Engineer:** design tests that lock behaviour — green baseline, gold-master, cross-surface consistency, traceability.

---

## Principle

> **Testing is first-class at every step:** a green baseline before and after each
> change, a test for every new behaviour, gold-masters for numeric outputs, and a consistency
> test for any value shown in more than one place.

---

## Why it matters

**Likelihood: High wherever numbers flow.** Any non-trivial system derives the same
underlying value through more than one code path. Those paths drift unless something
forces them to agree.

**Impact: Trust, and it's immediate.** A user who sees two screens disagree about
*a number that matters to them* stops trusting the whole product in that instant — and
rightly so. Worse, a downstream calculation built on the wrong figure (e.g. a total
computed on a value that one screen says is zero and another says is large) compounds
the error
quietly.

---

## The rule(s)

1. **Green baseline, before and after.** Run the suite before a change to establish a
   baseline and after to prove no regression. The deliverable states *"before: X
   passing, after: X+N."*
2. **New behaviour needs a test.** A change that introduces behaviour without a test is
   incomplete — not "to be tested later."
3. **Gold-master for numeric outputs.** Engine / calculation changes preserve existing outputs
   unless the change *intends* to alter them; an intended diff is marked and documented.
4. **Cross-surface consistency.** Every value that appears on more than one
   surface is asserted equal (within tolerance) by an integration test. A new surface
   *extends* that test before it merges.
5. **Test traceability.** Keep a summary register of runs — before/after counts, scope,
   the story, and any flaky tests quarantined.

---

## War story

*Drawn from a production application built on this model.*

A user crossed a threshold that triggered a required action. One tab correctly showed a
large required amount. A second tab showed **zero**. And because a downstream calculation
read the second path, it produced **a result that was wrong by the full amount.**
Three surfaces, three different truths — found by the user, not the team.

Root cause: two code paths derived the same number and nobody enforced that they
agree. The permanent fix was a **cross-page consistency test** that runs the full
pipeline and asserts every multi-surface dollar value matches. The rule generalised:
*any number on more than one screen gets a consistency test before merge.*

---

## How to verify

- **New-surface check:** a new tab/report that renders an existing value merges only
  with a consistency-test contract added for it. Absence blocks review.
- **Baseline check:** the change set records before/after pass counts.
- **Gold-master check:** a calculation change either leaves outputs identical or carries a
  documented, intended diff — never an unexplained one.
- **Boundary fixtures:** new input handling is tested at min, max, off-by-one, oversized.

---

## Adopt on a new project

- [ ] Stand up the test harnesses **early** — both backend and frontend. (The frontend
      harness is the most commonly skipped, and the most commonly regretted.)
- [ ] Adopt "before: X, after: X+N" as the reporting format for every change.
- [ ] Build the cross-surface consistency test as soon as a value appears twice.
- [ ] Author test cases in the story at spec time, not after coding — see the *Test cases* section of `templates/story.md`.
- [ ] Start a test-traceability register on day one.

> Next guide: **05 — Deployment & Day-2.**
