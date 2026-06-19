# Code-review template — the code-quality lens (hallucination · bloat · correctness)

Run this against the diff itself — as author (self-review) before requesting review, and
as reviewer. It is the **code-quality** lens; the **process** lens (was the spec written,
the register updated, the rollback noted) is `change-checklist.md`. Together they cover a
change; neither replaces the other.

The anti-hallucination items trace to "code is the source of truth" (guide 03 · `CLAUDE.md`
§2.7); the anti-bloat items to guide 03's lean rule.

---

## Hallucination — every claim ties to something real
- [ ] **Every symbol exists.** Each imported / called function, class, method, constant,
      module, route, env var, and config key resolves to a real definition — verified, not
      assumed. (A hallucinated symbol must fail typecheck / import — so confirm the build runs.)
- [ ] **No invented APIs or signatures.** Library / framework calls match the *installed*
      version's real API — checked against the locked dependency, not from memory.
- [ ] **Behaviour is observed, not assumed.** Any claim about what existing code does is
      verified by reading it (cite `file:line`), never inferred from a name.
- [ ] **Every consumer accounted for.** When changing shared code, the callers listed are
      real (grep) — and *all* of them, not just the convenient ones.
- [ ] **Tests run and pass.** New behaviour has a test that executes the real code path; a
      green run is the proof the code isn't fiction.
- [ ] **Uncertainty is flagged, not papered.** Anything unverified is called out, not
      presented as fact.

## Bloat — the smallest change that satisfies the spec
- [ ] **Scoped to the spec.** Nothing here exceeds the story's acceptance criteria — no
      speculative "might need it later" generality.
- [ ] **No duplication or reinvention.** No copy of logic that already exists — and no
      new function that re-derives a process living *elsewhere* in the codebase. Searched
      first, then reused / extended rather than re-created; a partial overlap is factored
      into the shared path, not grown as a parallel one. (Reinvention is the silent kind:
      it compiles and passes its own tests, so only a search — or a reviewer who knows the
      code — catches it.)
- [ ] **No dead code / needless files.** No unused vars, params, imports, exports, or files
      added; nothing left commented-out.
- [ ] **No needless dependency.** Any new dep justifies its weight over the standard library
      / existing deps; the production image stays small.
- [ ] **Comments earn their place.** They explain a non-obvious *why*, never restate the
      code — and carry no planning / roadmap commentary in shipped client code.

## Correctness & layer (carried from guide 03)
- [ ] Business logic backend-only; the frontend renders, never re-derives. One source of
      truth per value.
- [ ] Least privilege, default-deny; no hardcoded secrets (read via the typed config accessor).
- [ ] Nothing already-working is broken — callers traced; suite green before *and* after.
