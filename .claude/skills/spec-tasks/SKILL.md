---
name: spec-tasks
description: >
  Decompose an approved design into an ordered, checkable task list, split
  per repository. Many features here are microservice-shaped and touch
  several repos — this writes one tasks file per repo touched
  (specs/<NNN>-<slug>/tasks/<repo>.md), each traced to requirement IDs, so
  each repo's implementation can proceed and be gated independently. Use
  after the design is approved, or when the user asks to break work down
  or plan implementation order.
allowed-tools: Read, Write, Glob, Grep
---

# Decompose into tasks

## Precondition

`.status` must be `design`.

## Step 1 — Identify the repos involved

Read `design.md`'s component breakdown table. Every component must name
the repository it lives in — if any component is missing one, STOP and
ask; do not guess which repo a component belongs to.

Collect the distinct set of repos. A single-repo feature is just the
degenerate case of this (one repo, one task file) — always go through
this step, don't special-case it away.

## Step 2 — Write one tasks file per repo

For each repo, create `specs/<NNN>-<slug>/tasks/<repo>.md` containing
only the tasks whose work happens in that repo. Cross-repo ordering
(e.g. "the API contract in `payment-service` must land before
`checkout-frontend` can consume it") is expressed via `Depends on:`
referencing the other repo's task ID, qualified with the repo name —
`Depends on: payment-service#T2`.

## Rules for a good task

- **Independently verifiable.** Each task ends in a state where something
  can be run or tested. "Add the User model" is a task. "Set up the
  backend" is not.
- **Small.** If a task would produce more than ~150 lines of diff, split
  it. Review quality collapses past that point.
- **Ordered by dependency**, and mark which tasks can run in parallel
  within the same repo.
- **Traced.** Every task cites the `REQ-` IDs it satisfies.
- **Test-paired.** Each task states what verifies it. Prefer a
  property-based or table-driven test where the requirement is a rule
  over a range of inputs rather than a single example.
- **Repo-scoped.** A task never spans two repos. If work seems to need
  that, it is two tasks with a `Depends on:` between them.

## Format

```
T1 — Add PaymentRetryPolicy value object
Satisfies: REQ-2.1, REQ-2.3
Verify: unit tests for backoff bounds; property test that delay is monotonic and capped
Files: src/domain/payment/retry-policy.ts
```

## Step 3 — Initialize per-repo implementation status

Once a repo's task file exists, write `specs/<NNN>-<slug>/tasks/<repo>.status`
containing `tasks` for that repo. This is what `gate.sh` checks inside
that repo, separately from every other repo's progress — one repo
reaching `implementing` or `done` says nothing about the others.

## Stop

Once every involved repo has its task file and status file, write `tasks`
to the top-level `.status` (this records that decomposition itself is
complete for the whole feature). Present the full set of per-repo task
lists. Do NOT begin implementing.
