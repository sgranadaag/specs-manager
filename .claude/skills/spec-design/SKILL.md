---
name: spec-design
description: >
  Produce the technical design for an approved feature spec. Reads
  requirements.md, explores the codebase(s), and writes design.md with
  components (each tagged with the repository it lives in — features here
  are often microservice-shaped and span several repos), interfaces, data
  flow, and rejected alternatives. Use after requirements are approved, or
  when the user asks how a feature should be built or architected.
argument-hint: spec directory (optional, defaults to most recent)
allowed-tools: Read, Write, Glob, Grep
---

# Produce the technical design

## Precondition

Read `.status`. If it is not `requirements`, stop and report which phase
the spec is actually in.

## Step 1 — Understand the ground truth

First identify every repository this feature plausibly touches — a
requirement that crosses a service boundary (calls another service, adds
a field consumed elsewhere, changes a contract) implicates every repo on
both sides of that boundary, not just the one the request was made from.

Spawn subagents to investigate in parallel, one per repo when there's more
than one:

- Which existing modules does this touch, and what are their contracts?
- What patterns does that repo already use for this class of problem?
- What are its existing test conventions?

Do not design against an imagined codebase. Read the real one(s).

## Step 2 — Write design.md

Use `.claude/templates/design.md`. It must contain:

1. **Component breakdown** — what is added, what is modified, the
   responsibility of each, and **which repository it lives in**. One
   sentence per component. This repo column is load-bearing: `/spec-tasks`
   uses it to split the task list per repo, so every component needs one,
   even on a single-repo feature.
2. **Interfaces** — actual signatures and types, not descriptions of
   them. For a boundary crossed between two repos, show the contract
   from both sides (the caller's expectation and the callee's shape).
3. **Data flow** — the path a request takes through the components.
4. **Alternatives considered and rejected** — with the reason. This is
   the highest-value section of the entire document. It is what stops
   the next session (or the next engineer) from re-litigating a decision
   or "fixing" something that was deliberate.
5. **Requirement coverage table** — every `REQ-` ID mapped to the
   component(s) that satisfy it. Any uncovered requirement is a gap in
   the design; say so explicitly.
6. **Risks** — what could go wrong, what is uncertain.

## Step 3 — Stop

Write `design` to `.status`. Present the design and explicitly ask the
user to challenge the component boundaries and the rejected alternatives.

Do NOT write tasks. Do NOT write code.
