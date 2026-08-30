---
description: Spec-driven workflow contract for this repository
---

# Spec workflow

Feature work follows spec-driven development. Specs live in
`specs/<NNN>-<slug>/` and are committed to git.

Features here are often microservice-shaped and span multiple
repositories. `requirements.md` and `design.md` are shared, single
documents describing the whole cross-repo feature. Tasks are not shared —
`/spec-tasks` splits them into one file per repo touched
(`specs/<NNN>-<slug>/tasks/<repo>.md`), and implementation/status tracking
from that point on is per repo, in `specs/<NNN>-<slug>/tasks/<repo>.status`.

## Phase order

requirements → design → tasks → implement → commit → release → verify

Each phase requires explicit human approval before the next begins.
Requirements/design/tasks-split progress is recorded in the shared
`specs/<NNN>-<slug>/.status`. Once tasks are split, each repo's own
progress is tracked independently in its own
`specs/<NNN>-<slug>/tasks/<repo>.status`, through the values `tasks` →
`implementing` → `done` → `released` — one repo reaching any of these
says nothing about any other repo in the same feature.

`/spec-implement`, `/spec-commit`, and `/spec-release` are deliberately
three separate steps, not one:
- `/spec-implement` writes and verifies a task, checks it off, and
  leaves the change unstaged for review. Status stays `implementing`.
- `/spec-commit` stages and commits already-checked-off tasks, only
  after the user has reviewed the diff. Status becomes `done` once every
  task is checked off *and* committed.
- `/spec-release` promotes the committed feature branch through
  dev → qa → master and pushes all four branches. Status becomes
  `released` once that succeeds. This is the highest-blast-radius step
  in the workflow (it pushes to shared branches, including master) and
  is what actually ships the change — never fold it into commit, and
  never treat "implementation is done" as authorization to release.

`/spec-verify` requires `released` — verifying work that was never
committed or shipped isn't meaningful.

## Hard constraints

- Do NOT write or modify code under `src/` for a repo whose task status
  (`specs/<NNN>-<slug>/tasks/<repo>.status`) is not `implementing`. If
  asked to, stop and say which phase is pending, for which repo.
- Every requirement gets a stable ID: `REQ-<n>.<m>`.
- `requirements.md` names every repository involved and its role,
  confirmed with the user during `/spec-new` — not inferred silently.
- Every component in `design.md` names the repository it lives in — this
  is what task-splitting keys off.
- Every task in every `tasks/<repo>.md` cites the requirement IDs it
  satisfies, and never spans two repos (cross-repo ordering is a
  `Depends on: <other-repo>#<task-id>` reference, not a shared task).
- Every test names the requirement ID it verifies.
- If implementation reveals the design is wrong, STOP. Update the shared
  `design.md` and get re-approval, flagging whether the fix touches other
  repos' task files too. Do not silently deviate.
- Never stage or commit a task's changes as part of implementing it.
  `/spec-implement` checks the box and stops there; committing only
  happens via `/spec-commit`, after the user has reviewed the unstaged
  diff. A repo's status only becomes `done` once its tasks are both
  checked off and actually committed.
- Never merge or push toward dev/qa/master except via `/spec-release`,
  and never run that skill without the user explicitly asking for it —
  finishing commits does not imply authorization to ship. A repo's
  status only becomes `released` once all three merges and all four
  pushes actually succeeded; a conflict or rejected push leaves it at
  `done`, not `released`.

## Exemptions

Typo fixes, dependency bumps, formatting, and one-line bug fixes do not
need a spec. Use judgment; when the change touches a module boundary,
crosses a repo/service boundary, or adds behavior, it needs one.
