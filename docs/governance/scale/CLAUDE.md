# CLAUDE.md — Audit-Tier Governance Extension (for Scale)
**Version:** 1.0.0 (portable scale/audit-tier starter — adopt *alongside* the base `../CLAUDE.md`)
**Classification:** Public — open-source template (adapt for your organisation)
**Status:** Template — adopt when a project becomes team-developed and/or audit-scoped; fill Part 2-S per project
**Framework Alignment (in addition to the base):** SOX ITGC · SOC 2 (Trust Services Criteria) · PCI DSS v4.0 · ISO/IEC 27001:2022

> **THIS IS THE AUDIT-TIER EXTENSION, NOT A REPLACEMENT.** It is adopted **alongside** the
> base playbook's `CLAUDE.md` — never instead of it. The base file remains the
> non-negotiable spine (Part 1) plus the project skeleton (Part 2). This file **adds** the
> controls a *team-developed and/or audit-scoped* project needs and **never relaxes** the base.
>
> **HOW THIS FILE WORKS.** Conceptually three layers, most-restrictive-wins:
> 1. **Base Part 1** — the org spine in `../CLAUDE.md`. Inherited as-is. **Not
>    restated here** (restating it would create a drifting copy — base guide 07).
> 2. **Part 1-S (this file)** — audit-tier *organisational* controls. Non-negotiable
>    **once the tier is in scope**. Additive over base Part 1.
> 3. **Part 2-S (this file)** — the project fill-in: tier, frameworks, owners, and the
>    project-specific values the controls need.
>
> The rationale and war stories live in the scale guides `00`–`13`; the framework mapping
> and evidence index live in `crosswalk/framework-crosswalk.md`. This file is the *law for
> the audit tier*; the guides are the *teaching*; the crosswalk is the *evidence index*.
>
> **When does a project cross into this tier? Two independent switches — *either* one
> pulls in this extension** (declared on the two lines in base `CLAUDE.md` § 2.1):
> - **`Contributors = team`** — more than one person commits. Work is now handed between
>   people, so the per-person controls apply: attribution, maker≠checker, review-by-others,
>   per-person access. *(True even with no auditor in sight.)*
> - **`Assurance tier = audit`** — you owe evidence to SOX / SOC 2 / PCI / ISO / internal
>   audit (enterprise customer, payments, regulated market), so the evidence controls apply.
>
> Only a **solo + base** project stays on the base playbook alone. A **solo but
> audit-scoped** project IS in this tier — it adopts the **[audit]** controls and satisfies
> segregation of duties (S2) through a documented compensating control (S2-05), since one
> person cannot be their own independent reviewer.

---

# PART 1-S — AUDIT-TIER ORGANISATIONAL CONTROLS (de-projected, non-negotiable in scope)

Each control extends the base spine and maps to a scale guide. **Additive only** — where
this and the base meet, the more restrictive applies.

**Which switch activates a section** is tagged on its heading: **[team]** (applies once
more than one person contributes), **[audit]** (applies once you owe framework evidence),
or **[team + audit]** (the section has both halves — its people-half is [team], its
evidence-half is [audit]). A solo + audit project applies the [audit] controls and meets
the [team] ones via compensating controls (S2-05).

## S1. Assurance Model & Scope *(guide 00, 06)* — [audit]

| Ref | Control |
|---|---|
| S1-01 | A project adopting this tier MUST declare its **`Contributors`** mode (solo/team) and **`Assurance tier`** in base `CLAUDE.md` § 2.1, and its **in-scope frameworks** and **in-scope systems** in Part 2-S. The scoping decision is itself an audited artifact. |
| S1-02 | Adopt only the controls your in-scope frameworks drive — but you MUST NOT silently drop a control an in-scope framework requires; an unmet in-scope control is marked **OPEN** with a waiver (S9), never omitted. |
| S1-03 | Re-scope on trigger: **a second contributor joins (solo → team)**, new data class, new regulation, first enterprise/paying customer, M&A, or a major architecture change. |

## S2. Segregation of Duties *(guide 06)* — [team]

| Ref | Control |
|---|---|
| S2-01 | **Maker ≠ checker.** The author of a change is never its approving reviewer. |
| S2-02 | **The AI is a maker, never a checker.** AI-generated code/design/config is a proposal; the AI never provides the approving review, and the human who *prompted* it is the author — not an independent reviewer. Independent review = a *different* qualified human. |
| S2-03 | **Release is a distinct gate** (author → reviewer → release-approver). Author-and-sole-release-approver is never an acceptable combination. |
| S2-04 | **Provenance recorded** on every change: authored-by (incl. AI disclosure), reviewed-by, released-by. A named human attests review; "the AI did it" is never a justification (base §12). |
| S2-05 | Where headcount forces a role overlap, a **documented compensating control** is recorded in the control matrix — a known, evidenced exception, never a silent gap. |

## S3. Change Management & Evidence *(guide 07, 05)* — [team + audit]

| Ref | Control |
|---|---|
| S3-01 | Every production change traces to an **authorized story** (guide 01) and a **recorded release approval** by a non-author. No authorization, no production. |
| S3-02 | **Gates are enforced, not advisory.** Pre-merge and pre-deploy checks run in **shared CI/CD the author cannot bypass** (required status checks on a protected branch) — a bypassable, evidence-less gate is, to an auditor, no control. |
| S3-03 | **Evidence is retained and tamper-evident** (authorization, reviews, CI result, deploy log), for ≥ the audit window. Git history alone (rewritable) is not sufficient evidence. |
| S3-04 | A real **emergency / break-glass** path: who may invoke it, what is allowed, and **retroactive review within a fixed window**. It reorders author→review→release; it never removes the review. An unreviewed break-glass is an incident. |
| S3-05 | Changes are classified **standard / normal / emergency**; the class determines the approval path and is recorded. |

## S4. Access & Identity *(guide 08)* — [team + audit]

| Ref | Control |
|---|---|
| S4-01 | Access is **provisioned on an authorized, owner-approved request**, scoped to least privilege, and recorded. No standing access by default. |
| S4-02 | **Joiner/Mover/Leaver**: grant on join, *remove old-role access on move*, **revoke within the defined SLA on exit**. |
| S4-03 | **Periodic access reviews** on a fixed cadence, owner-attested and recorded; access without a current business reason is removed. |
| S4-04 | **Privileged access** (admin/prod/keys) is minimised, MFA-enforced, logged, and requires a second actor for privileged change (S2). |
| S4-05 | SSO + MFA; unique attributable accounts (no shared logins); per-environment credentials; scheduled rotation. **The AI assistant's access is an identity** — scoped, attributable, reviewed, and revoked like any other. |

## S5. Vulnerability Management *(guide 09)* — [audit]

| Ref | Control |
|---|---|
| S5-01 | Dependency, container, and code/secret **scanning as blocking CI gates**, with the base CVE-triage protocol and documented-ignore discipline. |
| S5-02 | **Independent penetration testing** at least annually **and after significant change**; scope, report, and retest retained. |
| S5-03 | **Remediation SLAs by severity**, tracked to closure in one findings register; every finding **retested before close**. |
| S5-04 | A published **coordinated-disclosure** contact/policy with an intake SLA. |

## S6. Resilience & Availability *(guide 10)* — [audit]

| Ref | Control |
|---|---|
| S6-01 | **RTO and RPO defined per system**, owned, and derived from business need. |
| S6-02 | Backups meet the RPO and are **proven by a restore drill on a cadence** (artifact retained: date, time-to-restore, result). |
| S6-03 | A written **BCP/DR plan**, *exercised* (drill/tabletop) on a cadence. |
| S6-04 | **Monitoring & alerting** on availability and on the controls whose silent failure hurts most (infra invariants, backup success, expiry); alerts reach an on-call that receives them. |
| S6-05 | Carried resilience gaps are **named and explicitly accepted** by an owner — never silently held. |

## S7. Data Lifecycle & Cryptography *(guide 11)* — [audit]

| Ref | Control |
|---|---|
| S7-01 | **Classify before storing** (base rule); **minimise** — hold only what the purpose needs. |
| S7-02 | A **retention + secure-disposal schedule** per data class; disposal is evidenced. |
| S7-03 | Sensitive data (incl. derived artifacts) **encrypted at rest** with **KMS-held keys**; plaintext dropped. |
| S7-04 | A **key-management lifecycle**: generation, storage, **rotation on a crypto-period and on compromise**, retirement; split-knowledge/dual-control for high-value KEKs; key ops need a second actor and are logged. |
| S7-05 | **Never log personal data** (hashes/identifiers only); data-subject **export/delete** exist and are tested. |
| S7-06 | **PCI scope is an explicit, recorded decision.** Prefer keeping cardholder data out of scope (outsource to a compliant processor). If in scope, the full PCI data-protection controls apply and the CDE is segmented. |

## S8. Personnel & Suppliers *(guide 12)* — [team + audit]

| Ref | Control |
|---|---|
| S8-01 | **Onboarding includes security**: access via JML, governance read, completed before touching prod/data. |
| S8-02 | **Security-awareness training** on join + at least annually, tracked. |
| S8-03 | **Acceptable-use attestation** by each person (and AI operator), refreshed on policy change. |
| S8-04 | Screening proportionate to access, where lawful (completion recorded, not contents). Offboarding is a controlled, checklisted event. |
| S8-05 | **Vendors assessed before adoption**, in an approved register with documented data flows; **subservice-org assurance reports reviewed** annually and their **CUECs** tracked and met; **DPA before L3+ data**. |
| S8-06 | The **AI provider is a managed supplier** — terms, retention/training settings, DPA, CUECs, and a re-assessment trigger on major model/terms change. |

## S9. Control Operation & Audit *(guide 13)* — [audit]

| Ref | Control |
|---|---|
| S9-01 | A **control-ownership matrix (RACI)**: every control has **one named owner**, a monitoring cadence, and a named evidence artifact. No null owners. |
| S9-02 | Each control is **reviewed on its cadence and the review itself is evidenced** (dated record of what it found). |
| S9-03 | A **waiver register**: documented, approved, **time-boxed** exceptions with a compensating control and an **expiry**; expired waivers escalate, never auto-renew. |
| S9-04 | **Evidence is complete and accurate (IPE)** — registers capture *every* in-scope event, not a convenient subset. |
| S9-05 | The **framework crosswalk** maps each control to its SOX/SOC 2/PCI/ISO requirement + the evidence that proves operation; kept current. |
| S9-06 | **Audit logs**: defined fields, retention ≥ audit window, append-only/tamper-evident, restricted access, time-synchronised (NTP), and a **log-review cadence with a recorded reviewer**. |
| S9-07 | **Periodic internal audit** samples your own controls; findings feed the incident→rule loop and the risk register. Track **adherence metrics**, never policy page-count. |

---

# PART 2-S — PROJECT FILL-IN (TEMPLATE — complete per project)

> Replace every `<…>`. This is additive over the base `CLAUDE.md` Part 2; it may add
> restrictions, never relax Part 1 or Part 1-S. The phrases **assurance tier**,
> **in-scope frameworks**, and **in scope:** below are what the assurance gate looks for —
> keep them.

## P-S1 Assurance scope *(S1)*
```
Assurance tier      : <e.g. Tier 2 — audit-grade, enforced CI, retained evidence>
In-scope frameworks : <SOX ITGC | SOC 2 (which TSC) | PCI DSS v4.0 | ISO 27001 | internal audit>
In scope: systems   : <which systems/repos are audit-scoped>
Out of scope (+why) : <e.g. PCI out of scope — no cardholder data, processor handles PAN (SAQ-A)>
Re-scope triggers   : <new data class · new regulation · first paying/enterprise customer · M&A · major arch change>
```

## P-S2 Control owners *(S9, S2)*
- Control-ownership matrix lives at: `<docs/governance/control-matrix.md>` (from `templates/control-matrix.md`) — one named owner + cadence + evidence per control.
- Spine/governance owner (approves Part 1-S changes & graduations): `<name/role>`
- Compensating controls for any forced role-overlap: `<documented in the matrix>`

## P-S3 Change management *(S3)*
- Protected branch + required non-author review + required CI checks: `<configured? where>`
- Release approval record: `templates/change-authorization.md` → `<where stored>`
- Evidence retention period + tamper-evident store: `<period / store>`
- Break-glass procedure + retroactive-review window: `<who may invoke / window e.g. 1 business day>`

## P-S4 Access *(S4)*
- JML flow owner + leaver-revocation SLA: `<owner / ≤ 24h?>`
- Access-review cadence: `<quarterly?>` (record: `templates/access-review.md` → `<where>`)
- Privileged-access inventory + MFA: `<where / enforced?>`
- AI assistant access scope + registered identity: `<scope>`

## P-S5 Vulnerability management *(S5)*
- Scan gates + thresholds: `<tools / thresholds>`
- Penetration-test cadence + provider: `<annual + on change / who>`
- Remediation SLAs: `<Critical ≤ ? · High ≤ ? · Medium ≤ ? · Low ≤ ?>`
- Findings register + disclosure contact: `<where / security contact>`

## P-S6 Resilience *(S6)*
- RTO/RPO per system: `<system → RTO / RPO>` (plan: `templates/bcp-dr-plan.md` → `<where>`)
- Restore-drill cadence + DR exercise cadence: `<…>`
- Alerting (availability + control-failure + expiry) → on-call: `<where / who>`

## P-S7 Data lifecycle & crypto *(S7)*
- Data-classification ladder + retention/disposal schedule: `<where>`
- At-rest encryption + KMS + key crypto-period/rotation: `<where / period>`
- PCI scoping decision: `<in scope: controls present | out of scope: rationale + processor>`
- Export/delete affordances + residual-copy note: `<where>`

## P-S8 Personnel & suppliers *(S8)*
- Training cadence + roster: `<annual / where>`; acceptable-use attestation: `<where>`
- Vendor register: `<docs/vendors/...>` (from `templates/vendor-assessment.md`)
- Subservice-org assurance review cadence + CUEC tracking: `<where>`
- AI provider register entry + re-assessment trigger: `<where>`

## P-S9 Control operation & audit *(S9)*
- Control matrix · waiver register · crosswalk locations: `<docs/governance/control-matrix.md · docs/governance/waivers.md · this folder's crosswalk>`
- Internal-audit cadence + log-review cadence: `<…>`
- Audit-log fields/retention/NTP config: `<where>`
- Adherence metrics tracked: `<gate pass-rate · register freshness · finding-SLA · incident MTTR>`

---

*Adopt alongside `../CLAUDE.md`. Part 1 and Part 1-S are non-negotiable in scope;
Part 2-S is yours to fill. Most-restrictive-wins; this extension never relaxes the base.
Rationale in the scale guides `00`–`13`; evidence index in `crosswalk/framework-crosswalk.md`.*
