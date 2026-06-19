# Scaling Governance
## From one project to a team, many teams, and a department

*SDLC Governance Playbook · Guide 07*

**Hat — Head of Engineering Governance:** scale the model from one project to many teams without diluting the spine.

---

## Principle

> **Governance scales by adding layers, never by rewriting.** Each layer may *add*
> restrictions but never *relax* the one above it; where layers conflict, the most
> restrictive wins.

The org-spine + project model (`CLAUDE.md` Part 1 + Part 2) is just the smallest case —
two layers. Scaling is the same idea with more layers: more people and repos, each layer
with a clear owner and a defined way for a rule to move between them. You don't author a
new system at each size; you add a tier and a distribution mechanism.

---

## Why it matters

**Likelihood: near-certain as headcount grows.** More people and repositories mean
divergent copies of the standard and a spine that grows until no one reads it.

**Impact: paid exactly when it hurts most.** The failure surfaces during an incident or
an audit — the rule present in one repo and missing in another, or pages of policy with
near-zero adherence ("governance theater"). Either way the control you thought you had
wasn't there.

Two forces are constant at every scale, and one always worsens:

- **Constant — the loop:** `incident → root cause → dated rule → cheap local gate → shared memory`. It never changes shape; you only add humans to it.
- **Constant — graduation:** a rule proven at a lower layer is promoted up at a deliberate version bump; the bar to promote rises with the blast radius.
- **Always worse — drift & dilution:** the antidote never changes — keep the spine *small*, keep gates *cheap and local*, and *prune* relentlessly.

---

## The rule(s)

**The layering model (applies at every size).** Org → Department → Team → Project. Each
layer is add-only over the one above; most-restrictive-wins; each has one named owner and
a defined promotion path upward.

**A · One project → one team.** The rules are now shared by humans, not just AI sessions,
so per-session memory must become *institutional* memory a person can read.
- Vendor the playbook (`CLAUDE.md` + the phase guides) into every repo as the team standard.
- The loop gains a human step: a new rule is proposed in a PR or retro, agreed, dated, added.
- "Memory" generalises to the dated rules + the living registers + a short onboarding doc.
- **Owner:** one tech lead owns the spine; anyone may propose. **Distribution:** a single source repo other repos copy or pull.

**B · One team → multiple teams.** Teams that don't share a lead now share a spine.
Copy-paste stops working; graduation crosses a team boundary.
- Stop copying, start **versioning**: the spine becomes a semver'd artifact teams *consume*, not fork.
- Add a **middle layer** — three tiers: Org spine → Team layer → Project. Most rules live in the team layer; only the truly universal reach the spine.
- **Owner:** a lightweight cross-team guild owns the spine via short RFCs; each team owns its layer.
- **Distribution:** versioned package + a conformance check that each repo runs a supported version; deprecation windows before breaking rule changes.

**C · Multiple teams → department.** This stops being hygiene and becomes formal
compliance — audit, regulatory, and ISMS obligations across many teams.
- Make it a real policy hierarchy (ISMS → governance → standards → procedures) with a governance board, a formal exception/waiver register, periodic conformance audits, and aggregated metrics.
- Score each team on the SDLC phases (a red/yellow/green maturity table) so you see where governance is real vs. theater.
- **Owner:** named roles — governance owner, compliance officer, data-protection officer — plus a governance champion per team. The loop feeds a department risk register.
- **Distribution:** a published internal standard; conformance is *measured* on a dashboard, not assumed; it is part of onboarding.

| | Source of truth | Layers | Owns the spine | Distribution | Main enemy |
|---|---|---|---|---|---|
| **Project** | one `CLAUDE.md` | 2 | you | in-repo | session memory loss |
| **Team** | source repo | 2 | tech lead | copy/pull + version line | copies drift |
| **Multi-team** | versioned package | 3 (+team layer) | a guild + RFCs | semver + conformance check | bottleneck / version skew |
| **Department** | published standard | 4 (+dept layer) | board + named roles | dashboard + onboarding | governance theater |

---

## War story

*Drawn from an engineering organisation scaling this model.*

A team rolled its standard out the obvious way: copy-paste the governance file into every
repository. It worked — until the copies drifted. A rule added after an incident reached
the original repo but not the forks. Months later the *same* incident recurred in a
repository whose copy predated the fix; the cheap gate that would have caught it had never
been added there, because that repo's copy was frozen at an older version.

Nobody had done anything wrong at the repo level — they just held a stale copy. The lesson
is structural: past a single repository, the standard must be a **versioned artifact teams
consume**, with a drift check that flags any repo running behind. A copy is a fork waiting
to rot. The same shape repeats one level up — a department that stands up a board and a
40-page policy *before* the spine has survived a second team gets adherence near zero:
theater, not governance.

---

## How to verify

The check gets one notch more formal at each scale, but stays cheap:

- **Team:** a version line in each repo's `CLAUDE.md` + a check that flags any repo whose copy is behind the source.
- **Multi-team:** a conformance check that each repo consumes a *supported* (non-deprecated) spine version; a drift report across all teams.
- **Department:** adherence *metrics* — gate pass-rate, register freshness, incident MTTR — reviewed on a cadence, plus a per-team maturity scorecard. Measure adherence, never policy page-count.

If your only evidence of governance is the length of the policy, you have none.

---

## Adopt on a new project — and plan the path beyond it

- [ ] Start at two layers (org spine + project). Do **not** build a board or a middle layer before the spine has survived a second repo.
- [ ] **Second person joins:** write the loop's human step (propose → agree → date → add); move session memory into the registers + an onboarding doc.
- [ ] **Second team joins:** stop copying — version the spine; add a team layer; define the RFC process and the named approver for spine changes.
- [ ] **It becomes a department:** add named governance roles, a waiver register, conformance metrics, and a maturity scorecard; measure adherence and prune relentlessly.
- [ ] **At every layer:** keep the spine small and the gates cheap; promote a rule upward only once it is proven, at a deliberate version bump.

> Back to **00 — Operating Model** for the loop that every layer runs.
