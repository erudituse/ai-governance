# Coding
## A standing definition of "good" — applied from line one

*SDLC Governance Playbook · Guide 03*

**Hat — Senior Engineer:** write lean, backend-only, least-privilege, secure-by-default code that breaks nothing already working.

---

## Principle

> **Quality and security are designed in, not bolted on in review.** A small set of
> always-on rules defines "good code" so you are not re-deciding fundamentals per task.

---

## Why it matters

**Likelihood: Constant.** Every change is an opportunity to leak a secret, put a rule
in the wrong layer, or add a duplicate. Without a standing bar, each engineer (and each
tired hour) re-negotiates the basics.

**Impact: Ranges from tech-debt to breach.** Business logic in the frontend means a
number can be recomputed two ways and disagree. A hardcoded secret is a credential
leak the moment the repo is shared. Dead and duplicated code is the slow tax that makes
every future change riskier.

---

## The rule(s)

1. **Lean — reuse over reinvent.** No redundant, duplicate, or dead code; no needless
   files. **Before adding a function, search for one that already does this — or part of
   it — and extend or reuse it.** A new function that fully *or partially* replicates an
   existing process is duplication even when the code is written differently — and it's
   the silent kind, because nothing flags it. Consolidate shared logic rather than
   growing a parallel path; flag duplication you find next to your change instead of
   adding to it.
2. **Backend-only business logic.** The frontend is UI/UX only. Rules, calculations,
   and access decisions live server-side. The frontend *renders* the engine's output;
   it never re-derives it.
3. **Least privilege, default-deny.** Every new endpoint, query, and integration
   exposes only what is strictly necessary. Authorization grants access explicitly —
   it never assumes it.
4. **No hardcoded secrets.** Credentials and environment-specific values come from env
   vars or a secrets manager, read through one typed config accessor — never scattered
   raw environment reads.
5. **Non-regression.** Trace all callers before changing shared code. A feature is not
   complete if it breaks a working one.
6. **Keep the production image small.** A new dependency must justify its weight —
   prefer the standard library and deps you already have.
7. **Real, not hallucinated.** Every symbol you call or import must resolve to a
   definition that actually exists — in this codebase or the *installed* dependency,
   verified rather than assumed; library calls match the locked version's real API, not
   one from memory. A hallucinated symbol must fail the build, so the build has to run.
   Any claim about existing behaviour cites `file:line` (code is the source of truth).

---

## War story

*Drawn from a production application built on this model.*

A figure shown to users was, for convenience, recomputed in the frontend instead of
read from the backend engine. For a while the two agreed. Then the engine's logic
moved on and the frontend copy didn't — so the same number was right on one screen and
wrong on another, with no error anywhere to flag it.

The rule that closed it is blunt: **the engine computes, the frontend renders.** If a
number is wrong, you fix the engine, never patch a second derivation into a view. One
source of truth per number — full stop.

---

## How to verify

Cheap, mostly mechanical checks:

- **Secret grep:** scan the diff for inline credentials / connection strings → empty.
- **Layer check:** any new calculation or access decision in the diff is server-side.
- **Caller trace:** a shared-code change records the callers it checked, and the test
  suite is green before *and* after.
- **Duplication check:** the change adds no copy of logic that already exists; adjacent
  duplication is flagged, not extended.
- **Build / symbol check:** the change compiles / imports / typechecks — a hallucinated
  symbol fails here; spot-check that called library APIs exist in the locked dependency.
- **Reuse check:** a newly added function was preceded by a search for an existing
  equivalent, and doesn't re-derive a process that already lives elsewhere (the same
  failure as recomputing in the frontend a value the engine already produces).

---

## Adopt on a new project

- [ ] Write the standing SOP: lean · backend-only logic · least-privilege · no hardcoded secrets · non-regression · small image.
- [ ] Pick the single typed config accessor; ban raw scattered env reads.
- [ ] Establish default-deny as the authorization default from the first endpoint.
- [ ] Add the secret-grep and layer-check to your pre-merge routine.
- [ ] Adopt the code-quality self-review — run `templates/code-review.md` on the diff (hallucination + bloat + correctness) before requesting review.

> Next guide: **04 — QA & Testing.**
