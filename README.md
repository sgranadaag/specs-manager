# specs-manager

A portable **spec-driven development** toolkit for Claude Code. Drop it into
any repository — a front end, a back end, a library — to get a structured
requirements → design → tasks → implement → commit → verify workflow,
enforced by a hook rather than by hoping everyone remembers the process.

## Why

Nowadays, most of what we develop can include, or be supported by, an AI
generator, and new technologies and modern workflows keep pushing our steps
in that direction. If, at this point, you don't see the need to use AI in
your development process, you are probably falling behind.

The thing with AI is that, the moment you start typing and asking it for a
specific implementation, you also start writing a history of related data:
that is called **context**. Context is unstable and gets corrupted easily,
so preserving it and staying on the same line is the most challenging part
of bringing AI into your development process. There is another problem:
every time you start a new conversation, the context starts from scratch.
If you need to roll back a change made earlier, finding it becomes very
difficult, because the new context knows nothing about it.

To solve this, a methodology called **Spec-Driven Development** appeared.
Basically, it defines how to take advantage of AI while making sure it
always has an up-to-date context, and it keeps a history of the changes
made. A spec can take several shapes and be divided into different sets of
steps; we'll talk about that below.

## Spec-driven models

There are three different ways to apply this methodology:

1. **Spec-first** — for me, the most useful one (at least at this point).
   You define all the requirements, or specs, at the beginning, and then the
   required implementation is made. Once it is, the spec is no longer
   required: you become the owner of the code, and changing, reviewing and
   structuring it — and leading the decisions to keep delivering features —
   is your responsibility. At no moment do you lose control over the code;
   the AI only plays the role of an assistant.
2. **Spec-anchored** — similar to spec-first; the main difference is that
   you and the AI share both the spec and the code, so both are responsible
   for applying changes and maintaining the whole flow. The spec is designed
   to keep changing as the process moves forward, and preserving it matters
   because it tells us what the code does and why it was designed that way:
   it is the source of the first implementation and holds the whole history
   of the requirements.
3. **Spec-as-source** — the most extreme version of the model. The AI owns
   all the code, and you only interact with it through the spec, so the
   spec becomes the source of truth and the application's behavior depends
   entirely on how you define it. I think this approach could become a very
   powerful tool once we are sure AI can build an application with all of
   its edge cases. For now, in my opinion, AI can't manage a whole project by
   itself, for one reason: it is very literal about your specifications and
   can't handle things like inconsistencies and redundancies in them, so it
   may write very good code with a complexity your need doesn't require.

![Levels of spec-driven development: spec-first, spec-anchored and spec-as-source, across the creation and the evolution of a feature](https://martinfowler.com/articles/exploring-gen-ai/sdd-levels.png)

*Source: [Exploring Generative AI — martinfowler.com](https://martinfowler.com/articles/exploring-gen-ai.html)*

> **This toolkit follows the spec-first approach.** Although Claude is the
> main developer in this process, we play the role of supervisor: we read
> everything that was generated, bring it in line with our rules, standards
> and architecture, and make sure it works as expected.

## Rules

Before describing the workflow itself, it's important to talk about
**rules**. Rules are the boundaries we define for Claude: folder structure,
naming conventions, responsibility layers, styling, testing. They tell
Claude how it has to develop everything — how to name things, what
architecture we chose — and they keep the same standard across all the
code. Without them, Claude could use different technologies, approaches and
architectures every time.

Rules are **out of the scope of this project**, because they change between
companies and stacks: they live in your own repository, in `.claude/rules/`,
next to the workflow contract this toolkit adds. Still, defining them is the
first step to making sure everything works nicely.

## Workflow

The workflow is composed of a set of **skills**. At each step of the
process, Claude (or any AI assistant) runs a skill and produces an
**artifact** — the most important and representative part of this model. An
artifact is the output of a step: a Markdown file holding everything that
was defined in it. You can, and should, read each artifact, understand it,
reorganize it, and only then continue with the next step. That is what lets
us keep control over what we are going to build and how Claude will build
it.

```
requirements → design → tasks → implement → commit → verify
```

Each step needs your explicit approval before the next one begins, and the
current phase of a spec is stored in `specs/<NNN>-<slug>/.status`. Below are
the skills involved and the artifact each one creates.

### 1. `/spec-new` — requirements

This is the initial skill. Run it with a brief description of what you are
going to build. There is also a folder,
[`specs/source-material/`](specs/source-material/README.md), where you can
drop documents with additional information for the requirement — data
formats, input data, connections, initial requirements, prototypes. Claude
reads everything you provide, asks whatever it needs to build the
requirement, and writes the artifact **`requirements.md`** with all that
information grouped together. You can then continue with the next step or
make any correction you consider necessary — ask Claude to update the
requirement, or edit it yourself.

This step tells us **WHAT** we are going to do.

### 2. `/spec-design` — design

This step defines where the changes are going to be made: which structure,
which technologies and which restrictions apply. It is the most technical
step, and the point to tell Claude how to structure everything, where the
data comes from, and which patterns and architecture to follow. If you need
a specific technology, or have to connect to a specific service, this is the
place.

The artifact is **`design.md`**, with the whole solution described,
including specific implementation parts — controllers, repositories, types,
utils, components, styles, tests. When the feature defines an interface
together with another repository, this step also writes the shared contract
in `contracts/` (see [One repository, one spec](#one-repository-one-spec)).

This step tells us **WHERE** Claude is going to build everything.

### 3. `/spec-tasks` — tasks

Here we take the requirements (*what*) and the design (*where*) and join
them into a list of tasks. The tasks set the order Claude will follow to
implement everything: depending on the process, a task can be independent or
depend on other tasks. The artifact is **`tasks.md`**, a list of tasks
ordered by their dependencies, which can be implemented one by one, or in
parallel when they don't depend on each other.

This step tells us **HOW**.

### 4. `/spec-implement` — coding

This is where the magic happens. Claude builds on every previous artifact
and starts coding, following the [rules](#rules) you defined. This point is
fairly safe, because by now everything has been read and defined, with
Claude's questions filling in the edge cases — a process usually called
*refinement*.

This is also where this workflow splits from the usual process. The usual
approach says we are not part of the coding step, so Claude can write the
code, commit it and even push everything. In my opinion that is
**dangerous** — I don't have that much confidence in AI yet. So I moved
committing and delivering into a separate step (described below), and
`/spec-implement` leaves every change **unstaged**.

Once the code is finished, it is our turn: review everything that was
created, and refine whatever doesn't follow what we defined. Claude is very
good at following your idea and making everything work, but, being as
literal as described in [Spec-driven models](#spec-driven-models), it can
make some things more complex than they need to be. The real work at this
point is not writing code — it is understanding what Claude did and making
sure it matches what we defined.

### 5. `/spec-commit` — delivery

Congratulations: you have developed a feature using the spec-driven model.
But one step is still missing — the whole delivery process. That's why I
created this skill, and it runs **only when you ask for it**. It:

1. asks which changes go in (you can exclude any of them), which base branch
   to start from, and which branch prefix to use — proposing one based on
   the changes;
2. syncs the base branch with the remote and creates a new branch named
   `<prefix>/<featureName>` (feel free to change this structure);
3. splits the code into well-defined groups, one commit per type, following
   the [Conventional Commits types](https://gist.github.com/qoomon/5dfcdf8eec66a051ecd85625518cfd13#types);
4. pushes the branch and writes the artifact **`commits.md`**, with each
   commit's hash, a summary of what it groups and the files it includes;
5. offers to merge the branch into another one — for example, if you want
   to take it straight to `qa` — or to leave it as it is.

Nice! Your code is now pushed to your repository.

### 6. `/spec-verify` — audit

In this last step, Claude audits what was delivered against the spec and
gives us a report:

- **Coverage** — every requirement, the code that implements it, the task
  that delivered it, and the test that covers it.
- **Drift** — anywhere the code diverges from `design.md`.
- **Scope** — changes that no task asked for.
- **Contracts** — whether this repository honors every contract it shares
  with another one.

### Quality along the way

Beyond reviewing the code ourselves, the workflow has one more guideline to
keep quality up: **after every task**, Claude runs the verification gate you
declare in your `CLAUDE.md` — updating the tests, building the project and
running the lint rules, for example. Which tests exist depends on each
company and repository; in my case, I ask Claude to test only the business
rules and, in front-end projects, the visual components. That way the code
is safe at every moment, not just at the end.

## One repository, one spec

Each repository keeps its own specs: its own requirements, design and tasks,
for its own part of a feature. When a feature also needs changes in another
repository, that repository runs this same workflow with its own copy of the
toolkit; here, the other side is just an **external dependency**.

When both repositories build an interface together — an endpoint one adds
and the other calls, an event one emits and the other consumes — that
interface becomes a **contract**: a file in `specs/<NNN>-<slug>/contracts/`
that every repository involved keeps an **identical** copy of. It changes
only by agreement (update the owner's copy, bump the revision, copy it to
the others), and a task that implements a contract isn't built while the
copies differ. The full rules are in
[`.claude/rules/spec-workflow.md`](.claude/rules/spec-workflow.md).

## Layout

What the toolkit adds to a repository, and what each spec produces:

```
your-repo/
├── CLAUDE.md                          # yours — including its "## Spec workflow" declarations
├── .claude/
│   ├── rules/
│   │   ├── spec-workflow.md           # the workflow contract, loaded every session
│   │   └── …                          # yours — folder structure, naming, testing…
│   ├── skills/
│   │   ├── spec-new/SKILL.md          # /spec-new        → requirements.md
│   │   ├── spec-design/SKILL.md       # /spec-design     → design.md (+ contracts/)
│   │   ├── spec-tasks/SKILL.md        # /spec-tasks      → tasks.md
│   │   ├── spec-implement/SKILL.md    # /spec-implement  → code and tests, left unstaged
│   │   ├── spec-commit/SKILL.md       # /spec-commit     → branch, commits, push → commits.md
│   │   └── spec-verify/SKILL.md       # /spec-verify     → audit report
│   ├── templates/
│   │   ├── requirements.md
│   │   ├── design.md
│   │   ├── contract.md
│   │   ├── tasks.md
│   │   └── commits.md
│   ├── hooks/
│   │   └── gate.sh                    # blocks source edits outside the implement phase
│   └── settings.json                  # registers the hook and sets SPEC_GATE_PATHS
└── specs/
    ├── README.md
    ├── source-material/               # raw input — PRDs, tickets, data formats, prototypes
    │   └── README.md
    └── 004-payment-retry/             # one folder per feature
        ├── requirements.md            # WHAT this repository has to do
        ├── design.md                  # WHERE it is built
        ├── contracts/
        │   └── payment-retry.md       # only for an interface built with another repository
        ├── tasks.md                   # HOW, step by step
        ├── commits.md                 # what /spec-commit delivered
        └── .status                    # requirements | design | tasks | implementing | done
```

`specs/` lives at the repository root, not hidden inside `.claude/`: these
are engineering artifacts and should be as visible as the code. See
[`specs/README.md`](specs/README.md) and
[`specs/source-material/README.md`](specs/source-material/README.md) for
what belongs in each.

## The enforcement hook

Skills and rules are instructions, and a model can misjudge an instruction
under pressure. So the toolkit also ships a hook that makes its most
important rule — **no source code is written outside the implementation
phase** — impossible to skip.

[`.claude/hooks/gate.sh`](.claude/hooks/gate.sh) is registered in
[`.claude/settings.json`](.claude/settings.json) as a `PreToolUse` hook, so
Claude Code runs it before every `Edit` or `Write`:

1. If the file is **not** under your source paths, the edit goes through.
   Source paths come from `SPEC_GATE_PATHS` in `.claude/settings.json`
   (`src/` by default), so specs, docs and configuration can always be
   edited.
2. If the repository has no specs yet, the edit goes through.
3. If **any** spec's `.status` is `implementing`, the edit goes through —
   writing the next spec's requirements never blocks finishing the current
   one.
4. Otherwise, the edit is **blocked**, and Claude receives a message saying
   which phase is still pending.

It only needs `bash` (Git Bash on Windows); `jq` is used when it's
installed, but it isn't required.

## Using this in another repository

The `main` branch of this repository contains only the toolkit — no project
structure and nothing stack-specific — so it can be brought into any
repository in two ways.

### Option 1: copy the files

1. Copy these paths into the target repository:
   - `.claude/rules/spec-workflow.md`
   - `.claude/skills/` (the six `spec-*` folders)
   - `.claude/templates/`
   - `.claude/hooks/gate.sh`
   - `.claude/settings.json` — or, if the repository already has one, merge
     its `env` and `hooks` entries into it
   - `specs/README.md` and `specs/source-material/README.md`
2. Run `chmod +x .claude/hooks/gate.sh` — permissions don't survive a plain
   copy.

To update later, copy the same paths again.

### Option 2: add this repository as a remote

Because the toolkit carries no project structure, you can also pull it
straight from git:

1. Add the remote and fetch it:

   ```bash
   git remote add specs git@github.com:sgranadaag/specs-manager.git
   git fetch specs
   ```

2. Check out only the toolkit's paths:

   ```bash
   git checkout specs/main -- .claude/rules/spec-workflow.md .claude/skills .claude/templates .claude/hooks specs/README.md specs/source-material/README.md
   ```

3. Bring in `.claude/settings.json` the same way only if the repository
   doesn't have one yet (`git checkout specs/main -- .claude/settings.json`);
   otherwise, merge its `env` and `hooks` entries by hand.
4. Commit the result in your repository like any other change. If the hook
   isn't executable after the checkout, run `chmod +x .claude/hooks/gate.sh`.

To update, run `git fetch specs` and repeat steps 2 and 4.

Keep in mind:

- **Don't `git merge specs/main`.** The histories are unrelated, and this
  repository's own `README.md` and `CLAUDE.md` would collide with yours.
  Checking out the toolkit's paths brings only the toolkit and leaves your
  history untouched.
- **A checkout adds and overwrites files, but never deletes them.** When the
  toolkit removes a file — a skill that no longer exists, for example —
  delete it from your repository by hand.

### Then, in either case

1. Add a `## Spec workflow` section to the repository's `CLAUDE.md`. These
   declarations are what keep the skills independent of any stack:

   | Declaration | Meaning | If absent |
   | --- | --- | --- |
   | **Source paths** | Directories that can only be edited while a spec is `implementing` | `src/` |
   | **Verification gate** | Commands that must pass after every task, plus any manual check | The skill stops and asks |
   | **Testing rules** | Where the repository says which layers get a dedicated test | The skill stops and asks |
   | **Base branches** | Branches a `/spec-commit` delivery branch may start from | `main`, and the skill asks for others |

   For example:

   ```markdown
   ## Spec workflow

   - **Source paths**: `src/`
   - **Verification gate**: `npm run typecheck && npm run lint && npm test && npm run build`, plus a look in `npm run dev` for anything visual
   - **Testing rules**: `.claude/rules/testing.md`
   - **Base branches**: `main`, `dev`
   ```

2. Set `SPEC_GATE_PATHS` in `.claude/settings.json` to the same source paths.
3. Check the hook's input and exit-code behavior against the current
   [Claude Code hooks documentation](https://code.claude.com/docs/en/hooks)
   before relying on it — it's the piece most likely to change between
   Claude Code versions.

Then start your first feature:

```
/spec-new short description of the feature
```
