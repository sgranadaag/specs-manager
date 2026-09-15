---
description: Spec-driven workflow contract for this repository
---

# Spec workflow

Feature work follows spec-driven development. Specs live in
`specs/<NNN>-<slug>/` and are committed to git alongside the code they
describe.

A spec belongs to **the repository it lives in**. Its requirements, design
and tasks describe what this repository has to do, and nothing else. When a
feature also needs changes somewhere else — another service, another front
end, a shared library — that repository gets its own spec, written and
tracked there with its own copy of this workflow. Here, that other side is
an **external dependency**: something to rely on, never a task to perform.

This contract is stack-agnostic on purpose. Whatever depends on the
project — which directories hold source code, what verifies a change,
which branches a delivery starts from — is declared once in the project's
`CLAUDE.md` (see "What the project declares" below). The skills read it
from there; none of them assumes a language, framework, or tool.

## Phase order

requirements → design → tasks → implement → commit → verify

Each phase requires explicit human approval before the next begins. A
spec's progress is recorded in one file, `specs/<NNN>-<slug>/.status`,
through the values `requirements` → `design` → `tasks` → `implementing` →
`done`.

`/spec-implement` and `/spec-commit` are deliberately two separate steps:
- `/spec-implement` writes and verifies a task, checks it off, and leaves
  the change unstaged for review. Status stays `implementing`.
- `/spec-commit` delivers what was implemented, and runs **only** when the
  user explicitly asks for it once every task is checked off. It asks which
  changes go in, which base branch to start from and which branch prefix to
  use, creates a `<prefix>/<featureName>` branch from that base synced with
  the remote, commits the changes as one conventional commit per change
  type, records every commit in `commits.md`, pushes the branch, and offers
  to merge it into another branch. Status becomes `done` once every file
  the tasks name is committed and the branch is pushed. It is the
  highest-blast-radius step in the workflow — it pushes, and may merge into
  a shared branch — so it is never folded into implementation and never run
  just because implementation happens to be finished.

`/spec-verify` requires `done` — verifying work that was never committed
and pushed isn't meaningful.

## Contracts between repositories

Most external dependencies are relied on as they are — an API that already
exists, a provider's SDK — and are simply listed in `requirements.md`.

A **contract** is different: an interface this feature defines or changes
*together with* another repository — an endpoint one side adds and the
other calls, a field one side starts sending and the other reads, an event
one side emits and the other consumes. Two specs, in two repositories, must
agree on it and keep agreeing while both are built. So:

- The contract is a file, `specs/<NNN>-<slug>/contracts/<name>.md`, written
  from `.claude/templates/contract.md`, and **every repository involved
  keeps an identical copy of it in its own spec**. Identical is what
  synchronized means: a copy that differs from its counterpart is out of
  sync, whatever the difference.
- The contract names its **owner** — the side that exposes the interface —
  and its **consumers**, each with the spec it lives in, and carries a
  **revision** number.
- **A contract changes only by agreement**: the change is made in the
  owner's copy, the revision is bumped and logged, the file is copied to
  every consumer, and every side's design is re-approved with it. One copy
  is never edited alone — not even to fix a typo.
- The task that connects this repository to the other side names the
  contract and its revision (`Contract:` in `tasks.md`). It is not
  implemented while its copy is at another revision or differs from a
  counterpart's.
- Whether copies are identical is checked, never assumed: by comparing the
  files when the counterpart repository is available on the same machine,
  and by asking the user when it isn't.

## What the project declares

A repository adopting this workflow states the following in its
`CLAUDE.md`, under a `## Spec workflow` section. A skill that needs one of
them and can't find it uses the default below, or stops and asks where
there is none — it never guesses a stack's commands.

| Declaration | Meaning | If absent |
| --- | --- | --- |
| **Source paths** | The directories holding implementation code — the ones only an `implementing` spec allows editing | `src/` |
| **Verification gate** | The commands that must all pass on every task (type-check, lint, tests, build — whatever the stack has), plus any manual check for something with a visual or interactive surface | Ask |
| **Testing rules** | Where the project states which layers get a dedicated test and which are covered indirectly | Ask |
| **Base branches** | The branches a `/spec-commit` delivery branch may start from — e.g. `main` and a development branch | `main`, and the skill asks for any other |

## Hard constraints

- Do NOT write or modify code under the project's source paths unless the
  spec being worked on has `.status` `implementing`. If asked to, stop and
  say which phase is pending, for which spec.
- Every requirement gets a stable ID: `REQ-<n>.<m>`.
- **Every file a spec references is committed with the spec.** A document
  that `design.md`, a task's `Files:` line or `CLAUDE.md` points at, and
  that never reaches git, is worse than no document: the reference says it
  exists, so nobody goes looking for the information again. Before a spec's
  status becomes `done`, every path named inside `specs/<NNN>-<slug>/`
  resolves.
- `requirements.md` lists every external dependency — each system outside
  this repository the feature relies on, what it expects of each, and
  whether it is relied on as is or is a contract to agree with another
  repository — confirmed with the user during `/spec-new`, not inferred
  silently.
- **A spec never plans work in another repository.** Work that happens
  elsewhere is not a task here: it is an external dependency, a `Requires:`
  line on each task that waits for it, or the other side of a contract.
  That repository's own spec plans it.
- Every task in `tasks.md` cites the requirement IDs it satisfies.
- Every task names the test that verifies it, and every test written for
  a task names the `REQ-` ID it covers. A requirement no test names is an
  uncovered requirement, whatever the code says.
- **The verification gate runs on every task, not once at the end.** It is
  assumed, so it never appears in a task's `Verify:` line; what goes there
  is the check specific to that task.
- If implementation reveals the design is wrong, STOP. Update `design.md`
  and get re-approval. Do not silently deviate.
- **If implementation reveals a contract is wrong, STOP harder.** Propose
  the change as a new revision, name every counterpart spec that has to
  take it, and wait until every side has re-approved it and every copy is
  identical again. Never implement against a revision only this side has.
- Never stage, commit, branch, push or merge as part of implementing.
  `/spec-implement` checks the box and stops there; everything that touches
  git happens in `/spec-commit`, after the user has reviewed the unstaged
  diff and asked for it.
- `/spec-commit` never force-pushes, never commits with `--no-verify`, never
  resets, rebases or stashes to get past a problem, never discards a change
  the user excluded, and never merges into another branch unless the user
  names that branch in the same run. A spec's status only becomes `done`
  once every file its tasks name is committed and the branch is pushed; a
  stop anywhere before that leaves it `implementing`.

## Exemptions

Typo fixes, dependency bumps, formatting, and one-line bug fixes do not
need a spec. Use judgment; when the change touches a module boundary,
changes a contract with another repository, or adds behavior, it needs one.
