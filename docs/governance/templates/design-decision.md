# Design-decision template — how an architectural decision is recorded

Copy this for any change that introduces or alters architecture, a reusable pattern, or
an interface contract. It is the dated **decision log + blast-radius assessment** from
guide 02, as a fill-in record — written *before* the build, not reconstructed after a
regression. Pure re-presentation of existing behaviour may skip it — but say so, so the
skip is a decision, not an omission.

---

## The skeleton

```markdown
---
id: D-<NNN>                     (your dated decision-log series)
date: YYYY-MM-DD
status: proposed | accepted | superseded
relates-to: <story / feature ID>
---

# D-<NNN>: <one-line decision title>

## Context
<The forces in play — the problem, the constraints, why a decision is needed now.>

## Decision
<What we are doing. State it as a directive: "We will ...".>

## Rationale
<Why this option, in one short paragraph.>

## Alternatives considered
- <Option B> — rejected because <...>.
- <Option C> — rejected because <...>.

## Blast radius                  (REQUIRED for any shared-code / contract change)
Every consumer this touches — list them, or the change is too big to do in one go:
- Shared code / schema / engine / contract: <...>
- Downstream views / reports / exports: <...>
- Dependent data flows / other environments: <...>
- Docs that describe any of the above: <...>

## Interface contract            (CONDITIONAL — when an API / schema / type changes)
<The before -> after of the contract, and the deprecate-before-remove path.>

## Consequences
<What becomes easier; what becomes harder; what to watch after it ships.>
```

---

A decision is recorded once and **not re-litigated**: a later change that reverses it
adds a new dated entry marking the old one `superseded` and pointing to the new — it
never silently flips a settled choice.
