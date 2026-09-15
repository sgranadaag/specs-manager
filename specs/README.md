# specs/

Feature specifications for this repository, one directory per feature:
`specs/<NNN>-<slug>/`.

Each spec directory contains:

- `requirements.md` — testable, observable requirements (`REQ-<n>.<m>` IDs)
  for what this repository has to do, and the external dependencies it
  relies on
- `design.md` — components (each with its location in this repository),
  interfaces, contracts, data flow, rejected alternatives
- `contracts/<name>.md` — only when the feature defines or changes an
  interface together with another repository: the shared contract, kept
  identical in every repository involved
- `tasks.md` — ordered, checkable tasks, each traced to `REQ-` IDs and, when
  it connects to another repository, to its contract
- `commits.md` — written by `/spec-commit`: the delivery branch, and every
  commit it made with its hash, a summary and its files
- `.status` — the spec's phase: `requirements` | `design` | `tasks` |
  `implementing` | `done`

A spec describes one repository's work. When a feature needs changes in
another repository too, that repository carries its own spec; here it
appears as an external dependency, and any interface the two build together
as a contract both specs hold.

These are engineering artifacts, committed to git alongside the code they
describe — not scratch notes. See `.claude/rules/spec-workflow.md` for the
full workflow contract, and use `/spec-new` to start one.

`source-material/`, alongside the numbered feature directories here, is
not a feature — it's the raw, unnumbered input `/spec-new` reads before
writing `requirements.md`. See `source-material/README.md`.
