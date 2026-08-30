# docs/

Source/reference material for features you're about to run through the
spec workflow — PRDs, ticket exports, requirement writeups, mockups,
meeting notes. Raw input, not an engineering artifact: unlike `specs/`,
nothing in here has a required shape, numbering, or status.

This is where `/spec-new` looks first. Point it at a file here (path or
paste) and it reads the doc in full, extracting the problem statement,
scope, acceptance criteria, and any repos/systems it names, before asking
you anything — see `.claude/skills/spec-new/SKILL.md` Step 2. A vague or
incomplete source doc is fine; `/spec-new`'s interview step exists
specifically to fill what the doc leaves open, not to guess it.

## Relationship to `specs/`

- `docs/` — the raw material a feature started from. Kept as-is,
  unversioned in structure, useful for tracing a requirement back to its
  origin later.
- `specs/<NNN>-<slug>/requirements.md` — the extracted result: testable,
  `REQ-<n>.<m>`-numbered, reviewed and approved. This is what the rest of
  the workflow (design, tasks, implementation) actually builds from — not
  the source doc itself.

If a spec was built from a doc in here, it's worth noting the source
file's name in that spec's `requirements.md` so the link isn't lost.

## Conventions

No required naming scheme. If a doc clearly maps to one feature, naming
it to match that feature's eventual `specs/<NNN>-<slug>/` slug makes the
link obvious at a glance, but this isn't enforced — use whatever name the
source material already has (an exported ticket ID, a PRD title) when
that's clearer.

Two kinds of content end up here, kept apart by location:

- **Feature/client-specific source material** — a PRD, a code dump, a set
  of facts for one particular build — goes in a subfolder, e.g.
  `docs/<client>/`.
- **Cross-feature reference material** — a generic guide distilled from a
  prior build, meant to be reused across many future features rather than
  describing one of them — lives directly at the `docs/` root, e.g.
  `docs/context.md`. Keep this kind agnostic: no names of
  specific clients/features, just the shared system/platform facts and
  lessons that apply regardless of which one comes next.
