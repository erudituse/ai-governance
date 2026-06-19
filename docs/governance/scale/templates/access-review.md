# Access-review template — the periodic owner attestation

Copy this per system per review cycle. It is the evidence that the periodic access review
(guide 08) actually ran: each resource owner attests *who* has access, *why*, and what was
removed. Auditors sample this directly (SOX logical access · SOC 2 CC6.1 · PCI 7.2.4).

Run on a fixed cadence (commonly quarterly); an overdue review is itself a finding.

---

## The skeleton

```markdown
---
system: <system / repo / resource>
review-period: <e.g. 2026-Q2>
cadence: quarterly
reviewer (resource owner): <name>
date: YYYY-MM-DD
---

# Access review: <system> — <period>

## Accounts reviewed
| Identity | Type (human/service/AI) | Access level | Business reason | Decision |
|---|---|---|---|---|
| <name/id> | human | <role/scope> | <why they need it> | keep / reduce / REVOKE |
| <svc-acct> | service | <scope> | <what uses it> | keep / reduce / REVOKE |
| <ai-assistant> | AI | <repo/tool scope> | <task scope> | keep / reduce / REVOKE |

## Privileged access (called out separately — guide 08)
| Identity | Privilege | MFA? | Justified? | Decision |
|---|---|---|---|---|
| <name> | admin/prod/keys | yes/no | <reason> | keep / REVOKE |

## Actions taken
- Revoked: <list — with date completed>
- Reduced: <list>
- Exceptions (waiver raised — guide 13): <list + waiver id>

## Attestation
I confirm I have reviewed every account above and that each retained access has a current
business reason. — <reviewer name>, YYYY-MM-DD
```

---

## Accuracy contract

- The account list is **complete** for the system (IPE — guide 13): pulled from the source
  of truth, not from memory. An incomplete list voids the review as evidence.
- Every `REVOKE` decision has a matching completed-action with a date.
- No account lacks a current owner and business reason; no shared logins; the AI assistant
  appears as its own reviewed identity.
