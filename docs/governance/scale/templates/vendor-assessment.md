# Vendor / subservice-org assessment template — incl. the AI provider

Copy this per vendor that handles your data or sits in your security path — the cloud, the
AI/model provider, key SaaS. It is the evidence for supplier management (guide 12):
assessed before adoption, in an approved register, with data flows documented, assurance
reports reviewed, and **CUECs** (the things *you* must do for *their* controls to hold)
tracked. SOC 2 CC9.2 · PCI 12.8 · ISO A.5.19–A.5.23.

The AI assistant/model provider is a subprocessor in your data path — assess it like any
other vendor.

---

## The skeleton

```markdown
---
vendor: <name>
service: <what it does for you>
data-path: yes/no            # does our data flow to it?
data-classes-shared: <none / L1..L4 — see guide 11>
status: assessed | approved | re-assess-due | retired
owner: <relationship/security owner>
assessed-date: YYYY-MM-DD
next-review: YYYY-MM-DD       # annual, or on major change
---

# Vendor assessment: <name>

## What we use it for
<Service + where it sits in our architecture / data path.>

## Data flows
- Data sent to vendor: <fields / classes>   Purpose: <...>
- Data stored by vendor: <what / where / residency>
- Retention & deletion at vendor: <...>

## Assurance & legal
- SOC 2 / ISO report reviewed: <date + key exceptions noted>
- DPA in place (required before L3+): yes/no — <link>
- Sub-processors reviewed: <...>
- Certifications relevant to our scope (PCI/HIPAA/etc.): <...>

## CUECs — complementary user-entity controls (what WE must do)
<The controls the vendor's report assumes we operate — list them and confirm we do.>
- <e.g. "configure MFA on admin accounts"> — we do this: yes/no — evidence: <...>
- <e.g. "do not submit restricted data in prompts"> — enforced by: <...>

## Risk & decision
- Residual risk: <likelihood × impact — both halves>
- Decision: approved / approved-with-conditions / rejected — by <name>, YYYY-MM-DD

## Re-assessment trigger
<What forces an early re-review — major model change, terms change, breach, scope change.>
```

---

## AI provider — specific points to capture

- **Data handling / retention / training settings:** confirm prompts/outputs are not used
  for training and retention matches your policy; record the exact setting.
- **CUEC that bites hardest:** *restricted data is never submitted to the assistant* — name
  how you enforce it (classification + the `checks/` PII gate + acceptable-use attestation).
- **Re-assessment trigger:** any major model or terms-of-service change (base spine § 13).

---

## Accuracy contract

- A vendor in the data path with no assessment is an OPEN gap (guide 12), not "low risk."
- CUECs are not just listed — each is confirmed *done* with evidence; an un-met CUEC means
  the vendor's control you rely on does **not** actually hold for you.
- `next-review` is real and tracked in the control matrix; overdue → escalate.
