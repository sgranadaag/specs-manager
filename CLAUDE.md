# specs-manager

This repository follows spec-driven development. See `.claude/rules/spec-workflow.md`
for the workflow contract — it is loaded automatically every session.

Feature specs live in `specs/<NNN>-<slug>/`, committed to git alongside the
code they describe. Use the `/spec-new`, `/spec-design`, `/spec-tasks`,
`/spec-implement`, `/spec-commit`, `/spec-release`, and `/spec-verify`
skills to move a feature through the workflow phases.

`/spec-implement` never commits on its own — it leaves every change
unstaged so the diff can be reviewed first. `/spec-commit` is the
separate, explicit step that stages and commits already-implemented,
already-checked-off tasks once the user is ready. `/spec-release` is a
further separate step, only ever run on explicit request, that promotes
a committed feature branch through dev → qa → master and pushes all
four branches — the highest-blast-radius action in this workflow.
