# Framework Crosswalk
## Every control mapped to the standard it satisfies — and the evidence that proves it

*SDLC Governance Playbook for Scale · the audit-evidence index*

This is the first document an auditor should be handed. It maps each control in the
playbooks to the **SOX ITGC**, **SOC 2 (Trust Services Criteria)**, **PCI DSS v4.0**, and
**ISO/IEC 27001:2022 Annex A** requirement it satisfies, and points to the **live evidence
artifact** that proves the control *operated* (guide 13: mapping without evidence is the
gap). Keep the Evidence column current — it is what gets sampled.

> **How to use.** Adopt only the rows your scope requires (guide 06 assurance tier +
> in-scope frameworks). Fill the **Evidence / `file:line`** column with *your* artifact
> locations. A blank or stale Evidence cell is an OPEN gap, not a pass.

---

## Legend

- **Guide** — the playbook guide that defines the control (`B-NN` = base `../../NN`; `S-NN` = this folder's guide NN).
- **SOX ITGC** — IT General Control domain: Change Mgmt · Logical Access · SDLC/Program Dev · Computer Ops · SoD.
- **SOC 2** — relevant Common Criteria (CC1–CC9) or category (A=Availability, C=Confidentiality, PI=Processing Integrity, P=Privacy).
- **PCI v4.0** — requirement number (only if in PCI scope).
- **ISO 27001:2022** — Annex A control reference.
- **Evidence** — the live artifact that proves operation (fill in per project).

---

## A · Governance & control environment

| Control | Guide | SOX ITGC | SOC 2 | PCI v4.0 | ISO 27001 | Evidence / `file:line` |
|---|---|---|---|---|---|---|
| Two-tier policy, non-negotiable spine | B-00, S-00 | SDLC | CC1, CC2 | 12.1 | A.5.1 | `CLAUDE.md` Part 1/2 |
| Control-ownership matrix (RACI), named owners | S-00, S-13 | SoD | CC1, CC4 | 12.1, 12.4 | A.5.2, A.5.4 | `templates/control-matrix.md` |
| Incident→rule→gate→memory loop | B-00 | — | CC4, CC7 | 12.10 | A.5.27 | dated rules + registers |
| Risk assessment + risk register | B-00, S-13 | — | CC3 | 12.3 | A.5.7, Clause 6 | risk register |
| Internal audit on a cadence | S-13 | mgmt review | CC4 | 12.4 | A.5.35, Clause 9.2 | internal-audit records |
| Metrics over page-count | S-13, B-07 | — | CC4 | — | Clause 9.1 | metrics dashboard |

## B · Requirements, design & change

| Control | Guide | SOX ITGC | SOC 2 | PCI v4.0 | ISO 27001 | Evidence / `file:line` |
|---|---|---|---|---|---|---|
| Requirements-first; testable ACs | B-01, S-01 | SDLC | CC8 | 6.5.1 | A.8.25 | story files + traceability |
| Stable IDs; authorized before build | S-01 | Change Mgmt | CC8 | 6.5.1 | A.8.25 | backlog + authorization sign-off |
| Forward + reverse traceability | B-01, S-01 | Change Mgmt | CC8 | 6.5.1 | A.8.25 | traceability register |
| Dated decision log + blast radius | B-02, S-02 | SDLC | CC8 | 6.5.1 | A.8.27, A.8.28 | `templates/design-decision.md` |
| Peer-reviewed ADR; published contracts | S-02 | SDLC, SoD | CC8 | 6.5.1 | A.8.27 | ADRs w/ second approver |
| Change authorization recorded | S-07 | Change Mgmt | CC8 | 6.5.1 | A.8.32 | `templates/change-authorization.md` |
| Emergency / break-glass w/ retroactive review | S-07 | Change Mgmt | CC8 | 6.5.1 | A.8.32 | break-glass log + reviews |
| Enforced (non-bypassable) gates; retained evidence | S-07 | Change Mgmt | CC8 | 6.5.2 | A.8.32 | CI required-checks + retained results |
| Reversible / multi-deploy steps; rollback line | B-05, S-05 | Change Mgmt | CC8 | 6.5.4 | A.8.32 | release records |
| Threat-model security-relevant designs | B-02, S-02 | SDLC | CC3, CC8 | 6.3 | A.8.27 | threat models + risk register |

## C · Coding & segregation of duties

| Control | Guide | SOX ITGC | SOC 2 | PCI v4.0 | ISO 27001 | Evidence / `file:line` |
|---|---|---|---|---|---|---|
| Backend-only logic; least privilege; default-deny | B-03 | SDLC | CC6, CC8 | 6.2, 7.2 | A.8.4, A.8.3 | code-review records |
| No hardcoded secrets; typed config accessor | B-03 | — | CC6 | 6.2.4, 8.6 | A.8.24 | secret-scan results |
| Real-not-hallucinated; code is source of truth | B-03 | SDLC | PI1 | 6.2 | A.8.28 | green CI + `code-review.md` |
| Branch protection; review by non-author | S-03 | Change Mgmt, SoD | CC8 | 6.5.1 | A.8.32 | branch-protection config + PR approvals |
| Maker ≠ checker; AI is maker never checker | S-06 | **SoD** | CC8 | 6.5.1 | A.5.3, A.8.32 | provenance (authored/reviewed/released) |
| AI authorship disclosed; named human accountable | S-03, S-06 | SoD | CC1, CC8 | 6.5.1 | A.5.3 | AI-disclosure trailer + attestation |
| Self-review quality lens (hallucination/bloat) | B-03 | SDLC | PI1 | 6.5.1 | A.8.28 | `templates/code-review.md` |
| Object-level authorization (no IDOR); authz tested | B-06 | SDLC | CC6.1, CC8 | 6.2.4 | A.8.26 | authz cross-user negative tests |

## D · QA, testing & processing integrity

| Control | Guide | SOX ITGC | SOC 2 | PCI v4.0 | ISO 27001 | Evidence / `file:line` |
|---|---|---|---|---|---|---|
| Green baseline before/after; new behaviour tested | B-04 | SDLC | PI1 | 6.5.1 | A.8.29 | CI before/after counts |
| Gold-master for numeric outputs | B-04 | SDLC | PI1 | — | A.8.29 | snapshot tests |
| Cross-surface consistency test | B-04, S-04 | SDLC | PI1 | — | A.8.29 | consistency integration test |
| Shared CI gate is the baseline | S-04 | Change Mgmt | CC8 | 6.5.2 | A.8.29 | required CI status |
| Test data synthetic-only; provenance gate | S-04 | — | C1, P | 6.5.5 | A.8.10, A.8.33 | test-data policy + provenance check |
| Test traceability register | B-04 | SDLC | CC8 | — | A.8.29 | test-traceability register |

## E · Access & identity

| Control | Guide | SOX ITGC | SOC 2 | PCI v4.0 | ISO 27001 | Evidence / `file:line` |
|---|---|---|---|---|---|---|
| Provision on authorized request; least privilege | S-08 | **Logical Access** | CC6.1, CC6.3 | 7.2, 7.3 | A.5.15, A.5.18 | access requests + approvals |
| Joiner/Mover/Leaver; leaver revocation SLA | S-08 | Logical Access | CC6.2, CC6.3 | 8.2 | A.5.18, A.6.5 | JML records |
| Periodic access reviews (owner-attested) | S-08 | Logical Access | CC6.1 | 7.2.4 | A.5.18 | `templates/access-review.md` |
| Privileged access minimized; MFA; second actor | S-08, S-06 | Logical Access, SoD | CC6.1 | 7.2, 8.4, 8.5 | A.8.2, A.8.5 | privileged-access inventory |
| SSO+MFA; unique accounts; per-env creds; rotation | S-08, B-03 | Logical Access | CC6.1, CC6.6 | 8.2, 8.3, 8.6 | A.5.16, A.5.17 | IdP config + rotation log |
| AI assistant access scoped & reviewed as identity | S-08 | Logical Access | CC6.1 | 7.2 | A.5.15 | AI access entry in review |
| AI assistant actions logged under its identity | S-08, S-13 | Logical Access | CC6.1, CC7.2 | 10.2 | A.8.15, A.8.16 | AI action logs in log review |
| Production access segregated from non-prod | S-08, S-04 | Logical Access, SoD | CC6.1 | 6.5.3 | A.8.31 | no standing dev prod access; second-actor path |

## F · Operations, vuln mgmt & resilience

| Control | Guide | SOX ITGC | SOC 2 | PCI v4.0 | ISO 27001 | Evidence / `file:line` |
|---|---|---|---|---|---|---|
| Scanning as blocking gate; CVE protocol | B-05, S-09 | Computer Ops | CC7.1 | 6.3.1, 11.3 | A.8.8 | scan results + ignore register |
| Penetration testing (annual + on change) | S-09 | — | CC7.1 | 11.3, 11.4 | A.8.8, A.8.29 | pen-test report + retest |
| Remediation SLAs by severity; tracked to closure | S-09 | — | CC7.1 | 6.3.1 | A.8.8 | findings register |
| Coordinated disclosure path | S-09 | — | CC7.1 | — | A.5.5, A.5.6 | disclosure policy |
| RTO/RPO defined; backups meet RPO | S-10 | Computer Ops | A1.2, A1.3 | — | A.5.29, A.8.13 | `templates/bcp-dr-plan.md` |
| Restore drills; BCP/DR exercised | S-10, B-05 | Computer Ops | A1.3 | — | A.5.30 | restore-drill artifacts |
| Monitoring & alerting on critical controls | S-10 | Computer Ops | CC7.2, A1.1 | 10.7 | A.8.16 | alert config |
| Infra invariants abort deploy | B-05, S-05 | Change Mgmt | CC6.6, CC8 | 1.2, 4.2 | A.8.20, A.8.9 | deploy-gate checks |
| Residual risk named + accepted by owner | S-10, B-05 | — | CC3 | 12.3 | Clause 6.1 | accepted-risk register |
| Capacity & performance management | S-10 | Computer Ops | A1.1 | — | A.8.6 | capacity alerts + load-test results |
| Incident response plan + PIR/RCA; breach notification; tested | S-10, B-00 | Computer Ops | CC7.3, CC7.4, CC7.5 | 12.10 | A.5.24–A.5.28 | incident register + PIR records + drill |

## G · Data, crypto & privacy

| Control | Guide | SOX ITGC | SOC 2 | PCI v4.0 | ISO 27001 | Evidence / `file:line` |
|---|---|---|---|---|---|---|
| Data classification + minimisation | B-06, S-11 | — | C1.1, P | 3.1, 9.4 | A.5.12, A.5.13 | classification doc |
| Retention + secure disposal schedule | S-11 | — | C1.2, P4 | 3.2, 9.4.7 | A.5.10, A.8.10 | retention schedule + disposal evidence |
| Encrypt at rest incl. derived; KMS keys | B-06, S-11 | — | C1.1 | 3.5 | A.8.24 | KMS config |
| Key-management lifecycle; rotation; dual-control | S-11 | — | C1.1 | 3.6, 3.7 | A.8.24 | key-management procedure + rotation log |
| Encrypt in transit (TLS) | B-05, S-11 | — | C1.1 | 4.2 | A.8.24 | TLS config / deploy gate |
| Never log PII (hashes/identifiers only) | B-06, S-11 | — | C1.1, P | 3.4, 10.3 | A.8.12, A.8.15 | `checks/` PII-in-logs gate |
| Data-subject export/delete | B-06, S-11 | — | P5, P6 | — | A.5.34 | export/delete tests |
| PCI scoping decision (recorded) | S-11 | — | C1 | 12.5.2 | A.5.12 | scoping decision doc |

## H · Logging, personnel & suppliers

| Control | Guide | SOX ITGC | SOC 2 | PCI v4.0 | ISO 27001 | Evidence / `file:line` |
|---|---|---|---|---|---|---|
| Audit-log fields/retention/tamper-evidence/NTP | B-00 spine, S-13 | Computer Ops | CC7.2 | 10.2–10.6 | A.8.15, A.8.17 | log config + retention policy |
| Log-review cadence (recorded reviewer) | S-13 | Computer Ops | CC7.2 | 10.4 | A.8.15 | log-review records |
| Security-event logging (auth/authz/privilege/secret access) | B-06, S-13 | Computer Ops | CC7.2 | 10.2 | A.8.15, A.8.16 | security-event logs |
| Security-awareness training (tracked) | S-12 | — | CC1.4 | 12.6 | A.6.3 | training roster |
| Acceptable-use attestation | S-12 | — | CC1.1 | 12.6 | A.5.10, A.6.2 | signed attestations |
| Onboarding/offboarding controlled | S-12, S-08 | Logical Access | CC1.4, CC6.2 | 8.2 | A.6.1, A.6.5 | JML checklists |
| Vendor assessment + approved register | S-12 | — | CC9.2 | 12.8 | A.5.19–A.5.21 | `templates/vendor-assessment.md` |
| Subservice-org assurance review + CUECs | S-12 | — | CC9.2 | 12.8.4, 12.8.5 | A.5.22 | reviewed SOC2/ISO reports |
| DPA before L3+ data | B-06, S-12 | — | P, CC9 | 12.8.2 | A.5.19 | signed DPAs |
| AI provider as managed supplier | S-12 | — | CC9.2 | 12.8 | A.5.19, A.5.23 | AI-provider register entry |
| HITL + named accountable on consequential output | B-06 | — | CC1.1, PI1 | — | A.5.2 | review sign-offs |

---

## Scope note — what each framework actually wants from this index

- **SOX ITGC** is narrow and deep: it cares about **Change Management, Logical Access, SDLC,
  Computer Operations, and SoD** *for systems that affect financial reporting*. Rows tagged
  Change Mgmt / Logical Access / SoD are your ITGC core; evidence = independent approval,
  access reviews, and complete change records over the period.
- **SOC 2** spans the **Common Criteria (CC1–CC9)** plus any categories you assert
  (Availability, Confidentiality, Processing Integrity, Privacy). A Type II tests that
  controls *operated over a period* — so the Evidence column must show recurring operation,
  not a point-in-time snapshot.
- **PCI DSS v4.0** applies **only if you store/process/transmit cardholder data** (guide 11
  scoping). Most products should design to stay out of scope (outsource PAN → SAQ-A); the
  PCI column then collapses to the handful of rows about not handling card data. If in
  scope, all 12 requirements apply and the crosswalk expands.
- **ISO/IEC 27001:2022** wants an ISMS (Clauses 4–10) plus the Annex A controls referenced
  above, each justified in a Statement of Applicability — this crosswalk *is* the spine of
  that SoA.
