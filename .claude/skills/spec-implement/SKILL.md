---
name: spec-implement
description: >
  Execute this repo's slice of an approved task list for a feature spec,
  one task at a time, checking off each as it completes. Tasks are split
  per repository (specs/<NNN>-<slug>/tasks/<repo>.md) since features here
  are often microservice-shaped — this only ever works the current repo's
  file and tracks that repo's own status independently of any other repo
  involved in the same feature. Use when the user approves the tasks and
  wants implementation to begin, or says to start building an
  already-specced feature.
disable-model-invocation: true
allowed-tools: Read, Write, Edit, Glob, Grep, Bash
---

# Implement from the task list

## Precondition

Determine which repo this is (the working tree's root directory name, or
the git remote name if that's more reliable in this environment) and find
its task file: `specs/<NNN>-<slug>/tasks/<repo>.md`.

If no task file exists for this repo under the target spec, stop — either
this repo isn't actually part of the feature, or `/spec-tasks` hasn't run
yet.

Check `specs/<NNN>-<slug>/tasks/<repo>.status` (this repo's own status,
not the shared top-level `.status`, and not any other repo's). It must be
`tasks` or `implementing`. If it is anything else, stop.

Set `specs/<NNN>-<slug>/tasks/<repo>.status` to `implementing`.

## Execution loop

For each unchecked task in this repo's task file, in order:

1. Re-read the relevant section of `../../design.md`. Do not implement
   from memory of the design — memory drifts, the file does not.
2. If the task has a `Depends on: <other-repo>#<task-id>`, this repo
   cannot see that other repo's status directly — ask the user to confirm
   it's actually done before starting, rather than assuming it is.
3. Write the test first, naming the `REQ-` ID it verifies.
4. Implement the task and nothing beyond it. Resist the urge to
   "also fix" adjacent things you notice; note them instead.
5. Run the test suite. If it fails, fix it before moving on.
6. Check the box in this repo's tasks file (`[x] T1 — ...`). **Do not
   stage or commit anything.** Leave the change sitting unstaged in the
   working tree — the user reviews the actual diff before it becomes a
   commit, not after. Committing is a separate, explicit step: `/spec-commit`.
7. Report progress to the user and continue.

When every task in this repo's file is checked off, tell the user
implementation is complete for this repo and that `/spec-commit` is the
next step whenever they're ready — after reviewing the diff themselves.
Do not set this repo's `.status` to `done` here; `/spec-commit` does that
once everything is actually committed. That status says nothing about
whether other repos involved in the same feature are done — check their
own status files, or ask.

## The escape hatch — this is the important part

If implementing a task reveals the design is wrong or incomplete:

**STOP. Do not improvise a fix.**

Report exactly what the design got wrong and why, propose the amendment
to `../../design.md`, and wait for approval. Since `design.md` is shared
across every repo in this feature, flag whether the fix also affects
other repos' task files, not just this one's.

Silent deviation from the design is the single failure mode that makes
this entire workflow worthless — at that point the spec is a lie, and a
spec nobody trusts is worse than no spec at all.
