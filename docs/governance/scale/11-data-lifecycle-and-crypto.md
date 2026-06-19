# Data Lifecycle & Cryptography
## Retain on a schedule, dispose securely, manage keys as a lifecycle

*SDLC Governance Playbook for Scale · Guide 11 — assurance layer*

**Hat — Data Protection Officer / Crypto Owner:** classify data, hold it only as long as needed, destroy it securely, and run keys as a managed lifecycle — and decide PCI scope explicitly.

---

## Principle

> **Data has a lifecycle — classify → minimise → protect → retain for a defined period →
> securely dispose. Encryption keys have their own lifecycle — generate → store → rotate →
> retire — managed, not improvised. And whether you are in PCI scope is a *decision you
> record*, not a question you avoid.**

The base playbook covers classification, encrypt-at-rest, never-log-PII, and data-subject
export/delete. This guide adds the two pieces audits test that the base leaves implicit:
**a retention + disposal schedule** and a **key-management lifecycle** — plus an explicit
**PCI scoping gate**.

---

## Why it matters

**Likelihood: Data accumulates by default.** Without a retention schedule, every system
trends toward "keep everything forever" — maximising both breach blast radius and
regulatory exposure. Keys, without a lifecycle, get generated once and never rotated.

**Impact: Regulatory and existential.** Over-retention violates privacy law
(data-minimisation / storage-limitation) and enlarges every breach; insecure disposal
leaks data you thought was gone; a key that never rotates means one compromise exposes
everything ever encrypted. And PCI scope, if you store card data, pulls in a dozen
requirements — guessing wrong here is the most expensive scoping error there is.

---

## The rule(s)

1. **Classify before you store (base rule).** A public→secret ladder; the most sensitive
   classes never leave the system. Every store/log/export decision starts from the class.
2. **Minimise.** Collect and retain only what the purpose needs. The cheapest data to
   protect — and the safest in a breach — is the data you never held.
3. **A retention & secure-disposal schedule.** Each data class has a defined retention
   period and a **secure destruction** method at end of life (crypto-erase, secure delete,
   backup expiry). Disposal is evidenced; "we still have everything from 2019" is a finding.
4. **Encrypt sensitive data at rest, incl. derived artifacts (base rule), with managed
   keys.** Keys live in a secrets manager / KMS; plaintext is dropped; aim for
   breach-unlinkability.
5. **Key-management lifecycle.** Documented generation, storage, **rotation on a schedule
   (crypto-period) and on suspected compromise**, retirement, and — for high-value
   key-encrypting keys — split-knowledge / dual-control (PCI 3). Key operations need a
   second actor (guide 06) and are logged.
6. **Never log personal data (base rule).** Logs carry hashes/identifiers, not payloads
   (enforced by the privacy gate in `checks/`).
7. **Data-subject affordances (base rule).** Export and delete exist and are tested; a
   delete that leaves copies in backups/derived stores is documented in the retention plan.
8. **PCI scoping is an explicit, recorded decision.** Decide and document: does the system
   store/process/transmit cardholder data? The right answer for most products is
   **don't — outsource to a compliant processor and keep PAN out of scope** (e.g. SAQ-A).
   If you *are* in scope, the full PCI data-protection controls (3, 4) apply and the CDE is
   segmented. Either way, the decision is written, not assumed.

---

## War story

*Composite — a pattern auditors see repeatedly at this stage.*

An external assessment found personal data — including *derived* analytics artifacts no one
had thought of as sensitive — stored without encryption at rest. The remediation encrypted
all of it, dropped the plaintext, and moved the key into a secrets manager. A second review
found the flip side: data was encrypted but *never deleted* — records from departed users
sat indefinitely because no retention schedule existed, and the encryption key had never
been rotated in three years. Both became dated register rows: encrypt-at-rest with managed,
rotated keys, and a retention schedule with evidenced secure disposal.

---

## How to verify

- **Schedule exists & runs:** each data class has a retention period and disposal method;
  a sampled past-retention record is demonstrably destroyed.
- **At-rest encryption:** sensitive data (incl. derived artifacts) is encrypted; keys are
  in a manager, not in code/config.
- **Key rotation:** keys have a crypto-period and evidence of rotation on schedule; KEK
  operations show split-knowledge/dual-control where required.
- **No PII in logs:** the logging grep is clean (`checks/`).
- **PCI decision recorded:** a written scoping decision exists (in-scope controls present,
  or out-of-scope rationale + processor).

---

## Adopt on a new project

- [ ] Define the data-classification ladder and the minimise rule before the first data feature.
- [ ] Write the retention + secure-disposal schedule per class; evidence disposal.
- [ ] Stand up at-rest encryption with KMS-held, rotated keys; document the key lifecycle.
- [ ] Make and record the PCI scoping decision (prefer keeping PAN out of scope).
- [ ] Verify export/delete affordances and document residual copies in the retention plan.

> Next guide: **12 — Personnel & Suppliers.**
