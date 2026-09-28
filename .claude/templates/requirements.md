# Requirements: <feature name>

Status: draft

## Summary

One paragraph: what this feature does, who it's for, and which part of it
this repository owns.

## External dependencies

| Dependency | What this feature expects of it | Kind |
|---|---|---|
| <system outside this repository> | <the interface or behavior relied on> | relied on as is |
| <repository> | <the interface to agree on> | contract to agree — this repository is <owner / consumer>; its spec: <path, or "not yet"> |

<or "none">

## Business rules

Domain rules that hold regardless of which requirement exercises them.
Requirements and acceptance criteria reference them by ID.

- BR-1: <rule the domain imposes — a limit, a calculation, a permission, an invariant>
- BR-2: <rule the domain imposes>

<or "none">

## Requirements

### REQ-1: <capability area>

Preconditions:

- <what must be true before this behavior can happen — state, permissions, inputs>

Requirements:

- REQ-1.1: <testable, observable behavior statement> (BR-<n>)
- REQ-1.2: <testable, observable behavior statement>

Postconditions:

- <what is guaranteed to be true once it has happened — state changed, data persisted, event emitted>

Acceptance criteria:

- AC-1.1: Given <context>, when <action>, then <observable result> — verifies REQ-1.1
- AC-1.2: Given <context>, when <action>, then <observable result> — verifies REQ-1.2

### REQ-2: <capability area>

Preconditions:

- <what must be true before this behavior can happen>

Requirements:

- REQ-2.1: <testable, observable behavior statement>
- REQ-2.2: <testable, observable behavior statement>

Postconditions:

- <what is guaranteed to be true once it has happened>

Acceptance criteria:

- AC-2.1: Given <context>, when <action>, then <observable result> — verifies REQ-2.1
- AC-2.2: Given <context>, when <action>, then <observable result> — verifies REQ-2.2

## Failure modes

- <what happens on bad input>
- <what happens when a precondition is not met or a business rule is violated>
- <what happens when an external dependency is unavailable or answers something unexpected>
- <what happens on partial failure>

## Non-goals

- <explicitly out of scope, and why>
- <what other repositories do for this feature — their own specs cover it>

## Open questions

- <anything unresolved — do not paper over with a guess>
