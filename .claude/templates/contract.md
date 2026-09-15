# Contract: <name>

Revision: <n>
Owner: <repository that exposes the interface> — <its spec path>
Consumers:
- <repository that uses it> — <its spec path>

Every repository listed above keeps an identical copy of this file in its
own spec, at `contracts/<name>.md`; identical is what synchronized means.
Change it only by agreement: edit the owner's copy, bump the revision, add
a changelog row, copy the file to every consumer, and re-approve every
side's design. Never edit one copy alone.

## Satisfies

- <owner repository>: REQ-<n>.<m>
- <consumer repository>: REQ-<n>.<m>

## Interface

```
<the exact shape every side builds against: method and path, request and response bodies with field types, status codes, event names and payloads — not descriptions>
```

## Behavior

- **The owner guarantees**: <validation, error responses, idempotency, ordering, limits>
- **Consumers commit to**: <how they handle each error, retries, timeouts>

## Changelog

| Revision | Change | Agreed in |
|---|---|---|
| 1 | Initial contract | <owner spec path>, <consumer spec paths> |
