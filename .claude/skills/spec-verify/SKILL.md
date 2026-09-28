---
name: spec-verify
description: >
  Audit an implemented feature against its spec — checks every requirement
  is implemented and covered by a test, that this repository honors its
  side of every contract, and flags drift between design.md and the actual
  code. Use once /spec-commit has delivered the work, before opening a PR,
  or when the user asks whether the code matches the spec.
allowed-tools: Read, Glob, Grep, Bash
---

# Verify implementation against spec

## Precondition

The spec's `.status` must be `done` — every task committed and the delivery
branch pushed by `/spec-commit`. If it's earlier, stop and say so:
verifying work that was never delivered isn't meaningful in this workflow.

Read `specs/<NNN>-<slug>/commits.md`: it names the delivery branch and
every commit that belongs to this feature, and scopes the checks below.

Spawn parallel subagents so each check runs in isolated context:

1. **Coverage** — for every `REQ-` ID in requirements.md, find the code
   that satisfies it, the task that delivered it, and the test that names
   it. Report requirements nothing implements, and requirements no test
   names. Do the same for every `AC-` criterion (a test exercises its
   Given / When / Then as written) and every `BR-` rule (the code enforces
   it and a test breaks it on purpose). Check that each capability area's
   postconditions are asserted by a test, and that failing a precondition
   produces the behavior "Failure modes" describes.
2. **Drift** — compare `design.md` against the actual implementation.
   Report anywhere the code diverges from the documented design.
3. **Scope** — find code changed in the commits `commits.md` lists that no
   task asked for, and any file `commits.md` records as excluded that a task
   still needs.
4. **Contracts** — for every file in `contracts/`, check that this
   repository's side of the code matches the interface and behavior it
   commits to, at the revision the tasks name, and that the copy is still
   identical to every counterpart's. Compare the files when the counterpart
   repository is available on this machine; when it isn't, report the sync
   as unverified — never as passing.

Produce a table: requirement ID → task → implementing code → test → status.
Add one row per acceptance criterion and per business rule in the same
shape: `AC-`/`BR-` ID → task → implementing code → test → status.
Add one line per contract: contract → revision → this side matches →
copies identical.

Report honestly. An audit that always passes is not an audit. If
requirements are uncovered, a contract isn't honored, or the code diverged
from the design, say so plainly — that finding is the entire product of
this step.
