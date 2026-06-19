# Personnel & Suppliers
## The people who build it and the vendors you depend on

*SDLC Governance Playbook for Scale · Guide 12 — assurance layer*

**Hat — Security/Compliance Officer:** make people-controls real (onboarding, training, acceptable-use attestation) and manage the vendors and subservice orgs your security now depends on — including the AI provider.

---

## Principle

> **A control is only as strong as the people who run it and the vendors you rely on.
> People are screened, trained, and attest to the rules; suppliers (including the AI
> provider and the cloud) are assessed, their assurance reports reviewed, and their
> failure modes folded into yours.**

The base playbook is light here by design (solo). At team-and-audit scale, SOC 2 CC1
(control environment) and CC9 (vendor risk), plus ISO A.6 (people) and A.5.19–23
(suppliers), are tested directly — and the AI assistant is now itself a subprocessor in
your data path.

---

## Why it matters

**Likelihood: Certain — these are first-tested.** SOC 2 starts at the control environment:
*do your people know the rules, and did they agree to them?* And every system today runs on
vendors; their weaknesses become yours silently.

**Impact: The human and the inherited risk.** Untrained people are the most common breach
vector (phishing, mishandled data, weak secrets). A vendor without assurance is an
un-assessed extension of your attack surface — and a subservice-org outage or breach lands
on *your* users as *your* incident. "We didn't know our provider did that" is not a defence.

---

## The rule(s)

**People:**

1. **Onboarding includes security.** Every joiner gets access via the JML flow (guide 08),
   reads the governance (`CLAUDE.md` + the playbooks), and completes onboarding before
   touching production or data.
2. **Security-awareness training, recurring.** On joining and at least annually; tracked
   (who completed it, when). Untracked training is unprovable training.
3. **Acceptable-use attestation.** Each person (and each AI operator) attests to the
   acceptable-use rules and data-handling policy — a recorded sign-off, refreshed on policy
   change.
4. **Screening proportionate to access.** Background/reference checks appropriate to the
   role's data and privilege level, where lawful — recorded as completed, not the contents.
5. **Offboarding is a controlled event.** Access revoked in SLA (guide 08), assets
   returned, and a checklist completed — the leaver case is where people-controls and
   access-controls meet.

**Suppliers:**

6. **Assess before you depend.** A vendor handling your data or sitting in your security
   path gets a security assessment before adoption; it lands in an approved-vendor register
   with documented data flows (`templates/vendor-assessment.md`).
7. **Review assurance reports on a cadence.** Obtain and review subservice orgs' SOC 2 /
   ISO reports (cloud, AI provider, key SaaS) annually; track their **CUECs**
   (complementary user-entity controls — the things *you* must do for *their* controls to
   hold) and confirm you do them.
8. **DPA before sensitive data.** A data-processing agreement is in place before any L3+
   personal data reaches a vendor; sub-processor lists are reviewed.
9. **The AI provider is a managed supplier.** The AI assistant/model provider is in the
   vendor register with its data-handling terms, retention/training settings, DPA, and a
   re-assessment trigger on major model or terms changes. Its CUECs (e.g. *you* must not
   submit restricted data) are tracked like any other.

---

## War story

*Composite — a pattern auditors see repeatedly at this stage.*

A team adopted an AI coding assistant org-wide with no vendor assessment and no acceptable-
use attestation from the people using it. The SOC 2 audit raised two findings at once:
the provider was an un-assessed subprocessor in the data path (no review of its terms, no
DPA, no tracked CUECs — including "don't paste customer data into prompts," which no one
had been told), and the engineers had never formally agreed to any acceptable-use rule. The
fix was mundane and effective: the provider entered the vendor register with its terms and
CUECs reviewed, and everyone completed a short training + attestation.

---

## How to verify

- **Training tracked:** a current roster shows who completed security training and when;
  none overdue.
- **Attestation on file:** a sampled person (and AI operator) has a recorded acceptable-use
  attestation, current to the latest policy version.
- **Onboarding/offboarding complete:** a sampled joiner/leaver shows the checklist done and
  (for leavers) access revoked in SLA.
- **Vendor register current:** each data/security-path vendor has an assessment, data-flow
  doc, DPA where required, and a reviewed assurance report; CUECs are tracked and met.
- **AI provider managed:** the AI provider appears in the register with terms, CUECs, and a
  re-assessment trigger.

---

## Adopt on a new project

- [ ] Add security + governance reading and an acceptable-use attestation to onboarding.
- [ ] Schedule recurring security-awareness training; track completion.
- [ ] Stand up the approved-vendor register (`templates/vendor-assessment.md`); assess before adopting.
- [ ] Review subservice-org assurance reports annually; track and meet their CUECs.
- [ ] Enter the AI provider as a managed supplier with a model/terms-change re-assessment trigger.

> Next guide: **13 — Control Operation & Audit.**
