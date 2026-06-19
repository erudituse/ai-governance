# Change-authorization template — the recorded approval to release

Copy this into the PR / release record for any production change. It is the **evidence
artifact** that change management (guide 07) and segregation of duties (guide 06) demand:
proof that a change was authorized by someone who is **not its author**, with the full
lineage attached. Pair it with `../../templates/change-checklist.md` (the process
lens) — that says *how* the change was built; this says *who authorized it and on what
evidence*.

A `standard` change (pre-approved low-risk pattern) may reference its standing approval
instead of a fresh sign-off; `normal` and `emergency` changes require this record.

---

## The skeleton

```markdown
---
change-id: <CHG-NNN or PR #>
story: US-<...>            # the authorized requirement (guide 01)
class: standard | normal | emergency
date: YYYY-MM-DD
---

# Change authorization: <one-line title>

## Summary
<What changes, and why — one short paragraph.>

## Authorship & review (segregation of duties — guide 06)
- Authored by:   <name>  | AI-assisted: yes/no (model + how)   # the prompter is the author
- Reviewed by:   <name>  # MUST differ from author; never the AI or its prompter
- Release-approved by: <name>  # MUST differ from author

## Lineage (one pull should resolve the whole chain — guide 07)
- Story / authorization: <link>
- Design / ADR (if applicable): <link>
- PR + approving review: <link>
- CI result (required checks green): <link/run-id>
- Deploy record: <link/run-id>

## Risk & rollback
- Blast radius: <consumers/teams affected — guide 02>
- Rollback: <how to undo in < 5 min — command / env flip / migration down>
- Watch after deploy (first 24h): <logs / metrics to monitor — guide 05>

## Emergency / break-glass (CONDITIONAL — class: emergency)
- Invoked by: <name>  | Reason it could not wait: <...>
- Retroactive review due: YYYY-MM-DD  (within the fixed window)
- Retroactive review completed by: <name> on YYYY-MM-DD   # an open one past due = incident
```

---

## Accuracy contract

- The three roles (author / reviewer / release-approver) are real people; where headcount
  forces an overlap, reference the documented **compensating control** (guide 06) — never
  leave author = approver silently.
- Every lineage link resolves; a missing link is an OPEN gap, not a formality.
- Stored where it cannot be silently edited, retained for ≥ your audit window (guide 07).
