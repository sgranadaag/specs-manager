---
name: spec-commit
description: >
  Commit this repo's already-implemented, already-checked-off task(s)
  after the user has reviewed the unstaged diff themselves. `/spec-implement`
  deliberately leaves every change unstaged — it never commits on its own.
  Use this once the user has looked over the working-tree diff and is
  ready to lock it in, or says something like "commit the changes",
  "looks good, commit it", or "commit T2".
disable-model-invocation: true
allowed-tools: Read, Edit, Glob, Grep, Bash
---

# Commit implemented tasks

## Precondition

Determine which repo this is, same as `/spec-implement`, and find its
task file: `specs/<NNN>-<slug>/tasks/<repo>.md`.

Find every task line marked `[x]` that does **not** already carry a
`— committed <sha>` suffix. Those are the candidates: implemented and
checked off, but not yet committed.

If there are none, say so and stop — nothing pending.

Run `git status` in this repo. If there are unstaged/uncommitted changes
that don't correspond to any pending task (leftover local work, changes
to files no task claims), do not touch them — only stage what a specific
pending task's `Files:` list names. If a pending task's files aren't
actually present as changes, stop and tell the user rather than guessing
why.

## Commit loop

For each pending task, in order:

1. Show the user (or let them confirm they've already seen) which files
   this task touches, from its `Files:` list.
2. Stage exactly those files by name — never `git add -A` or `git add .`.
   Re-run `git status` after staging and sanity-check nothing unexpected
   got swept in.
3. Commit with a plain conventional-commit message: `<type>: <plain
   description of what changed>` — `feat`/`fix`/`chore` as fits, no
   parenthetical scope, **no task ID, no REQ ID**. Check `git log
   --oneline` in this repo first and match its existing style (e.g. this
   repo's own convention: `feat: confirmeza landing add
   gestionTypification unit entry`, not `feat(confirmeza): T5 add
   gestionTipificationByUnit entry [REQ-6.2]`). The task ID stays in the
   tasks file line (step 4) — that's where it's tracked, not in git
   history.
4. Append ` — committed <short-sha>` to that task's line in the tasks
   file, so it's not offered again next time.
5. Report the commit (hash + message) to the user and continue.

If a task's `Files:` says "none in-repo" (a DB-only/config-only task),
there's nothing to stage or commit — just append `— committed (no
in-repo changes)` to its line so it's not re-offered, and move on.

## After the loop

If every task in this repo's file is now checked off **and** committed
(or explicitly has no in-repo changes), set
`specs/<NNN>-<slug>/tasks/<repo>.status` to `done`. Otherwise leave it as
`implementing` — some tasks are still pending commit or still unchecked.

Do not commit a task that isn't checked off `[x]` yet — that means
`/spec-implement` hasn't finished it. Do not implement anything here;
this skill only stages and commits work that already exists.
