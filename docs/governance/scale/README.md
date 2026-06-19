# The SDLC Governance Playbook — for Scale

The team-and-audit-grade companion to `docs/governance/`. Where the base playbook is the
lean model a project **starts on** (one person — or one person plus an AI — local
advisory gates, move fast), this is the model you **graduate into** when work becomes
**team-developed** *and/or* **audit-scoped** — two independent switches, *either* of which
pulls in this layer: several humans plus AI assistants sharing one codebase, **or** a real
auditor grading your evidence against **SOX ITGC**, **SOC 2 (Trust Services Criteria)**,
**PCI DSS v4.0**, **ISO/IEC 27001:2022**, or an internal-audit program — or both at once.

> Two shifts happen at once when you scale, and this playbook governs both:
> 1. **Solo → team.** Work is now handed *between* people. The control is no longer "I
>    remember"; it is an explicit handoff, an owner, and a review by someone who is not
>    the author.
> 2. **Define → evidence.** Auditors don't grade your policy — they grade evidence that
>    each control fired on every in-scope event, that the evidence is retained, and that
>    no single person could defeat it.

## How this relates to the base playbook — extends, never copies

This folder is **additive and non-duplicative.** The base playbook's phase guides stay
the **single source of truth for each discipline** — requirements-first, blast-radius,
backend-only logic, gold-masters, reversible deploys. This playbook does **not** restate
them. For each phase it adds only the **"what changes when it's a team of humans + AI,
under audit"** layer on top, and points back to the base guide it extends.

Why not a self-contained rewrite? Because the playbook's own rule (base guide 07:
*"a copy is a fork waiting to rot — version, don't copy"*) forbids it. Two folders
describing requirements-first will drift, and then neither is authoritative. So: base =
the discipline; scale = the team + assurance layer over it; most-restrictive-wins where
they meet; Part 1 of the base `CLAUDE.md` remains the non-negotiable spine.

You adopt only what your two switches require (guide `00` / `06`), not all of this at once.
The switches live on two lines in the base `CLAUDE.md` § 2.1 — `Contributors : solo | team`
and `Assurance tier : base | audit`:

- **`Contributors = team`** activates the **[team]** controls (per-person attribution,
  maker≠checker, review-by-others, per-person access) — needed the moment work is handed
  between people, auditor or not.
- **`Assurance tier = audit`** activates the **[audit]** controls (retained tamper-evident
  evidence, enforced CI gates, pentest, RTO/RPO, registers) — needed when you owe a
  framework evidence.

Each section heading below is tagged **[team]**, **[audit]**, or **[team + audit]**. Only a
**solo + base** prototype stays on the base playbook alone; a **solo but audit-scoped**
product is in here too, meeting segregation of duties via a compensating control (S2-05).

## What's in the folder

**Part A — the SDLC, re-cast for a team (each extends a base guide):**

| File | Extends | The team layer it adds |
|---|---|---|
| `00-team-operating-model.md` | base `00` | Roles & RACI · the human loop · how a rule moves between people · onboarding |
| `01-requirements-at-scale.md` | base `01` | Shared backlog · ID governance · who authorizes a story · refinement & sign-off |
| `02-design-at-scale.md` | base `02` | RFC/ADR review by peers · cross-team interface contracts · design authority |
| `03-coding-at-scale.md` | base `03` | Branch/PR/merge discipline · review-by-others · ownership (CODEOWNERS) · AI authorship |
| `04-qa-at-scale.md` | base `04` | Shared CI baseline · environments & test data · who owns flaky tests · release-readiness |
| `05-deploy-at-scale.md` | base `05` | Promotion approvals · release roles · on-call & day-2 ownership |

**Part B — the assurance machinery (new control domains):**

| File | Closes the gap | Frameworks |
|---|---|---|
| `06-segregation-of-duties.md` | Maker-checker · independent approval of **AI-authored** change · provenance & attestation | SOX · SOC 2 CC8 · PCI 6 |
| `07-change-management.md` | Authorization records · emergency / break-glass · immutable retained evidence · enforced (non-bypassable) gates | SOX change mgmt · SOC 2 CC8 |
| `08-access-and-identity.md` | Joiner/Mover/Leaver · periodic access reviews · privileged access · SoD-in-access | SOX logical access · SOC 2 CC6 · PCI 7–8 |
| `09-vulnerability-management.md` | Scanning **+ penetration testing** · remediation SLAs by severity | SOC 2 CC7 · PCI 6 & 11 |
| `10-resilience-and-availability.md` | RTO/RPO · BCP/DR plan · monitoring & alerting · tested restores | SOC 2 A1 |
| `11-data-lifecycle-and-crypto.md` | Retention & secure-disposal schedule · key-management lifecycle · PCI scoping gate | SOC 2 C1/P · PCI 3 |
| `12-personnel-and-suppliers.md` | HR security · training & acceptable-use attestation · vendor / subservice-org & CUEC review | SOC 2 CC1/CC9 · ISO A.6 |
| `13-control-operation-and-audit.md` | Control-ownership matrix · monitoring cadence · waiver register · IPE completeness · audit-log specifics · evidence sampling | SOC 2 CC4 · SOX mgmt review |

**Supporting:**

| Path | Role |
|---|---|
| `CLAUDE.md` | The audit-tier governance **extension** — Part 1-S (org controls) + Part 2-S (project fill-in). Adopt *alongside* the base `../CLAUDE.md`, never instead of it. |
| `crosswalk/framework-crosswalk.md` | Every control mapped to SOX / SOC 2 / PCI / ISO — your audit-evidence index |
| `templates/` | Fill-in **evidence** artifacts — change-authorization · access-review · waiver · control-matrix · BCP/DR plan · vendor-assessment |
| `checks/` | Read-only **assurance** gates — scope declared · evidence current · no expired waivers · de-projection |

## The format

Same six-section contract as the base playbook — **Principle · Why it matters (likelihood
× impact) · The rule(s) · War story · How to verify · Adopt on a new project** — each
opening with a **Hat** (the role to wear). War stories here are marked **composite**:
patterns auditors see repeatedly at this stage, not incidents from one named project
(honesty discipline — don't dress an illustration as a fact).

## How to adopt

1. Read `00-team-operating-model.md`, then `06`'s assurance-tier table — together they
   tell you **which tier and which frameworks** apply, so you adopt the right subset.
2. Adopt this folder's `CLAUDE.md` *alongside* the base `../CLAUDE.md`, and fill
   its **Part 2-S**: assurance tier, in-scope frameworks, in-scope systems, and the named
   **control owners** (the scoping decision is itself an audited artifact).
3. Stand up the `templates/` evidence artifacts — these are what an auditor samples.
4. Wire `checks/assurance-checks.sh` in. At this tier the gates move from *advisory and
   local* to **enforced in CI and evidence-retaining** — guide `07` explains why a
   bypassable gate is, to an auditor, no control at all.
5. Build `crosswalk/framework-crosswalk.md` once and keep it current — it is the index an
   auditor reads first.
