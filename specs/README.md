# specs/

Feature specifications, one directory per feature: `specs/<NNN>-<slug>/`.

Each spec directory contains:

- `requirements.md` — testable, observable requirements (`REQ-<n>.<m>` IDs),
  shared across every repo the feature touches
- `design.md` — components (each tagged with the repo it lives in),
  interfaces, data flow, rejected alternatives — also shared
- `.status` — decomposition-level phase: `requirements` | `design` | `tasks`
- `tasks/<repo>.md` — one file per repo touched, ordered/checkable tasks
  scoped to that repo only, each traced to `REQ-` IDs
- `tasks/<repo>.status` — that repo's own implementation phase:
  `tasks` | `implementing` | `done`, independent of every other repo's

Most features here are microservice-shaped and span more than one repo.
`requirements.md`/`design.md` describe the whole feature once; tasks and
implementation status are per repo from `/spec-tasks` onward, so one
repo can be `done` while another is still `implementing`.

These are engineering artifacts, committed to git alongside the code they
describe — not scratch notes. See `.claude/rules/spec-workflow.md` for the
full workflow contract, and use `/spec-new` to start one.
