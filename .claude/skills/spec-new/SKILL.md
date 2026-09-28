---
name: spec-new
description: >
  Start a new feature spec in this repository. Creates
  specs/<NNN>-<slug>/requirements.md by reading any source document the
  user provides, scoping the feature to what this repository has to do,
  identifying its external dependencies and any contract it must agree with
  another repository, and interviewing the user about scope, behavior, and
  acceptance criteria. Use this whenever the user wants to start a new
  feature, describes something they want built, or says "spec this out" —
  even if they don't use the word "spec".
argument-hint: short feature description, or a path/paste of a source document
disable-model-invocation: false
allowed-tools: Read, Write, Glob, Grep, Bash(git status:*), Bash(ls:*)
---

# Create a feature specification

## Step 1 — Locate

Find the highest existing number in `specs/` and increment it. Derive a
kebab-case slug from $ARGUMENTS. Create `specs/<NNN>-<slug>/`.

## Step 2 — Read the source document, if there is one

Sometimes this starts from nothing but a conversation. Sometimes the user
already has a document — a requirement writeup, a ticket, a PRD, mockups —
that's the first source of truth. Check for one before assuming there
isn't: a file path or pasted long-form content in $ARGUMENTS, an attached
file, something the user references ("the doc I sent", "see the
mockups"), or a matching file under `specs/source-material/` (see its
`README.md`). If images are involved (mockups, screenshots, diagrams),
read those too — Read handles images directly.

If a document exists, read it in full and extract as much as it actually
contains before asking anything:

- the problem and who it's for
- in-scope / out-of-scope statements
- acceptance criteria and conditions, as given
- mockups or visual references, and what they show
- the repositories, services and systems it names
- domain vocabulary and constraints already stated

Do not silently fill gaps the document leaves open — that's what Step 4
is for. Do not re-ask the user something the document already answered;
instead, restate your extraction back to them ("from the doc, I have X,
Y, Z") so they can correct a misread before it propagates into
requirements.md.

If there is no source document, this step is a no-op — proceed to Step 3
with nothing pre-filled.

## Step 3 — Scope it to this repository

A spec describes what **this** repository has to do. Before or alongside
the interview, establish:

- **What this repository owns** in the feature — the part of the problem
  that is built here.
- **Its external dependencies** — every system outside this repository the
  feature relies on (another service, an API, a shared library, a
  third-party provider) and what it expects of each. Classify each one:
  - **relied on as is** — an interface that already exists and this feature
    doesn't change;
  - **a contract to agree** — an interface this feature defines or changes
    together with another repository: an endpoint one side adds and the
    other calls, a field, an event. Note which repository it is, which side
    exposes the interface, and whether that repository already has a spec
    for its part — if it does, the contract file in that spec is the
    starting point `/spec-design` builds on.

If the source document describes a feature spanning several repositories,
propose back which part belongs here and which parts are external, and
confirm it — a document written before implementation is not guaranteed to
draw that line where the code will. The parts that belong to other
repositories are specced there, with their own copy of this workflow; here
they are only dependencies.

Record the answer — it becomes the "External dependencies" section of
requirements.md, which `/spec-design` starts from.

## Step 4 — Interview BEFORE writing

This is the step that determines whether the whole workflow is worth
anything. Do not skip it and do not guess — including for anything the
source document left ambiguous or didn't cover.

Ask about, in one batch (skip anything Step 2 already answered clearly;
note what you're skipping and why so the user can correct it):

- Who uses this and what problem does it solve for them?
- What is explicitly OUT of scope?
- What are the failure modes — what happens when the input is bad, the
  network drops, an external dependency is down or answers something
  unexpected?
- What are the observable acceptance criteria? (If you cannot write a
  concrete check from a criterion, it is not a criterion.)
- What must be true before each behavior can happen (preconditions), and
  what is guaranteed once it has happened (postconditions)?
- What business rules govern it — limits, calculations, permissions,
  invariants the domain imposes regardless of the screen or endpoint?
- Are there existing patterns in this repository this must follow?

If an answer is vague, ask again. A vague requirement produces confidently
wrong code with full traceability, which is worse than no spec.

## Step 5 — Explore this repository

Map the parts of this repository the feature touches: existing modules,
patterns, naming conventions, and the rules its `CLAUDE.md` points at. When
the feature touches several areas, spawn a subagent per area and have each
return a summary, not file contents — this keeps the main context clean.

## Step 6 — Write requirements.md

Use `.claude/templates/requirements.md`. Rules:

- Include an "External dependencies" section: each dependency from Step 3,
  what this feature expects of it, and its kind — relied on as is, or a
  contract to agree with a named repository. Write "none" when there are
  none.
- Numbered, stable IDs: `REQ-1.1`, `REQ-1.2`, …
- Business rules go in the "Business rules" section with their own IDs
  (`BR-1`, `BR-2`, …), stated once and cited by the requirements they
  govern. A rule that only one requirement needs still gets a `BR-` ID if
  it is a rule of the domain rather than a behavior of this feature. Write
  "none" when there are none.
- Every capability area states its preconditions and postconditions.
  Preconditions are what must hold before; postconditions are what is
  guaranteed after — both observable, neither an implementation step.
- Every requirement has at least one acceptance criterion `AC-n.m` in
  Given / When / Then form, naming the `REQ-` it verifies. Every business
  rule is exercised by at least one criterion. A criterion is concrete
  enough to become a test as written — specific values, not "valid input".
- Each requirement is verifiable, about observable behavior, and about
  this repository — never a requirement another repository has to meet.
- NO implementation detail. "Retries failed payments" is a requirement.
  "Uses exponential backoff with jitter" is a design decision — it goes
  in design.md.
- Include a "Non-goals" section. Explicit exclusions prevent scope creep
  more effectively than any other single technique.
- Include an "Open questions" section for anything unresolved — including
  anything the source document left ambiguous. Do not paper over
  uncertainty with a plausible-sounding sentence.
- If the spec was built from a file in `specs/source-material/`, name
  that file in the summary so the link back to its origin isn't lost.

## Step 7 — Stop

Write `requirements` to `.status`. Present the requirements to the user
and ask for approval or corrections.

Do NOT proceed to design. Do NOT write code. Wait.
