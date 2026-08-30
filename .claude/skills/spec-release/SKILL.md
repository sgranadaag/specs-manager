---
name: spec-release
description: >
  Promote this repo's already-committed feature branch through the
  environment chain — merge into dev, dev into qa, qa into master — then
  push all four branches (the feature branch, dev, qa, master) to origin.
  This is the step between commit and verify: it's what actually ships
  the change. Use only when the user explicitly asks to release, promote,
  merge to dev/qa/master, or ship the branch — never on the assumption
  that finishing implementation implies this should happen next.
disable-model-invocation: true
allowed-tools: Read, Edit, Bash
---

# Release: promote and push

This is the highest-blast-radius step in the whole spec workflow — it
rewrites shared branches (`dev`, `qa`, `master`) and pushes all of them.
Treat every push here as needing explicit, fresh confirmation, exactly
like any other push to a shared branch — a skill existing to do this is
not standing authorization to do it silently.

## Precondition

Determine which repo this is, same as `/spec-implement`/`/spec-commit`.

Check `specs/<NNN>-<slug>/tasks/<repo>.status`. It must be `done` — every
task checked off *and* committed (see `/spec-commit`). If it's anything
else, stop and say what's still pending. Do not release partially
committed work.

Run `git status`. The working tree must be clean (nothing uncommitted,
nothing untracked left over) before touching any branch. If it isn't,
stop and tell the user what's dirty rather than stashing or discarding
it yourself.

Confirm the three target branches (`dev`, `qa`, `master`) actually exist
locally or on `origin` before starting. If any is missing, stop and ask
— do not create a missing environment branch on your own judgment.

**Ask the user to explicitly confirm before starting the cascade.**
Name the feature branch and confirm the destination is really
dev → qa → master for this repo — don't assume every repo in the feature
promotes through the same three environments without checking.

## Promotion sequence

Note the current branch (the feature branch) before switching anywhere,
so the repo can be returned to it at the end.

For each step, sync the target branch with `origin` before merging into
it (`git fetch origin` + fast-forward or `git pull`), so the merge isn't
based on a stale local copy:

1. Checkout `dev`, sync with `origin/dev`, merge the feature branch in.
2. Checkout `qa`, sync with `origin/qa`, merge `dev` in.
3. Checkout `master`, sync with `origin/master`, merge `qa` in.

Use a plain `git merge <source>` (no `--squash`, no rebase) — this
repo's history already shows ordinary merge commits
(`Merge branch 'X' into Y`) for exactly this promotion pattern; match it.

**If any merge conflicts, STOP immediately.** Do not attempt to resolve
it yourself, do not pick a side. Report exactly which merge conflicted,
on which files, and leave the repo in that conflicted state for the user
to resolve — or abort the merge (`git merge --abort`) if they'd rather
back out and sort it out before retrying. Nothing gets pushed from a
conflicted or partially-merged state.

## Push

Only after all three merges succeed cleanly: push all four branches to
`origin` — the feature branch, `dev`, `qa`, `master` — one at a time,
reporting each as it completes. Never force-push any of them. If a push
is rejected (remote has commits this local branch doesn't), stop and
report it rather than force-pushing or pulling-and-retrying on your own.

Return to the original feature branch once done.

## After

Set `specs/<NNN>-<slug>/tasks/<repo>.status` to `released`. This is what
gates `/spec-verify` — verifying a feature that was never actually
shipped isn't meaningful. If any step above stopped early (conflict,
rejected push, missing branch), do not set this — the repo isn't
released yet.
