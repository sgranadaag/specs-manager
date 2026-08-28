---
name: spec-new
description: >
  Start a new feature spec. Creates specs/<NNN>-<slug>/requirements.md by
  reading any source document the user provides, asking which
  repositories are involved and each one's role, and interviewing the
  user about scope, behavior, and acceptance criteria. Use this whenever
  the user wants to start a new feature, describes something they want
  built, or says "spec this out" — even if they don't use the word "spec".
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
file, or something the user references ("the doc I sent", "see the
mockups"). If images are involved (mockups, screenshots, diagrams), read
those too — Read handles images directly.

If a document exists, read it in full and extract as much as it actually
contains before asking anything:

- the problem and who it's for
- in-scope / out-of-scope statements
- acceptance criteria and conditions, as given
- mockups or visual references, and what they show
- domain vocabulary and constraints already stated

Do not silently fill gaps the document leaves open — that's what Step 4
is for. Do not re-ask the user something the document already answered;
instead, restate your extraction back to them ("from the doc, I have X,
Y, Z") so they can correct a misread before it propagates into
requirements.md.

If there is no source document, this step is a no-op — proceed to Step 3
with nothing pre-filled.

## Step 3 — Repositories and roles

Before or alongside the interview, ask which repositories this feature
involves and what each one's role is (e.g. "payment-service: owns retry
logic and persistence", "checkout-frontend: shows retry status to the
user"). Features here are frequently microservice-shaped; guessing this
from a single codebase produces a design that's wrong about its own
boundaries before anything else is even considered.

If the source document from Step 2 already names services or systems
involved, propose that list back to the user for confirmation rather
than asking from scratch — but still confirm; a document written before
implementation is not guaranteed to name every repo that ends up
involved.

Record the answer — it drives Step 5's codebase exploration and becomes
the "Repositories involved" section of requirements.md, which
`/spec-design` starts from when it tags each component with its repo.

## Step 4 — Interview BEFORE writing

This is the step that determines whether the whole workflow is worth
anything. Do not skip it and do not guess — including for anything the
source document left ambiguous or didn't cover.

Ask about, in one batch (skip anything Step 2 already answered clearly;
note what you're skipping and why so the user can correct it):

- Who uses this and what problem does it solve for them?
- What is explicitly OUT of scope?
- What are the failure modes — what happens when the input is bad, the
  network drops, the dependency is down?
- What are the observable acceptance criteria? (If you cannot write a
  test from a criterion, it is not a criterion.)
- Are there existing patterns in the relevant repo(s) this must follow?

If an answer is vague, ask again. A vague requirement produces confidently
wrong code with full traceability, which is worse than no spec.

## Step 5 — Explore the codebase(s)

Spawn a subagent per repo named in Step 3 to map the parts of that
codebase this feature touches: existing modules, patterns, and naming
conventions. Have each return a summary, not file contents — this keeps
the main context clean.

## Step 6 — Write requirements.md

Use `.claude/templates/requirements.md`. Rules:

- Include a "Repositories involved" section listing each repo from
  Step 3 and its role, in plain terms — not a technical design, just
  what part of the problem it owns.
- Numbered, stable IDs: `REQ-1.1`, `REQ-1.2`, …
- Each requirement is testable and about observable behavior.
- NO implementation detail. "Retries failed payments" is a requirement.
  "Uses exponential backoff with jitter" is a design decision — it goes
  in design.md.
- Include a "Non-goals" section. Explicit exclusions prevent scope creep
  more effectively than any other single technique.
- Include an "Open questions" section for anything unresolved — including
  anything the source document left ambiguous. Do not paper over
  uncertainty with a plausible-sounding sentence.

## Step 7 — Stop

Write `requirements` to `.status`. Present the requirements to the user
and ask for approval or corrections.

Do NOT proceed to design. Do NOT write code. Wait.
