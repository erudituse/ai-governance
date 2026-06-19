# Design at Scale
## Peer-reviewed decisions and contracts that cross team boundaries

*SDLC Governance Playbook for Scale · Guide 02 — extends base `../02-design.md`*

**Hat — Technical Lead / Architect:** record the decision and blast radius (base rule), and at scale get architectural decisions *peer-reviewed* and publish interface contracts other teams depend on.

---

## Principle

> **The dated decision log and blast-radius assessment stay (base rule). At scale a
> decision that affects others is *reviewed by* others before it lands, and any interface
> another team consumes is a *published, versioned contract*.**

Solo, the decision log is a note to your future self. With several teams, it is a
*negotiation record* and a *contract* — so it must be reviewed and discoverable, not
buried in one engineer's commit.

---

## Why it matters

**Likelihood: High for shared interfaces.** The base guide already flags shared code as
the highest-blast-radius change. At scale the consumers are *other teams* you can't see in
your own test suite — and the AI assistant in your repo cannot grep a repo it isn't in.

**Impact: Cross-team outages and re-litigated decisions.** A unilateral change to a shared
contract breaks a consumer you didn't know existed; an undocumented decision gets reversed
by another team that never knew why it was made. Both surface late and cost the most to
unwind — and an auditor reads the absence of a decision record as "change made without
design control."

---

## The rule(s)

1. **Architectural decisions are peer-reviewed.** A decision that introduces/alters
   architecture, a reusable pattern, or an interface contract gets a dated ADR
   (`../templates/design-decision.md`) **reviewed and approved by a second
   qualified person** — not the author alone. This is design-stage segregation of duties
   (guide 06).
2. **Cross-boundary interfaces are published contracts.** Any API/schema/event another
   team consumes is documented, versioned, and changed only via **deprecate-before-remove**
   (add → deprecate → migrate consumers → remove) with a stated deprecation window.
3. **Blast radius includes other teams' consumers.** The base "list every consumer" rule
   extends across repos: name the downstream *teams* and how they'll be notified, not just
   the code paths in your own tree.
4. **A named design authority resolves conflicts.** When teams disagree on a shared
   contract, a designated architect/guild decides; the decision is recorded and not
   re-litigated (a later reversal supersedes it with a new dated ADR).
5. **The AI proposes, a human ratifies.** An AI-drafted design is a *proposal*; a named
   human reviews the blast radius and approves before it becomes the decision of record.

---

## War story

*Composite — a pattern auditors see repeatedly at this stage.*

A team renamed a field in a response payload in a single deploy — "it's just a rename,
obviously safe." Three other teams consumed that payload; two broke in production within
the hour. The change had a clean diff and a green local suite; what it lacked was a
published contract and a deprecation window. The fix was structural: shared interfaces
became versioned contracts, every breaking change went add→deprecate→remove with a
notice period, and the ADR for any cross-team contract required a second approver.

---

## How to verify

- **ADR has a second approver:** a sampled architectural decision shows a reviewer who is
  not the author.
- **Contract discipline:** a sampled change to a shared interface is additive or follows
  deprecate-before-remove with a window — never a same-deploy rename/removal.
- **Cross-team blast radius:** a shared-contract change names the consuming teams and the
  notification path.
- **No re-litigation:** a reversed decision points to a superseding dated ADR, not a
  silent flip.

---

## Adopt on a new project

- [ ] Require a second approver on any ADR for shared/cross-team architecture.
- [ ] Designate where published interface contracts live and how they're versioned.
- [ ] Extend the blast-radius field to name downstream **teams** + notification path.
- [ ] Name the design authority that resolves cross-team contract disputes.
- [ ] Adopt deprecate-before-remove as the only path for breaking a consumed contract.

> Next guide: **03 — Coding at scale.**
