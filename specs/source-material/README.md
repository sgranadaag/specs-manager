# source-material/

Source/reference material for features you're about to run through the
spec workflow — PRDs, ticket exports, requirement writeups, mockups,
meeting notes, API contracts. Raw input, not an engineering artifact:
unlike the numbered `specs/<NNN>-<slug>/` directories beside it, nothing
in here has a required shape, numbering, or status.

This is where `/spec-new` looks first. Point it at a file here (path or
paste) and it reads the doc in full, extracting the problem statement,
scope, acceptance criteria, and the repositories and systems it names,
before asking you anything — see `.claude/skills/spec-new/SKILL.md` Step 2.
A vague or incomplete source doc is fine; `/spec-new`'s interview step
exists specifically to fill what the doc leaves open, not to guess it.

## Relationship to `specs/<NNN>-<slug>/`

- `source-material/` — the raw material a feature started from. Kept as-is,
  unversioned in structure, useful for tracing a requirement back to its
  origin later.
- `specs/<NNN>-<slug>/requirements.md` — the extracted result: testable,
  `REQ-<n>.<m>`-numbered, reviewed and approved, and scoped to what this
  repository has to do. This is what the rest of the workflow builds from —
  not the source doc itself.

A source document often describes a feature across several repositories.
Each of them can keep the same document in its own `source-material/`; each
spec extracts only its own repository's part.

If a spec was built from a doc in here, note the source file's name in
that spec's `requirements.md` so the link isn't lost.

## Conventions

No required naming scheme. If a doc clearly maps to one feature, naming
it to match that feature's eventual `specs/<NNN>-<slug>/` slug makes the
link obvious at a glance, but this isn't enforced — use whatever name the
source material already has (an exported ticket ID, a PRD title) when
that's clearer.

Two kinds of content end up here, kept apart by location:

- **Feature- or client-specific source material** — a PRD, a code dump, a
  set of facts for one particular build — goes in a subfolder, e.g.
  `source-material/<client>/`.
- **Cross-feature reference material** — a generic guide distilled from a
  prior build, meant to be reused across many future features rather than
  describing one of them — lives directly at the `source-material/` root,
  e.g. `source-material/context.md`. Keep this kind agnostic: no names of
  specific clients/features, just the shared system/platform facts and
  lessons that apply regardless of which one comes next.
