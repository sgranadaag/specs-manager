# Design: <feature name>

Status: draft

## Component breakdown

| Component | Location | Added/Modified | Responsibility |
|---|---|---|---|
| <name> | <path or module in this repository> | Added | <one sentence> |
| <name> | <path or module in this repository> | Modified | <one sentence> |

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
