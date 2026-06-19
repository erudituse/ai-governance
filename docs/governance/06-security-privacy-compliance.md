# Security · Privacy · Compliance
## Living registers, not one-time sign-offs

*SDLC Governance Playbook · Guide 06 — cross-cutting*

**Hat — wear the role the task calls for:** *Security Architect* when designing for secure-by-design · *Security Advisor / Assessor* when running a TRA or security audit · *Privacy Officer (DPO)* for personal-data handling · *Compliance Officer* for conformance evidence.

---

## Principle

> **Security, privacy, and compliance are tracked as living registers updated in the
> same change set as the code — gaps marked OPEN honestly, never papered green.**

These three are cross-cutting: they touch every phase. The common failure is treating
them as a one-time gate instead of a standing obligation.

---

## Why it matters

**Likelihood: High and adversarial.** Attack surfaces grow with every form, endpoint,
and dependency. Personal data accumulates by default. Auditors arrive on a schedule you
don't pick.

**Impact: Existential.** A breach of personal data is regulatory exposure and lost
trust at once. A compliance claim that is *mapped but not evidenced* collapses under
the first audit. A dependency CVE on a reachable path is a live hole. These are the
risks that end products, not just embarrass them.

---

## The rule(s) — Security

1. **A live audit register.** Never papered to stay green; real gaps are marked OPEN.
   Updated in the *same change set* as the code, citing `file:line`.
2. **A fixed input-form checklist.** Every new form/endpoint: typed schema with explicit
   field constraints, parameterised DB access only, safe rendering (no raw HTML
   injection of user content), URL-scheme allowlisting, and a schema test covering
   boundaries + oversized + injection strings.
3. **A CVE protocol.** Triage reachability *before* any ignore; document every ignore
   inline and in the register; re-check ignored findings monthly. Never ignore a
   reachable CVE "until later"; never lower the scan threshold to hide a finding.
4. **Defence in depth.** Edge controls *and* in-app guards — both required.

---

## The rule(s) — Privacy

5. **Classify first.** Identify data sensitivity (a public→secret ladder) *before*
   designing storage or logging. The most sensitive classes never leave the system.
6. **Never log personal data.** Logs hold hashes/identifiers, not payloads.
7. **Encrypt sensitive data at rest** — including derived artifacts — with the key in a
   secrets manager; drop plaintext; aim for breach-unlinkability.
8. **Data-subject affordances.** Export and delete must exist.
9. **A standing privacy register** — mirroring the security one — updated whenever
   personal-data handling changes.

---

## The rule(s) — Compliance

10. **Map to named frameworks** (information-security, AI-risk, privacy, and
    application-security standards appropriate to the domain).
11. **Evidence, not just mapping.** Each material control points to a *live artifact* —
    an audit row, a test, a deploy gate, a log — because compliance held only "by
    reference" is the gap.
12. **Human-in-the-loop on consequential outputs.** Financial / legal / safety outputs
    require documented review and a **named accountable human**. "The system decided"
    is never a justification.

---

## War story

*Drawn from a production application built on this model.*

Two moments, one lesson. First, a dependency scan flagged a transitive package; the
reflex was to wave it through. Triage instead asked *is this path even reachable, and
is the dep runtime or build-only?* — and the answer changed the action. The scan
threshold was deliberately *raised* afterward, not lowered, because the near-miss
showed the old bar was too loose.

Second, an external assessment found personal data — including derived analytics
artifacts — stored without encryption at rest. The remediation encrypted all of it,
dropped the plaintext, and moved the key into a secrets manager. Both episodes became
**register rows with dates**, not memories — which is the whole point: the register is
how the lesson outlives the person who learned it.

---

## How to verify

- **Register-in-the-diff:** a change to auth, authz, middleware, a sensitive-data
  endpoint, a dependency, or an integration has a matching register update in the same diff.
- **Injection test:** a new form's schema test rejects a script payload and an oversized
  string at the API boundary.
- **Ignore hygiene:** each suppressed CVE has an inline id + reason and a register row,
  re-checked monthly.
- **No-PII-in-logs grep:** logging call sites reference hashes/identifiers, not raw
  personal-data fields.
- **Evidence sampling:** a sampled mapped control points to an artifact that exists and
  is current (date + `file:line`).

---

## Adopt on a new project

- [ ] Create the security register and the privacy register on day one; mark gaps OPEN.
- [ ] Adopt the input-form checklist as non-optional for every new form/endpoint.
- [ ] Wire dependency + container scans as blocking gates with the documented CVE protocol.
- [ ] Define the data-classification ladder and the "never log PII / encrypt at rest" rules before the first data feature.
- [ ] Map to the frameworks your domain requires — and attach evidence, not just the mapping.
- [ ] Name the accountable human for any consequential output.

> Back to **00 — Operating Model** for the loop that keeps all of this alive.
