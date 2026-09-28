---
name: spec-design
description: >
  Produce the technical design for an approved feature spec in this
  repository. Reads requirements.md, explores the codebase, writes design.md
  with components, interfaces, data flow and rejected alternatives, and
  writes — or takes over from the other side — the contract file for every
  interface the feature must agree with another repository. Use after
  requirements are approved, or when the user asks how a feature should be
  built or architected.
argument-hint: spec directory (optional, defaults to most recent)
allowed-tools: Read, Write, Glob, Grep
---

# Produce the technical design

## Precondition

Read `.status`. If it is not `requirements`, stop and report which phase
the spec is actually in.

## Step 1 — Understand the ground truth

Investigate this repository — spawning subagents in parallel, one per area,
when the feature touches more than one:

- Which existing modules does this touch, and what are their contracts?
- What patterns and rules does this repository already use for this class
  of problem? Read its `CLAUDE.md` and any rules it points at before
  proposing a structure of your own.
- What are its verification conventions — its declared verification gate,
  and which layers its testing rules give a dedicated test versus cover
  indirectly?

For each external dependency **relied on as is**, read its interface as it
is documented — its published API, `specs/source-material/`, the client
this codebase already has for it. Design against that interface, not
against guesses about its internals; where it is unknown, it goes in Risks.

Do not design against an imagined codebase. Read the real one.

## Step 2 — Contracts to agree

For each dependency requirements.md marks as **a contract to agree**:

- **If the counterpart repository's spec already has the contract**, copy
  that file byte for byte into this spec's `contracts/<name>.md` — asking
  the user for it when that repository isn't available on this machine —
  and design on top of it as it is. Anything this side needs changed is
  proposed to the user as a new revision for every side to agree, never
  edited into this copy on its own.
- **Otherwise**, write `contracts/<name>.md` from
  `.claude/templates/contract.md`: the owner (the side that exposes the
  interface) and consumers, each with its spec; the exact interface; what
  each side commits to; and revision 1.

A contract file holds only what every side shares — never a detail of how
one side implements it. Tell the user that every counterpart spec needs an
identical copy before any task that names the contract can be implemented.

## Step 3 — Write design.md

Use `.claude/templates/design.md`. It must contain:

1. **Component breakdown** — what is added, what is modified, where each
   lives in this repository, and its responsibility. One sentence per
   component.
2. **Interfaces** — actual signatures and types, not descriptions of
   them. For an external dependency, the interface as this repository
   consumes or exposes it.
3. **Contracts** — every file from Step 2: whether this repository is its
   owner or a consumer, the counterpart repository and its spec, and the
   revision this design is built on.
4. **Data flow** — the path a request takes through the components.
5. **Alternatives considered and rejected** — with the reason. This is
   the highest-value section of the entire document. It is what stops
   the next session (or the next engineer) from re-litigating a decision
   or "fixing" something that was deliberate.
6. **Requirement coverage table** — every `REQ-` ID mapped to the
   component(s) that satisfy it. Any uncovered requirement is a gap in
   the design; say so explicitly.
7. **Risks** — what could go wrong, what is uncertain, and every external
   interface that is unknown or every contract not yet copied to its
   counterparts.

**Architecture** and **Folder structure** are optional and conditioned on
this repository's rules (its `CLAUDE.md` and the rules it points at, read
in Step 1). When the rules already determine that aspect and the feature
follows them, delete the heading: restating the rules adds nothing and
drifts from them when they change. Include a section only for what the
rules leave open, or where the design deliberately departs from them —
name the rule, say why, and add the option the rules would have given to
"Alternatives considered and rejected".

**Patterns** is not conditioned on the rules: patterns belong to the
specific implementation and can change from one spec to the next. List
every pattern the design relies on, where it applies and why; delete the
heading only when the feature needs none worth naming. A pattern chosen
over another goes in "Alternatives considered and rejected" too.

Never leave an optional section empty or filled with generic text.

## Step 4 — Stop

Write `design` to `.status`. Present the design and explicitly ask the
user to challenge the component boundaries, the contracts and the rejected
alternatives.

Do NOT write tasks. Do NOT write code.
