---
name: spec-implement
description: >
  Execute an approved task list for a feature spec in this repository, one
  task at a time, checking off each as it completes and leaving every change
  unstaged for review. Use when the user approves the tasks and wants
  implementation to begin, or says to start building an already-specced
  feature.
argument-hint: spec directory (optional, defaults to the most recent spec in tasks or implementing)
disable-model-invocation: true
allowed-tools: Read, Write, Edit, Glob, Grep, Bash
---

# Implement from the task list

## Precondition

Find the spec: the one given in $ARGUMENTS, or else the most recent spec
whose `.status` is `tasks` or `implementing`. If there is none, stop. If
more than one spec is `implementing`, ask which.

The spec's `.status` must be `tasks` or `implementing`. If it is anything
else, stop and say which phase it is in.

Read the `## Spec workflow` section of this repository's `CLAUDE.md` for
its source paths, its verification gate, and where its testing rules live.
If it declares no verification gate, stop and ask for one — do not pick
commands for a stack on your own.

Set `.status` to `implementing`.

## Execution loop

For each unchecked task in `tasks.md`, in order:

1. Re-read the relevant section of `design.md`. Do not implement from
   memory of the design — memory drifts, the file does not.
2. If the task names a `Contract:`, check before starting that this spec's
   copy is at the revision the task names and identical to every
   counterpart's — compare the files when the counterpart repository is
   available on this machine, and ask the user to confirm it when it
   isn't. Out of sync means STOP, never "implement against this copy".
3. If the task has a `Requires:`, this repository can't see whether that
   dependency is available — ask the user to confirm it is before starting,
   rather than assuming it.
4. Write the test first, naming the `REQ-` ID it verifies wherever the
   test framework surfaces a name (a `describe`, a test title, a
   docstring). Follow this repository's testing rules for which layer gets
   a dedicated test and which is covered indirectly.
5. Implement the task and nothing beyond it. Resist the urge to
   "also fix" adjacent things you notice; note them instead.
6. Run the verification gate `CLAUDE.md` declares, **on every task, not
   just the last one**, including any manual check it names for a visual
   or interactive surface. If any step fails, fix it before moving on.
7. Check the box in `tasks.md` (`[x] T1 — ...`). **Do not stage or commit
   anything.** Leave the change sitting unstaged in the working tree — the
   user reviews the actual diff before it becomes a commit, not after.
8. Report progress to the user and continue.

When every task is checked off, tell the user implementation is complete
and that `/spec-commit` delivers it — only when they ask for it, after
reviewing the diff themselves. Do not set `.status` to `done` here;
`/spec-commit` does that once everything is actually committed and pushed.

## The escape hatch — this is the important part

If implementing a task reveals the design is wrong or incomplete:

**STOP. Do not improvise a fix.**

Report exactly what the design got wrong and why, propose the amendment
to `design.md`, and wait for approval.

When what's wrong is a **contract**, the fix isn't this repository's alone
to make. Propose it as a new revision of the contract file, name every
counterpart spec that has to take the same revision, and wait until the
user confirms every side has re-approved it and every copy is identical
again. Implementing against a revision only this side has is how two
repositories ship something that doesn't connect.

Silent deviation from the design is the single failure mode that makes
this entire workflow worthless — at that point the spec is a lie, and a
spec nobody trusts is worse than no spec at all.
