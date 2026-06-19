<!-- Read this first — it explains how the base operating model changes when humans share the work. -->

# The Team Operating Model
## The same loop — now run by several people, not one session

*SDLC Governance Playbook for Scale · Guide 00 — extends base `../00-operating-model.md`*

**Hat — Governance Lead:** own the two-tier policy and the incident→rule→gate→memory loop across a team; give every control a named owner and every rule a human path in.

---

## Principle

> **The base operating model does not change shape when you scale — you add humans to
> it. Every control gains a *named owner*, every rule a *human review step*, and every
> "I remember" becomes an *artifact someone else can read*.**

The base playbook's loop — `incident → root cause → dated rule → cheap local gate →
memory` — is still the engine. What changes is that "memory" can no longer be one
session's context: it must be **institutional** memory a second person can pick up cold.

---

## Why it matters

**Likelihood: Certain the moment a second person joins.** Solo, the controls live in one
head and one session. The instant work is handed between people, the unwritten control is
the one that silently lapses — and an AI assistant joining a *team* repo inherits no one's
memory, only what is written down.

**Impact: The control you thought you had wasn't there.** It surfaces at the worst
moment — an incident or an audit — as "the rule was in Maria's head, and Maria's on
leave," or "the AI didn't follow the convention because the convention was never in the
repo." Unowned controls are unrun controls.

---

## The rule(s)

1. **Every control has one named owner.** Not a team — a person, recorded in the control
   matrix (`templates/control-matrix.md`). The owner is accountable that the control
   operates and that its evidence exists. Ownership can transfer; it can never be null.
2. **Roles are explicit, and shift by phase.** Wear the hat the work calls for (the base
   playbook's phase→hat map); at team scale the hats are *different people* with handoffs
   between them, so name who holds each for a given change.
3. **The loop gains a human step.** A new rule is *proposed* (PR or retro), *agreed*,
   *dated*, and *added* — by people, not by one session deciding unilaterally. Graduation
   into the shared spine needs the named spine owner's sign-off (base guide 07).
4. **Memory becomes institutional.** Per-session memory generalises to: the dated rules,
   the living registers, an onboarding doc, and the templates. A new teammate — or a new
   AI session — becomes productive from the repo alone, not from asking a person.
5. **The AI is a team member under the same rules, with one carve-out.** It follows the
   written process exactly; it is **never** the approver of its own output (guide 06). Its
   authorship is disclosed and attributed to the human who merges it.
6. **Onboarding is a control.** A documented "first day" path — read order, access
   request, training/acceptable-use attestation (guide 12) — so every joiner starts from
   the standard, not from tribal knowledge.

---

## War story

*Composite — a pattern auditors see repeatedly at this stage.*

A team scaled from two engineers to eight. The conventions that had lived in standups —
how a story is sized, when the design doc is required, who may approve a deploy — were
never written, because for two people they never needed to be. The new hires (and the AI
assistant they all shared) each guessed differently. Within a quarter the same class of
defect appeared three times, each "fixed" a different way, because no single owner held
the rule that would have caught it. The repair was not a tool; it was assigning every
control an owner and writing the loop's human step down — propose, agree, date, add.

---

## How to verify

- **Ownership completeness:** every row in the control matrix names a person; zero nulls.
- **Onboarding dry-run:** a new teammate (or a fresh AI session) can reach "first
  productive change" using only the repo — no private knowledge required.
- **Loop honesty:** sampled recent rules show a date, the incident, *and* who agreed them.
- **RACI exists:** for any in-scope change type, you can name who is Responsible,
  Accountable, Consulted, Informed (`templates/control-matrix.md`).

---

## Adopt on a new project

- [ ] Adopt the base operating model first; this layer assumes it.
- [ ] Stand up the **control matrix** — one named owner per control, day one.
- [ ] Write the **onboarding doc** (read order, access, attestations) before the second hire.
- [ ] Define the **human loop step** (propose → agree → date → add) and who signs spine changes.
- [ ] Record the **assurance tier + in-scope frameworks** in Part 2 of `CLAUDE.md` (see guide 06).

> Next guide: **01 — Requirements at scale.**
