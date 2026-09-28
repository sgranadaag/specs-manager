---
name: spec-tasks
description: >
  Decompose an approved design into an ordered, checkable task list for
  this repository (specs/<NNN>-<slug>/tasks.md), each task traced to
  requirement IDs — and to the contract and revision it implements, when it
  connects this repository to another. Use after the design is approved,
  or when the user asks to break work down or plan implementation order.
allowed-tools: Read, Write, Glob, Grep
---

# Decompose into tasks

## Precondition

`.status` must be `design`.

## Step 1 — Check the contracts are in sync

For every file in the spec's `contracts/`, confirm this copy is identical
to every counterpart's: compare the files when the counterpart repository
is available on this machine, and ask the user to confirm it when it
isn't. If any copy differs, or a counterpart has no copy yet, STOP and say
which — the two sides would be building against different contracts, and
tasks written now would plan a disagreement.

A spec with no `contracts/` skips this step.

## Step 2 — Write tasks.md

Read `design.md` and write `specs/<NNN>-<slug>/tasks.md` from
`.claude/templates/tasks.md`.

## Rules for a good task

- **Independently verifiable.** Each task ends in a state where something
  can be run or checked. "Add the User model" is a task. "Set up the
  backend" is not.
- **Small.** If a task would produce more than ~150 lines of diff, split
  it. Review quality collapses past that point.
- **Ordered by dependency** (`Depends on: T<n>`), and mark which tasks can
  run in parallel.
- **Traced.** Every task cites the `REQ-` IDs it satisfies, the `AC-`
  criteria its test covers, and the `BR-` rules it enforces. Every `AC-`
  and every `BR-` in requirements.md is covered by some task.
- **Verifiable.** Each task names the test that confirms it, placed where
  this repository's testing rules put it, plus a described manual check for
  anything with a visual or interactive surface. Prefer a table-driven or
  property-based test where the requirement is a rule over a range of
  inputs rather than a single example. Every task additionally passes the
  verification gate `CLAUDE.md` declares; that goes without saying and does
  not belong in the `Verify:` line.
- **Inside this repository.** Work that happens in another repository is
  never a task here. A task that can't be verified until something outside
  exists says so with `Requires: <dependency> — <what must be available>`.
- **Tied to its contract.** A task that implements this repository's side
  of a contract names it with `Contract: contracts/<name>.md (revision <n>)`.
  Keep each contract's side in as few tasks as possible, so a new revision
  lands on a small, known set of tasks.

## Format

```
T3 — Call the retry endpoint from the checkout client
Satisfies: REQ-2.1
Covers: AC-2.1, AC-2.2
Enforces: BR-3
Verify: tests/checkout/retry-client.test.ts — table-driven over the status codes the contract lists
Files: src/checkout/retry-client.ts
Contract: contracts/payment-retry.md (revision 1)
Requires: payment-service — the retry endpoint deployed to the development environment
Depends on: T1
```

## Step 3 — Stop

Write `tasks` to `.status`. Present the task list. Do NOT begin
implementing.
