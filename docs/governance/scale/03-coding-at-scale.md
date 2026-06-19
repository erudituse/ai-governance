# Coding at Scale
## Branch, review-by-others, and ownership — with AI authorship disclosed

*SDLC Governance Playbook for Scale · Guide 03 — extends base `../03-coding.md`*

**Hat — Senior Engineer:** write to the standing definition of "good" (base rule), and at scale work on branches, through pull requests reviewed by *someone else*, in code that has named owners.

---

## Principle

> **The standing definition of good code is unchanged (lean · backend-only logic ·
> least-privilege · no hardcoded secrets · non-regression · real-not-hallucinated). At
> scale, code reaches the main branch only through a *pull request reviewed by a human who
> is not its author* — and when the author is an AI, the disclosure and accountability are
> explicit.**

The base guide's `code-review.md` lens (hallucination · bloat · correctness) still runs.
This guide adds the *team mechanics* that make review-by-others real and auditable.

---

## Why it matters

**Likelihood: Constant, and higher with AI volume.** AI assistants generate large, fluent
diffs fast — which is exactly when an unreviewed hallucinated symbol, a duplicated helper,
or a secret slips into a shared branch. Self-review by the author (human or AI) catches
less precisely when it is *also* the author.

**Impact: From merge conflicts to an audit finding.** Direct commits to main, or
self-approved merges, are the textbook SOX/SOC 2 change-management failure: no independent
review, no separation between author and approver. The technical cost (broken main,
tangled history) is the small half; the audit cost (every change in the period is suspect)
is the large one.

---

## The rule(s)

1. **No direct commits to the protected branch.** All change lands via pull request into a
   branch protected by configuration: required review, required passing checks, linear or
   merge-queue history, no force-push.
2. **Review by a human who is not the author.** At least one approving review from a
   qualified person other than whoever (or whatever) wrote the code. **An AI cannot be the
   approving reviewer of code, and the human who *prompted* the AI is the author, not an
   independent reviewer.** (The control is guide 06; this is where it bites.)
3. **Ownership is explicit.** A `CODEOWNERS`-style map routes each path to its owning
   person/team; changes to owned code require that owner's review. This is how
   blast-radius review (guide 02) becomes automatic.
4. **AI authorship is disclosed and attributed.** A change written with AI assistance says
   so (commit trailer / PR label), and the merging human attests they reviewed it. The AI
   is a contributor; a named human is always accountable for what merges.
5. **The base code-quality lens runs on every PR.** `../templates/code-review.md`
   (every symbol resolves · no invented APIs · behaviour observed not assumed · no
   duplication · tests run) is the reviewer's checklist — doubly so for AI-authored diffs,
   where hallucinated symbols and silent reinvention are the characteristic failure modes.
6. **Small, single-purpose PRs.** One thing per PR (base deploy rule, pulled forward):
   bundling inflates review surface and hides the change being approved.

---

## War story

*Composite — a pattern auditors see repeatedly at this stage.*

A team enabled an AI assistant and velocity jumped — and so did a quiet class of defect:
the assistant re-implemented helpers that already existed three directories over, because
nothing made it search first and the author (who had prompted it) rubber-stamped its own
request. Reviews were "approved by" the same person who opened the PR. The audit found it
instantly: zero changes in the period had an independent approver. The fix was branch
protection requiring a *different* approver, `CODEOWNERS` routing, and the code-quality
lens applied to every AI diff — reuse-search included.

---

## How to verify

- **Branch protection on:** direct pushes to main are rejected; PRs require a non-author
  approval and green checks before merge (config, not honour system).
- **Independent approver sample:** a sampled merged PR shows an approver ≠ author (and ≠
  the AI / its prompter).
- **Ownership routing:** a change to owned code shows the owner's review.
- **AI disclosure:** AI-assisted PRs carry the disclosure and a human attestation.
- **Quality lens applied:** sampled PRs show the code-review checklist was run.

---

## Adopt on a new project

- [ ] Turn on branch protection: required non-author review + required checks + no force-push.
- [ ] Add a `CODEOWNERS` map routing paths to owners.
- [ ] Adopt the AI-authorship disclosure trailer/label + the human-attestation rule (guide 06).
- [ ] Make `../templates/code-review.md` the mandatory PR review checklist.
- [ ] Enforce one-thing-per-PR; reject bundled changes at review.

> Next guide: **04 — QA at scale.**
