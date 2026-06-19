# QA at Scale
## A shared CI baseline, governed test data, and owned release-readiness

*SDLC Governance Playbook for Scale · Guide 04 — extends base `../04-qa-and-testing.md`*

**Hat — QA Engineer / Release Manager:** keep the suite green for everyone (base rule), and at scale make the baseline *shared and enforced*, the test data *governed*, and release-readiness *owned*.

---

## Principle

> **Green-baseline-before-and-after, new-behaviour-needs-a-test, gold-masters, and
> cross-surface consistency are unchanged (base rules). At scale the baseline moves from
> "I ran it locally" to a *shared CI gate everyone's change must pass*, and test data
> becomes a *governed, synthetic-only* asset — never a copy of production.**

The base playbook deliberately keeps gating local for a solo project. This guide is where
that decision flips: with many authors, the only baseline anyone can trust is the shared
one (see guide 07 on enforced gates).

---

## Why it matters

**Likelihood: High with many authors and one main branch.** "Green on my machine" stops
meaning "green for the team" the moment two people merge in a day. Flaky tests, divergent
local environments, and untested AI diffs erode the baseline until no one trusts it.

**Impact: A meaningless suite and a privacy breach waiting to happen.** A red-but-ignored
baseline is no baseline — regressions ship freely. And the scale-specific landmine is
**test data**: a production snapshot copied into a test or staging environment is a real
personal-data exposure (and a PCI/SOC 2/privacy finding) the instant it happens.

---

## The rule(s)

1. **A shared CI gate is the baseline.** Every PR runs the suite in CI; merge is blocked
   on green (guide 03 branch protection). "Before: X passing, after: X+N" is read from CI,
   not asserted by the author.
2. **Test data is governed and synthetic-only.** Lower environments hold synthetic/masked
   data; **production data is never copied into dev, staging, or test.** A documented gate
   confirms a dataset's provenance before it is used (extends the base playbook's localhost
   test-data gate to every shared environment).
3. **Environments are defined and isolated.** Name the environments (dev/staging/prod or
   your set), what data class each may hold, and the boundary between them; no shared
   credentials across the boundary.
4. **Flaky tests are owned, not ignored.** A flaky test is quarantined with an owner and a
   ticket — never silenced to make a merge pass. The test-traceability register records the
   quarantine (base rule, now with a named owner).
5. **Cross-surface consistency extends across teams.** The base rule (any value on more
   than one surface gets a consistency test) now covers surfaces owned by *different*
   teams — the contract test lives where both can run it.
6. **Release-readiness is an owned decision.** A named role confirms the readiness criteria
   (suite green, criteria met, docs in sync, rollback ready) before promotion — readiness
   is a recorded decision, not a vibe.

---

## War story

*Composite — a pattern auditors see repeatedly at this stage.*

To debug a tricky report, an engineer copied a slice of the production database into
staging "just for the afternoon." It stayed for months, got backed up, and surfaced in a
privacy review as real customer records sitting in a lower environment with weaker access
controls — a reportable exposure. Separately, the team's CI had three flaky tests everyone
"just re-ran," so a genuine regression hid among them for weeks. Two scale failures, one
root: shared assets (data, the baseline) with no owner and no gate. The fixes: synthetic
test data with a provenance gate, and flaky tests quarantined-with-owner, never ignored.

---

## How to verify

- **CI is the gate:** merges require a green shared CI run; a red baseline blocks everyone.
- **Test-data provenance:** a sampled lower-environment dataset is demonstrably synthetic/
  masked, with a recorded provenance check; no production copy exists below prod.
- **Flaky discipline:** quarantined tests have an owner + ticket; none are silently skipped.
- **Cross-team consistency:** a value shown by two teams has one shared contract test.
- **Readiness recorded:** a sampled release has a named readiness sign-off.

---

## Adopt on a new project

- [ ] Stand up shared CI as the merge gate (backend **and** frontend harness) early.
- [ ] Write the test-data policy: synthetic-only below prod + a provenance gate.
- [ ] Define and isolate environments and which data class each may hold.
- [ ] Adopt quarantine-with-owner for flaky tests; forbid silent skips.
- [ ] Name the release-readiness role and its recorded criteria.

> Next guide: **05 — Deploy at scale.**
