# Tasks: <feature name> — <repo>

Path: specs/<NNN>-<slug>/tasks/<repo>.md
Status: draft

Tasks for this repo only. See ../requirements.md and ../design.md for the
full cross-repo feature; this file is this repo's slice of it.

Each task must be independently verifiable, small (~150 lines of diff or
less), traced to requirement IDs, and paired with what verifies it. A
task never spans two repos — cross-repo ordering is expressed via
`Depends on: <other-repo>#<task-id>`.

## Task list

- [ ] T1 — <task title>
      Satisfies: REQ-<n>.<m>
      Verify: <test(s) that confirm this task is done>
      Files: <files touched>

- [ ] T2 — <task title>
      Satisfies: REQ-<n>.<m>
      Verify: <test(s) that confirm this task is done>
      Files: <files touched>
      Depends on: T1

- [ ] T3 — <task title>
      Satisfies: REQ-<n>.<m>
      Verify: <test(s) that confirm this task is done>
      Files: <files touched>
      Depends on: <other-repo>#T2

## Parallelizable

<list task IDs that can run in parallel within this repo, or "none">
