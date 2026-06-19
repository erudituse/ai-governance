# Access & Identity
## Provisioned on a request, reviewed on a cadence, revoked on exit

*SDLC Governance Playbook for Scale · Guide 08 — assurance layer*

**Hat — Identity & Access Owner:** grant least privilege on an authorized request, review access on a fixed cadence, and revoke it the day someone leaves.

---

## Principle

> **Access is granted only on an authorized request, scoped to least privilege, reviewed
> on a cadence, and removed promptly when a role changes or ends. Every grant is
> attributable to an identity — including the AI's.**

The base playbook's coding rule already says *least privilege, default-deny* for endpoints
and queries. This guide governs *human and machine* access to the systems themselves —
the logical-access control SOX, SOC 2 CC6, and PCI 7–8 all test.

---

## Why it matters

**Likelihood: High and continuous.** People join, change roles, and leave; access
accretes and rarely gets removed without a forcing function. Orphaned accounts and
standing privilege are the most common access findings there are.

**Impact: The widest blast radius there is.** A former contractor's live credentials, an
over-privileged service account, or an admin grant no one remembers are each a direct path
to data and production. SOX cares because access defeats segregation of duties; SOC 2 and
PCI care because it defeats everything else.

---

## The rule(s)

1. **Provision on an authorized request, least privilege.** No standing access by default;
   access is requested, approved by the resource owner, scoped to the minimum the role
   needs, and recorded. Default-deny (base rule) applied to people and machines.
2. **Joiner / Mover / Leaver (JML).** A documented flow: grant on join, *adjust on role
   change* (remove what the old role had — the most-missed step), and **revoke within a
   defined SLA on exit** (commonly ≤ 24h). Leavers are the highest-risk case.
3. **Periodic access reviews.** On a fixed cadence (commonly quarterly), each resource
   owner attests who has access and why; access without a current business reason is
   removed. The attestation is recorded (`templates/access-review.md`).
4. **Privileged access is tighter.** Admin / production / key-management access requires
   stronger authentication (MFA), is granted to the fewest people, is time-bound or
   just-in-time where possible, and is logged. Privileged changes need a second actor
   (guide 06).
5. **Identity hygiene.** SSO + MFA for human access; unique attributable accounts (no
   shared logins); secrets/keys in a manager, rotated on schedule and on suspected
   compromise (base coding rule); separate credentials per environment.
6. **The AI's access is an identity too.** An AI assistant's repo/tool/data access is
   scoped to least privilege, attributable, reviewed in the same cadence, and revoked like
   any other. It never holds standing production or data access beyond its task.

---

## War story

*Composite — a pattern auditors see repeatedly at this stage.*

An access review (the team's first) found three categories of ghost: two contractors gone
for a year whose accounts still worked, a service account with org-wide admin "to get
something working once," and an engineer who had moved to a different team but kept every
permission from the old one. None had been exploited — but each was a finding, and the
contractor accounts were a reportable risk. The cause was the absence of JML and a review
cadence: grants happened, removals didn't. The fix was a leaver-revocation SLA, quarterly
owner-attested reviews, and least-privilege service accounts.

---

## How to verify

- **Grant has a request:** a sampled access grant traces to an authorized, owner-approved
  request scoped to least privilege.
- **Leaver revoked in SLA:** a sampled departure shows access removed within the SLA.
- **Review on cadence:** the most recent access review is within the cadence and recorded
  with owner attestations.
- **Privileged inventory:** admin/prod access is enumerated, MFA-enforced, and minimal.
- **No ghosts:** no enabled account lacks a current owner and business reason; no shared
  logins.

---

## Adopt on a new project

- [ ] Write the JML flow with a leaver-revocation SLA; assign it an owner.
- [ ] Adopt `templates/access-review.md`; schedule the first periodic review now.
- [ ] Enforce SSO + MFA, unique accounts, per-environment credentials, scheduled rotation.
- [ ] Inventory and minimize privileged access; require a second actor for privileged change.
- [ ] Scope and register the AI assistant's access as an identity under the same rules.

> Next guide: **09 — Vulnerability Management.**
