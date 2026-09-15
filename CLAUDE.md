# specs-manager

The source of truth for a portable, stack-agnostic spec-driven development
toolkit for Claude Code — see [README.md](./README.md). The workflow
contract is `.claude/rules/spec-workflow.md`, loaded every session.

## What belongs here

Only what every adopting repository shares: the workflow contract, the six
`/spec-*` skills, the templates, the enforcement hook and its settings, and
the `specs/` scaffolding (`specs/README.md`, `specs/source-material/README.md`).

This repository is a **reference to replicate**, not a hub applied to
several repositories at once. Each repository that adopts the workflow
gets its own copy of the toolkit and keeps its own `specs/`: its own
requirements, design and tasks for its own part of a feature. A feature
that spans repositories is specced once in each of them, and any interface
they build together is a contract file every one of those specs holds an
identical copy of. No project's specs live here.

Nothing stack-specific ever lands on `main`: no folder structure, naming,
architecture or coding standards, no build or test commands, no framework
paths, no branch names beyond the documented defaults. When a skill needs a
project fact, it reads it from the adopting repository's `## Spec workflow`
declarations in its `CLAUDE.md` — so a change that would name a stack is a
change to that contract instead: add a declaration, and give it a default
or a "stop and ask".

## The workflow

`/spec-new` → `/spec-design` → `/spec-tasks` → `/spec-implement` →
`/spec-commit` → `/spec-verify`, each phase gated on explicit human
approval, with the spec's phase in `specs/<NNN>-<slug>/.status`.

`/spec-implement` never touches git — it leaves every change unstaged so
the diff can be reviewed first. `/spec-commit` is the separate step, run
only when the user explicitly asks for it, that delivers the work: it asks
which changes go in, which base branch to start from and which branch
prefix to use, creates a `<prefix>/<featureName>` branch from that base
synced with the remote, commits one conventional commit per change type,
records the commits in `commits.md`, pushes, and offers to merge the branch
into another — the highest-blast-radius action in the workflow.

## Changing the toolkit

- Keep the three places that describe the workflow in agreement:
  `.claude/rules/spec-workflow.md` (normative), the skills and templates
  that execute it, and `README.md` (narrative). A change to one is a change
  to all three.
- A skill states its preconditions on status files and declarations, never
  on a tool, language or directory it assumes the repository has.
- A skill plans and checks only the repository it runs in. What it needs
  from another repository is an external dependency or a contract — never
  a task, and never a status it reads from there.
- `gate.sh` must keep working under Git Bash on Windows and bash on
  macOS/Linux; check it with `bash -n` and against a scratch repository
  before committing a change to it.

## Spec workflow

This repository's own declarations, for a toolkit change big enough to
spec:

- **Source paths**: none — nothing here is implementation code, so the hook
  guards nothing in this repository (`SPEC_GATE_PATHS` keeps the `src/`
  default adopting repositories start from, and there is no `src/` here)
- **Verification gate**: `bash -n .claude/hooks/gate.sh`, plus reading every
  skill the change touches against `.claude/rules/spec-workflow.md`
- **Testing rules**: none beyond the gate — the toolkit is documents and one
  script
- **Base branches**: `main`
