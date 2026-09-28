# Design: <feature name>

Status: draft

## Architecture (optional)

Omit when this repository's rules (its `CLAUDE.md` and the rules it points
at) already determine the architecture and the feature follows them as
written. Include only for what the rules don't settle: a boundary they
don't cover, or a deliberate departure from them — say which rule, and why.

- Rules followed: <the rule files that govern this, by path>
- Not covered by the rules / departs from them: <the boundary added, moved, or crossed — and why>

<optional diagram: the components below and how they connect>

## Component breakdown

| Component | Location | Added/Modified | Responsibility |
|---|---|---|---|
| <name> | <path or module in this repository> | Added | <one sentence> |
| <name> | <path or module in this repository> | Modified | <one sentence> |

## Folder structure (optional)

Omit when this repository's rules already say where each file of the
feature goes. Include only the folders or files whose location the rules
don't determine, or that deliberately depart from them, marking what is
new.

```
<root>/
├── <folder>/
│   ├── <file>            # new — <what it holds>
│   └── <file>            # modified
└── <folder>/             # new — <what belongs here>
```

## Patterns (optional)

Patterns belong to this specific implementation and can change from one
spec to the next, so they are chosen here, not inherited from the rules.
List every pattern the design relies on; omit the section only when the
feature needs none worth naming.

| Pattern | Applied to | Why here |
|---|---|---|
| <e.g. repository, strategy, adapter, outbox> | <component> | <the problem it solves in this feature> |

## Interfaces

```
<actual signatures and types, not descriptions — for an external dependency, the interface as this repository consumes or exposes it>
```

## Contracts

| Contract | This repository is | Counterpart | Revision |
|---|---|---|---|
| contracts/<name>.md | owner / consumer | <repository> — <its spec path> | <n> |

<or "none">

## Data flow

<the path a request takes through the components, step by step>

## Alternatives considered and rejected

### <alternative 1>

Rejected because: <reason>

### <alternative 2>

Rejected because: <reason>

## Requirement coverage

| REQ ID | Covered by |
|---|---|
| REQ-1.1 | <component> |
| REQ-1.2 | <component> |
| REQ-2.1 | <component> |

Uncovered requirements: <list, or "none">

## Risks

- <what could go wrong>
- <what is uncertain — including any external interface that is unknown, or a contract not yet copied to its counterparts>
