#!/usr/bin/env bash
# PreToolUse hook: block source edits when THIS repo's slice of the active
# spec is not in the `implementing` phase.
#
# Tasks are split per repository (specs/<NNN>-<slug>/tasks/<repo>.md,
# specs/<NNN>-<slug>/tasks/<repo>.status) since features here are often
# microservice-shaped and span several repos. This hook only ever checks
# the status of the repo it's running in — a sibling repo being ahead or
# behind in the same feature has no bearing here.
#
# Claude Code passes the tool invocation as JSON on stdin. We read the
# target path, and if it is under src/, check this repo's own status
# file for the newest spec. Exit 2 = block the tool call and return the
# message to Claude.

set -euo pipefail

input=$(cat)
path=$(printf '%s' "$input" | jq -r '.tool_input.file_path // empty')

# Only guard source files.
[[ "$path" == *"/src/"* || "$path" == src/* ]] || exit 0

# Newest spec directory by name (specs are zero-padded and ordered).
spec=$(ls -d specs/*/ 2>/dev/null | sort | tail -1 || true)
[[ -n "$spec" ]] || exit 0

# Repo name convention matches what /spec-tasks and /spec-implement use:
# the working tree's root directory name.
repo=$(basename "$(git rev-parse --show-toplevel 2>/dev/null || pwd)")
repo_status_file="${spec}tasks/${repo}.status"

if [[ ! -f "$repo_status_file" ]]; then
  echo "BLOCKED: no task file found for repo '${repo}' under spec '${spec}'. \
Run /spec-tasks to split tasks per repo before implementing here (or this \
repo isn't actually part of this feature)." >&2
  exit 2
fi

status=$(cat "$repo_status_file" 2>/dev/null || echo "none")

if [[ "$status" != "implementing" ]]; then
  echo "BLOCKED: repo '${repo}' is in phase '${status}' for spec '${spec}'. \
Source edits are only permitted in the 'implementing' phase. Complete and \
get approval for the current phase first." >&2
  exit 2
fi

exit 0
