<!-- Read this guide first — it explains why every other guide is shaped the way it is. -->

# The Operating Model
## The model a project starts on — and the loop that keeps it alive

*SDLC Governance Playbook · Guide 00 — read me first*

**Hat — Governance Lead:** own the two-tier policy and the incident→rule→gate→memory loop; keep the shared spine lean and promote proven rules deliberately.

---

## Principle

> **A project starts on this governance model and builds with it — two tiers, one
> loop, living registers — strengthening the model as it goes, not retrofitting it
> after the first outage.**

The model is the foundation you adopt on day one. Every rule in it earned its place 
on a real project, so you inherit a model that is grounded in practice.

---

## Why it matters

**Likelihood: Certain.** Every project accumulates rules. The only question is whether
they accumulate *with structure* or as a growing pile no one can follow.

**Impact: Compounding, in both directions.**

- Done well, governance **compounds** — each project inherits the last one's hard-won
  wisdom and adds its own.
- Done badly, it **dilutes** — the rulebook grows until it is too long to read, so
  adherence to any single line quietly drops to zero. A rule nobody follows is worse
  than no rule, because it creates the illusion of control.

---

## The rule(s)

**1. Two-tier policy.** A non-negotiable, project-agnostic **Part 1** (the org
standard) plus a project-specific **Part 2**. Part 2 may *add* restrictions; it may
**never relax** Part 1. Conflicts resolve to the most restrictive control.

**2. The incident → rule loop.** This is the engine:

> `incident → root cause → dated rule → cheap local gate → memory entry`

Every rule carries its date and the incident it answers, so it reads as evidence.

**3. Registers over one-time docs.** Living registers (security audit, requirements
traceability, test traceability, privacy) beat a doc written once and forgotten. Code
is authoritative — a stale claim in a doc is itself a defect.

**4. A graduation step.** A Part 2 rule that proves general is *promoted* into Part 1
at a deliberate version bump.

**5. Prune to fight dilution.** The shared tier is periodically stripped of
project-specific trivia so the spine stays lean enough to actually be read.

---

## War story

*Drawn from a production application built on this model.*

The project started on the two-tier model: the org spine adopted as-is, a thin project
layer filled in on day one. So when the first production incident hit — a number that
disagreed between two screens — there was no scramble to invent a process. The loop was
already there: root-cause it, write a dated rule, add a one-line gate. The new rule
slotted into the project layer; the spine stayed untouched and lean.

Contrast a team that starts with *no* model. The same incident becomes a one-off — a
postmortem, a wiki page nobody re-reads, a fix the next sprint forgets. Same incident,
no machine to turn it into a durable control.

That is the whole point of starting on a model rather than accreting one: the
difference between a rule that *sticks* and a lesson that evaporates. And because the
spine is kept lean and de-projected by design, the next project can start on it too —
without inheriting this one's trivia.

---

## How to verify

The operating model is structural, so verification is "do the artifacts exist and are
they honest?":

- **Two-tier check:** diff Part 2 against Part 1 — no clause weakens a Part 1 control.
- **Dated-rule check:** sample rules carry a date + rationale; undated rules get flagged.
- **De-projection check:** the Part 1 a project starts on contains no other project's
  identifiers (grep for any project's domain terms → empty).
- **Register currency:** each living register has a "last reviewed" date that isn't stale.

---

## Adopt on a new project

- [ ] Starf from this clean governance repo.
- [ ] Create Part 2 as a fill-in skeleton — additive only, never relaxing Part 1.
- [ ] Adopt the incident → rule loop: every rule gets a date + the incident it answers.
- [ ] Stand up the living registers early (security, requirements/test traceability, privacy).
- [ ] Adopt the fill-in templates (`templates/story.md`, `templates/change-checklist.md`) so stories and changes start from the standard, not from scratch.
- [ ] Write down the graduation step so a proven local rule has a path into the org standard.

> **An honest caveat:** this model grew out of real production practice, but its
> track record is still limited to a few projects — what feels universal here is not yet *proven* universal.
> The first time a fresh project starts on it is the real test, and that test should
> itself become a lesson. Those lessons should make its way back to this base governance model.

> Next guide: **01 — Requirements.**
