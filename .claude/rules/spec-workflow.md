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

requirements → design → tasks → implement → verify

Each phase requires explicit human approval before the next begins.
Requirements/design/tasks-split progress is recorded in the shared
`specs/<NNN>-<slug>/.status`. Once tasks are split, each repo's own
implement/verify progress is tracked independently in its own
`specs/<NNN>-<slug>/tasks/<repo>.status` — one repo reaching `implementing`
or `done` says nothing about any other repo in the same feature.

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

## Exemptions

Typo fixes, dependency bumps, formatting, and one-line bug fixes do not
need a spec. Use judgment; when the change touches a module boundary,
crosses a repo/service boundary, or adds behavior, it needs one.
