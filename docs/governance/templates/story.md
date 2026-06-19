# Story template — how a user story is written

Copy this skeleton for every user story. It is the **demand / PM-view** artifact
(personas, jobs, acceptance criteria), kept separate from the engineering
source-of-truth (requirements + design docs). Fill every `<placeholder>`; keep the
**(REQUIRED)** sections, delete the **(CONDITIONAL)** ones that don't apply.

The requirements-first discipline behind it lives in **guide 01**; the test-case half is
reinforced in **guide 04**.

---

## Identifier scheme

Stable IDs that survive folder reorders. **Never renumber** — orphan or deprecate.

| Level | Format | Example |
|---|---|---|
| Feature | `F-<DOMAIN>` | `F-AUTH` |
| Epic | `E-<DOMAIN>-<TOPIC>` | `E-AUTH-LOGIN` |
| Story | `US-<DOMAIN>-<TOPIC>-<NNN>` | `US-AUTH-LOGIN-001` |
| Task | `T-<STORY-ID>-<LETTER>` | `T-AUTH-LOGIN-001-A` |

`<DOMAIN>` / `<TOPIC>` are short, stable, ALL-CAPS slugs; the 3-digit story counter is
per-epic and never reused. The filename carries a kebab-case slug after the ID for
navigation; the ID is authoritative.

---

## Status vocabulary

One `status:` per story, from this fixed set — no others.

**Build-lifecycle:** `proposed` (written for a decision, no code) · `planned` (accepted +
designed, not started) · `implemented` (code complete + test-verified, not yet in
production) · `partially-shipped` (some ACs met; mark each) · `shipped` (live in
production).

**Prioritisation (not yet committed to build):** `deferred` (pushed to a later release,
has a target) · `not-scheduled` (no owner / date) · `aspirational` (a bigger bet,
documented not planned) · `superseded` (moved elsewhere — point to the new home) ·
`cancelled` (need rejected; record the date + decision).

**History vs working set.** Terminal statuses (`shipped`, `cancelled`, `superseded`)
*close* a story: it leaves the live backlog but stays in the record — its ID is permanent.
The working set is only `proposed` / `planned` / `partially-shipped`. **Archive by status,
never by deletion; never renumber or reuse a counter.** This is how the backlog stays lean
without losing history (guide 01, rule 6).

---

## The skeleton

```markdown
---
id: US-<DOMAIN>-<TOPIC>-<NNN>
feature: F-<DOMAIN>
epic: E-<DOMAIN>-<TOPIC>
status: proposed
last-updated: YYYY-MM-DD
---

# <One-line story title>

## User story                                   (REQUIRED)
As a <persona>,
I want <capability>,
so that <benefit>.

## Job to be done                               (REQUIRED)
When <situation>, I want to <motivation>, so I can <outcome>.

## Other personas affected                      (REQUIRED)
- <persona>: <how this behaves for them>

## Acceptance criteria                          (REQUIRED — each one testable)
- [ ] <observable behaviour, stated so a pass/fail check can be derived from it>
- [ ] ...

## Test cases                                   (REQUIRED — author WITH the story)
Derive from the acceptance criteria when the story is written, not after coding. Each
case = a condition -> expected result, tagged with the AC it proves. Cover at minimum:
happy path, boundaries / edge cases, and failure / invalid-input cases. For any
input-bearing story, include the injection + oversized-input cases (the input-form
checklist — guide 06). The *cases* are required up front; the *test link* is added as
each is built. A story marked implemented / shipped must have every case linked to a
real automated test.
- TC1 (AC1): given <...>, when <...>, then <expected>.  _(test: <path> — added once built)_
- TC2 (AC2, boundary): <...> -> <...>.

## Testability notes                            (CONDITIONAL — when something is hard to test)
- ...

## Code references                              (CONDITIONAL — only once implemented)
- `path/to/file::symbol`

## Open questions                               (CONDITIONAL — pending decisions)
- ...
```

---

## Accuracy contract for shipped work

For any story marked `implemented`, `partially-shipped`, or `shipped`:

1. Acceptance criteria describe behaviour **observed in code or tests** — not assumed
   from the feature name.
2. Each AC bullet is annotated `✓ test: <path>` or `(no automated coverage)`.
3. `Code references` lists exact paths + symbols; any claim that can't be tied to a code
   location is removed, not paraphrased.
4. If the implementation diverges from the spec, the story documents the divergence — it
   does not paper over it.
5. A change to already-shipped behaviour **amends this story** (or opens a new story that
   links back and flips this one to `superseded` / `partially-shipped` with a pointer) — it
   never silently forks into a fresh ticket that leaves this one stale.
6. **"Done" is verified against the code, not asserted.** If the AC → test → `file:line`
   links don't resolve, the story is *not* closed — regardless of any assistant's report
   that it is. The maker (human or AI) never certifies its own close-out; a reviewer or a
   gate confirms the links resolve.
