---
name: spec-verify
description: >
  Audit an implemented feature against its spec — checks every
  requirement has passing test coverage and flags drift between design.md
  and the actual code. Use when implementation is finished, before opening
  a PR, or when the user asks whether the code matches the spec.
allowed-tools: Read, Glob, Grep, Bash
---

# Verify implementation against spec

## Precondition

Determine which repo this is and check
`specs/<NNN>-<slug>/tasks/<repo>.status`. It must be `released` — every
task committed (`/spec-commit`) and the branch actually promoted and
pushed through dev/qa/master (`/spec-release`). If it's `done` or
earlier, stop and say so: verifying work that hasn't shipped yet isn't
meaningful in this workflow.

Spawn parallel subagents so each check runs in isolated context:

1. **Coverage** — for every `REQ-` ID in requirements.md, find the test
   that names it. Report uncovered requirements.
2. **Drift** — compare `design.md` against the actual implementation.
   Report anywhere the code diverges from the documented design.
3. **Scope** — find code changed in this feature's commits that no task
   asked for.

Produce a table: requirement ID → task → test → status.

Report honestly. An audit that always passes is not an audit. If
requirements are uncovered or the code diverged from the design, say so
plainly — that finding is the entire product of this step.
