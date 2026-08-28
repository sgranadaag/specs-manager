# specs-manager

A portable spec-driven development toolkit for Claude Code — drop it into
any repository to get a structured requirements → design → tasks →
implement → verify workflow, enforced by a hook rather than by hoping
everyone remembers the process.

## Why

Specs that live in someone's head, a Slack thread, or a Notion doc nobody
opens again are not specs — they're a one-time conversation. This toolkit
keeps specs as versioned engineering artifacts, sitting in the repo next
to the code they describe, and uses a `PreToolUse` hook to actually block
source edits until the current feature has cleared its planning phases —
not just a written rule the model might skip under pressure.

## Workflow

```
requirements → design → tasks → implement → verify
```

Each phase requires explicit human approval before the next begins.
Requirements/design/tasks-split progress is tracked in the shared
`specs/<NNN>-<slug>/.status`.

| Phase | Skill | Produces |
|---|---|---|
| Requirements | `/spec-new` | `requirements.md` — reads a source doc if you have one, confirms which repos are involved and each one's role, then interviews for the rest; testable, observable, `REQ-<n>.<m>`-numbered |
| Design | `/spec-design` | `design.md` — components (each tagged with its repo), interfaces, data flow, rejected alternatives |
| Tasks | `/spec-tasks` | one `tasks/<repo>.md` per repo touched — small, ordered, dependency-traced |
| Implement | `/spec-implement` | code + tests in one repo, one task at a time, checked off as it goes |
| Verify | `/spec-verify` | a coverage/drift audit against the spec, for one repo |

Typo fixes, dependency bumps, formatting, and one-line bug fixes are
exempt — this workflow is for changes that touch a module boundary or add
behavior, not busywork for its own sake.

### Microservices: tasks and status are per repo

`requirements.md` and `design.md` describe the whole cross-repo feature
and are shared. `tasks.md` is not — most features here touch more than
one repo, so `/spec-tasks` splits it into `specs/<NNN>-<slug>/tasks/<repo>.md`
per repo, each traced back to the same `REQ-` IDs. From that point on,
implementation status is tracked per repo too, in
`specs/<NNN>-<slug>/tasks/<repo>.status` — one repo reaching
`implementing` or `done` says nothing about any other repo in the same
feature. `gate.sh` checks only the status of the repo it's running in.

## Layout

```
your-repo/
├── CLAUDE.md
├── .claude/
│   ├── rules/
│   │   └── spec-workflow.md          # always-on: the workflow contract
│   ├── skills/
│   │   ├── spec-new/SKILL.md         # /spec-new     → requirements.md
│   │   ├── spec-design/SKILL.md      # /spec-design  → design.md
│   │   ├── spec-tasks/SKILL.md       # /spec-tasks   → tasks/<repo>.md (one per repo)
│   │   ├── spec-implement/SKILL.md   # /spec-implement (this repo's tasks/<repo>.md)
│   │   └── spec-verify/SKILL.md      # /spec-verify
│   ├── templates/
│   │   ├── requirements.md
│   │   ├── design.md
│   │   └── tasks.md
│   ├── hooks/
│   │   └── gate.sh                   # enforcement, per repo
│   └── settings.json
└── specs/
    └── 004-payment-retry/
        ├── requirements.md            # shared across every repo in the feature
        ├── design.md                  # shared; components tagged with their repo
        ├── .status                    # requirements|design|tasks (decomposition-level)
        └── tasks/
            ├── payment-service.md
            ├── payment-service.status # tasks|implementing|done — this repo only
            ├── checkout-frontend.md
            └── checkout-frontend.status
```

`specs/` lives at the repo root, not hidden inside `.claude/` — these are
engineering artifacts and should be as visible as `src/`.

## The enforcement hook

`.claude/hooks/gate.sh` runs on every `Edit`/`Write` call. If the target
path is under `src/`, it derives this repo's name (the working tree's
root directory) and checks that repo's own
`specs/<NNN>-<slug>/tasks/<repo>.status`. If that file doesn't exist yet
(tasks haven't been split for this repo) or isn't `implementing`, it
exits 2 and blocks the edit, telling Claude exactly what's pending. This
is what keeps the workflow honest — skills and rules are requests the
model can misjudge; the hook is the actual gate, and it only ever speaks
for the repo it's running in.

## Using this in another repository

This repo is the source of truth for the toolkit, not a place where specs
for other projects live. To adopt it elsewhere:

1. Copy `CLAUDE.md` (or merge its pointer line into an existing one) and
   the entire `.claude/` directory into the target repo.
2. Create an empty `specs/` directory there.
3. `chmod +x .claude/hooks/gate.sh` (permissions don't survive a plain
   file copy).
4. Adjust `gate.sh`'s guarded path (`src/`) if the target repo's source
   lives somewhere else.
5. Verify the hook's stdin schema and exit-code semantics against the
   current [Claude Code hooks docs](https://code.claude.com/docs/en/hooks)
   before relying on it in a new environment — that's the piece most
   likely to drift between Claude Code versions.

## Getting started on a feature

```
/spec-new short description of the feature
```

If you already have a source document — a PRD, a ticket, mockups — point
`/spec-new` at it (path, paste, or attachment) and it reads that first,
extracting whatever it can before asking anything. Either way, it then
confirms which repositories are involved and each one's role, and
interviews you about scope, failure modes, and acceptance criteria for
whatever's still unanswered — a vague requirement produces confidently
wrong code with full traceability, which is worse than no spec at all.
Approve or correct `requirements.md`, then move through `/spec-design`,
`/spec-tasks`, and `/spec-implement` (per repo) in order. Run
`/spec-verify` once a repo's implementation is done, before opening a PR.
