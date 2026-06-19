# Change checklist — how a change is built and shipped

Copy this into the PR / commit description for any non-trivial change. It turns the
requirements-first workflow into a reviewable artifact: each box is a gate a reviewer
can check. The order is the workflow order — **do not start at code.** The rationale
lives across guides 00–05; the security half in guide 06.

---

## Before code
- [ ] **Spec first** — a story / ticket states the *what + why* and **testable**
      acceptance criteria, written *before* this change. (guide 01 · `templates/story.md`)
- [ ] **Test cases derived from the criteria** at spec time. (guide 01 / 04)
- [ ] **Blast radius mapped** — every consumer of the shared code / contract this touches
      is enumerated. If you can't articulate it, decompose. (guide 02)
- [ ] **Data classified** — the sensitivity of any data this handles is known before
      design. (guide 06)
- [ ] **Design decision recorded** (dated, with rationale) if architecture or a contract
      changes. (guide 02)

## While coding
- [ ] **Green baseline captured** before the change ("before: X passing"). (guide 04)
- [ ] Business logic in the backend; least privilege; default-deny; no hardcoded
      secrets. (guide 03)
- [ ] New input form / endpoint → the input-form checklist applied (typed schema +
      field constraints, parameterised queries, injection + oversized tests). (guide 06)

## Before merge
- [ ] **New behaviour has a test**; suite re-run — "after: X+N", no regression. (guide 04)
- [ ] **Cross-surface consistency** test extended for any value shown in more than one
      place. (guide 04)
- [ ] **Security register updated in the same change set** (cite `file:line`) for any
      auth / authz / middleware / sensitive-endpoint / CI / deploy / dependency / secret
      change; real gaps marked OPEN. (guide 06)
- [ ] **Docs in sync** — story, requirements, design, traceability (forward + reverse).
      Rollup: no parent closed while a child is open. (guide 00 / 06)
- [ ] Dependency changed → CVE protocol run. (guide 06)

## Deploy (only on explicit instruction)
- [ ] Reversible steps (schema multi-deploy; API deprecate-before-remove). (guide 05)
- [ ] Secrets runtime-injected, never baked; `.gitignore` / `.dockerignore` verified. (guide 05)
- [ ] **`Rollback:` line** + what to watch post-deploy. (guide 05)

## Stop and ask first if this change would
delete / migrate data or schema · push or deploy to a shared branch or production · need
credentials beyond the approved set · touch shared code used by more than one feature ·
be of uncertain reversibility. (`CLAUDE.md` § 12)
