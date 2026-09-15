# Tasks: <feature name>

Path: specs/<NNN>-<slug>/tasks.md
Status: draft

Tasks for this repository, from ./requirements.md and ./design.md. Each
task is independently verifiable, small (~150 lines of diff or less),
traced to requirement IDs, and paired with what verifies it. Work that
happens in another repository is never a task here: it is an external
dependency (`Requires:`) or the other side of a contract (`Contract:`). The
verification gate this repository's `CLAUDE.md` declares runs on every task
and is not repeated here.

## Task list

- [ ] T1 — <task title>
      Satisfies: REQ-<n>.<m>
      Verify: <the test that confirms it, plus a described manual check for anything visual or interactive>
      Files: <files touched>

- [ ] T2 — <task title>
      Satisfies: REQ-<n>.<m>
      Verify: <the test that confirms it, plus a described manual check for anything visual or interactive>
      Files: <files touched>
      Depends on: T1

- [ ] T3 — <task title that connects this repository to another one>
      Satisfies: REQ-<n>.<m>
      Verify: <the test that confirms it, plus a described manual check for anything visual or interactive>
      Files: <files touched>
      Contract: contracts/<name>.md (revision <n>)
      Requires: <repository or system> — <what must be available before this task can be verified>
      Depends on: T2

## Parallelizable

<task IDs that can run in parallel, or "none">
