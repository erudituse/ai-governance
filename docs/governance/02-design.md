# Design
## A dated decision log, and blast radius before you build

*SDLC Governance Playbook · Guide 02*

**Hat — Technical Lead / Architect:** choose the shape, record the decision, and map the blast radius before building.

---

## Principle

> **Before you change shared code, enumerate everything it can affect — and record
> the *why* of any architectural decision, dated.**

Design has two cheap, high-leverage artifacts: a **decision log** and a **blast-radius
assessment**. Both are written before the build, not reconstructed after a regression.

---

## Why it matters

**Likelihood: High for shared code.** Engines, schemas, types, and API contracts have
many consumers. The edit that looks like a one-liner in one file is the edit most
likely to break a screen you forgot existed.

**Impact: High and delayed.** A silent downstream break ships green and surfaces later
as "why is this report wrong?" By then the cause is several commits back. And without a
decision log, the next engineer **re-litigates** a settled choice — or worse, reverses
it without knowing why it was made.

---

## The rule(s)

1. **Blast-radius assessment, up front.** Any non-trivial change first enumerates what
   it can touch: shared code, every downstream view / report / export, dependent data
   flows, other environments, and the docs describing them.
2. **If you can't state the blast radius, the change is too big.** Decompose it. An
   inability to articulate the impact is the signal, not a nuisance.
3. **Dated decision log.** A change that introduces or alters architecture, a reusable
   pattern, or an interface contract gets a dated entry in the design doc *with its
   rationale*.
4. **Pure re-presentation may skip the design update** — but say so explicitly, so the
   skip is a decision, not an omission.
5. **Design observability in.** A feature's design names the signals it must emit — key
   events, error conditions, and at least one health metric — so its *silent* failure is
   detectable. *"How would we know this broke in production?"* is a design-time question,
   not a day-2 afterthought; you cannot alert (guide 05) on what was never instrumented.
6. **Threat-sketch a trust-boundary change.** Any feature crossing a trust boundary — a
   new actor, a new external input, a new privilege — gets a one-paragraph threat sketch
   (*who could abuse this, and what stops them*) **before** the input-form checklist
   (guide 06) is applied. Pentests find flaws after build; this finds them before.

---

## War story

*Drawn from a production application built on this model, just after its first production cutover.*

A change adjusted how one shared calculation engine produced a value — small, local,
"obviously safe." Nobody listed the consumers. That value, it turned out, fed a
data table, a summary tab, *and* a downstream calculation. The edit fixed the
first surface and silently skewed the other two.

The fix that stuck wasn't the code patch. It was making **blast-radius assessment a
design-time step**: before touching shared code, write down every consumer. If you
can't, the change is too large to do in one go. The discipline was added the same week
the app went to production — because production is exactly when "obviously safe" gets
expensive.

---

## How to verify

The control is a review gate, cheap to apply:

- **Shared-code diff check:** a change touching a shared schema / engine / contract must
  list its downstream consumers in the description. Absence blocks review.
- **Decision-log check:** an interface-contract change merges only with a dated decision
  entry in the design doc.
- **Decomposition smell test:** if the author can't name the blast radius in a sentence
  or two, send it back to be split — don't approve on faith.
- **Observability check:** a feature merges with its emitted signals named (events, error
  conditions, one health metric) — silent failure must be detectable.
- **Threat-sketch check:** a trust-boundary change carries its one-paragraph abuse +
  mitigation sketch; absence blocks review.

---

## Adopt on a new project

- [ ] Designate the **design doc** and its dated decision-log format (e.g. a D-series) — copy `templates/design-decision.md` as the per-decision skeleton.
- [ ] Make "list the downstream consumers" a required field for any shared-code change.
- [ ] Adopt the rule: *un-articulable blast radius ⇒ decompose.*
- [ ] Define what counts as "pure re-presentation" (the only exemption from a design entry).
- [ ] Make "name the signals this emits" and (for trust-boundary changes) a one-paragraph threat sketch required design-time fields.

> Next guide: **03 — Coding.**
