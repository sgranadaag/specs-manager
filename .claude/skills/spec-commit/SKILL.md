---
name: spec-commit
description: >
  Deliver a spec's implemented tasks. After asking which changes go in,
  which base branch to start from and which branch prefix to use, create a
  `<prefix>/<featureName>` branch from the synced base, commit the changes
  as one conventional commit per change type, record every commit in the
  spec's commits.md, push the branch, and offer to merge it into another
  branch. Run only when the user explicitly asks for it once implementation
  is finished — never automatically, and never as a follow-up
  /spec-implement starts on its own.
argument-hint: spec directory (optional, defaults to the spec in implementing)
disable-model-invocation: true
allowed-tools: Read, Write, Edit, Glob, Grep, Bash
---

# Commit and deliver implemented tasks

This skill turns the unstaged work `/spec-implement` left behind into a
pushed branch. It creates a branch, commits, pushes, and may merge into a
branch other people use — so the questions below are answered by the user
in this run before any of that happens. A skill existing to do this is not
standing authorization to do it, and neither is a previous run. If you
reached this skill any other way than the user asking for it in this
conversation, stop.

## Precondition

1. Find the spec to deliver: the one given in $ARGUMENTS, or else the spec
   whose `.status` is `implementing` — if more than one is, ask which.
2. `specs/<NNN>-<slug>/.status` must be `implementing`, and every task in
   `specs/<NNN>-<slug>/tasks.md` must be checked off `[x]`. If any task is
   still unchecked, stop and say which: implementation isn't finished, and
   this skill never implements anything.
3. Read the `## Spec workflow` section of this repository's `CLAUDE.md` for
   its **base branches** — the branches a delivery branch may start from.
   If it declares none, offer `main` and ask for any other.
4. Run `git fetch origin` and `git status`. There must be changes to
   deliver. If `HEAD` carries local commits that no base branch on `origin`
   has (`git log origin/<base>..HEAD`), stop and ask — work already
   committed elsewhere is not this skill's to move.

## Step 1 — Show the plan and ask

Nothing is created, staged, committed or pushed until the user has
answered. Prepare, from the working tree:

- **The changed files** (`git status --porcelain`, untracked included),
  each with the commit type you assign it (see "Grouping by type") and the
  task whose `Files:` line names it. Mark every file no task names — it may
  be leftover local work rather than part of the feature.
- **The commits** this will produce: one per type that has files, each
  with its subject.
- **The branch** that will be created: `<prefix>/<featureName>`.
  - `<prefix>` is one of the commit types in "Grouping by type". Propose the
    one that describes the delivery as a whole: the type of its most
    significant commit, taking the first type present in the order `feat` →
    `fix` → `perf` → `refactor` → `test` → `build` → `ops` → `docs` →
    `style` → `chore` (a delivery with any `feat` commit is `feat`).
  - `<featureName>` is the feature's name in English, camelCase, derived
    from the spec (`specs/004-payment-retry/` → `paymentRetry`).

Show that plan, and ask the user, in one batch:

1. **Which changes go in** — all of them, or all except the ones they name.
   Excluded files stay exactly as they are in the working tree: never
   stashed, reverted or discarded.
2. **The base branch** — one of the declared base branches. Never assume it.
3. **The branch prefix** — offer your proposal and let the user keep it or
   name another type from the list. The prefix they indicate is the one
   used.

The grouping, the subjects and the feature name are yours to decide; the
user doesn't need to confirm them, though their answer may correct any of
them. If the user excludes a file a task names, tell them which task that
leaves undelivered before going on — see "Status".

## Step 2 — Sync the base branch and create the branch

1. Check that the branch name exists neither locally nor on `origin`. If it
   does, stop and ask for another — never reuse or overwrite a branch on
   your own judgment. The one exception is a second run for the same spec
   where the user says to add to the branch the first run created: check
   that branch out instead of creating one, and go to Step 3.
2. Bring the local base branch level with `origin/<base>`, fast-forward
   only:
   - if the base is the branch checked out: `git merge --ff-only origin/<base>`;
   - otherwise: `git fetch origin <base>:<base>`.

   If the local base has commits `origin` doesn't, the two have diverged, or
   the fast-forward would touch files with uncommitted changes, **stop** and
   report it. Never reset, rebase, force or stash to get past it.
3. Create the branch from the synced base, carrying the uncommitted changes
   with it: `git switch -c <prefix>/<featureName> <base>`. If git refuses
   because local changes would be overwritten, stop and report those files:
   the implementation was done against a base that has changed underneath
   it, and reconciling the two is the user's call.

## Step 3 — One commit per type

### Grouping by type

Commits follow the
[Conventional Commits types](https://gist.github.com/qoomon/5dfcdf8eec66a051ecd85625518cfd13#types).
Decide each file's type yourself; every delivered file goes into exactly one
group:

| Type | What it holds |
| --- | --- |
| `feat` | Adds, adjusts or removes a feature of the API or UI — including the stylesheets, schemas and copy that feature renders |
| `fix` | Fixes a bug in an API or UI feature that already exists |
| `refactor` | Rewrites or restructures code without changing API or UI behavior |
| `perf` | A refactor whose purpose is performance |
| `style` | Code style only — whitespace, formatting, missing semicolons — with no effect on behavior |
| `test` | Adds missing tests or corrects existing ones |
| `docs` | Documentation only — READMEs, `CLAUDE.md`, `.claude/rules/`, spec artifacts and contracts |
| `build` | Build tooling, dependencies and lockfiles, project version, compiler and bundler configuration |
| `ops` | Infrastructure, deployment scripts, CI/CD pipelines, monitoring |
| `chore` | Anything no type above describes — `.gitignore`, repository housekeeping |

Classify by what the file's change *is*, not by the task it came from: a
test written for a feature task still goes in `test`, a lockfile in `build`.
`style` means code formatting, not a stylesheet — a stylesheet goes with the
`feat` or `fix` it styles. A file whose diff genuinely mixes two types goes
in the type that describes most of it; a file's hunks are never split
between commits.

### Committing

Commit the groups that have files, in this order, so each commit builds on
the ones before it: `build` → `ops` → `chore` → `refactor` → `perf` → `fix`
→ `feat` → `style` → `test` → `docs`. For each group:

1. Stage exactly that group's files by path (`git add -- <paths>`, which
   also stages deletions and renames of those paths) — never `git add -A`
   or `git add .`. Run `git status` and check that only this group is
   staged.
2. Commit with a subject in the format `<type>: <description>`:
   - the description is in the imperative present tense ("add", not
     "added"), starts lowercase and has no trailing period —
     `feat: add retry policy to the payment client`;
   - no scope unless the repository's `git log` already uses scopes, and
     never a task ID, REQ ID or issue number as one;
   - when `design.md` says the change breaks an existing interface, add `!`
     before the colon and a `BREAKING CHANGE: <what breaks>` footer.
3. If a commit hook fails, stop and report its output. Never commit with
   `--no-verify`; the hook is part of the gate.
4. Note the commit's short hash.

## Step 4 — Push

Push the branch: `git push -u origin <prefix>/<featureName>`. Never
force-push. If the push is rejected, stop and report it rather than
pulling, rebasing or forcing — the commits stay on the local branch and
nothing is recorded yet.

## Step 5 — Record the delivery

1. Write `specs/<NNN>-<slug>/commits.md` from `.claude/templates/commits.md`:
   the branch and the base it started from, one entry per commit — its
   type, hash and subject, a one- or two-sentence summary of what it
   groups, the tasks it delivers, and every file it contains — and the
   files excluded in Step 1. On a second run for the same spec, add this
   run's entries below the existing ones.
2. Append ` — committed <hash>` to the line of every task in `tasks.md`
   whose files a commit contains; a task spread over two groups gets both
   hashes.
3. Set `.status` — see "Status".
4. Commit those three spec files as `docs: record <featureName> delivery`
   and push again. This bookkeeping commit is the one `commits.md` doesn't
   list, since it is the commit that contains it.

## Step 6 — Offer a merge, then stop

Show the user `commits.md` and ask whether to:

- **leave the branch as it is** — for a pull request, or for later; or
- **merge it into another branch**, which they name.

Only on an explicit "merge into `<target>`":

1. Switch to `<target>` and bring it level with `origin/<target>` under the
   same fast-forward-only rules as Step 2.
2. `git merge --no-ff <prefix>/<featureName>`, keeping git's default
   `Merge branch '<branch>'` message. If it conflicts, **stop**: report the
   conflicting files and leave the merge for the user to resolve, or abort
   it with `git merge --abort` if they prefer. Never pick a side.
3. Push `<target>`, never forced. If the push is rejected, stop and report
   it.
4. Switch back to the delivery branch.

The merge is recorded by git, not in `commits.md`, which describes the
delivery branch. Whichever the user chose, the skill ends here: tell them
the branch, the commits, where it was merged if it was, and that
`/spec-verify` is the next step.

## Status

- **`done`** — every file a task names was committed and the branch was
  pushed. This is what `/spec-verify` requires.
- **stays `implementing`** — the user excluded a file a task names.
  `commits.md` lists what was held back, and a later run of this skill
  delivers it. A run that stops before Step 5 changes no status at all.

Do not implement or change code here: this skill only groups, commits,
pushes and merges work that already exists.
