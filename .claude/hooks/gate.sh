#!/usr/bin/env bash
# PreToolUse hook: block source edits unless a spec in this repository is in
# the `implementing` phase.
#
# Specs belong to the repository they live in: specs/<NNN>-<slug>/.status
# holds one spec's phase (requirements | design | tasks | implementing |
# done). Source edits are allowed while at least one spec is
# `implementing`, so writing the next spec's requirements never blocks
# finishing the current one. A repository with no specs yet is not gated.
#
# Which paths count as source code is the project's call, not the
# toolkit's: set SPEC_GATE_PATHS (space-separated, relative to the repo
# root) in .claude/settings.json's "env", matching the "Source paths"
# declaration in the project's CLAUDE.md. It defaults to "src/".
#
# Claude Code passes the tool invocation as JSON on stdin. Exit 2 = block
# the tool call and return the message to Claude. Needs only bash: jq is
# used when installed, and a sed extraction of the one field read here
# stands in for it otherwise.

set -euo pipefail

extract_file_path() {
  if command -v jq >/dev/null 2>&1; then
    jq -r '.tool_input.file_path // empty'
  else
    tr -d '\r\n' \
      | sed -n 's/.*"file_path"[[:space:]]*:[[:space:]]*"\(\([^"\\]\|\\.\)*\)".*/\1/p' \
      | sed 's/\\\\/\\/g'
  fi
}

input=$(cat)
path=$(printf '%s' "$input" | extract_file_path || true)
[[ -n "$path" ]] || exit 0

# Normalize Windows separators so one set of patterns works everywhere.
path=${path//\\//}
root=$(git rev-parse --show-toplevel 2>/dev/null || pwd)
root=${root//\\//}

shopt -s nocasematch
relative=${path#"$root"/}

guarded=false
for source_path in ${SPEC_GATE_PATHS:-src/}; do
  source_path=${source_path%/}/
  if [[ "$relative" == "$source_path"* || "$path" == *"/$source_path"* ]]; then
    guarded=true
    break
  fi
done
shopt -u nocasematch

$guarded || exit 0

# Numbered spec directories only; source-material/ is raw input, not a feature.
specs=$(ls -d "$root"/specs/[0-9]*/ 2>/dev/null | sort || true)
[[ -n "$specs" ]] || exit 0

newest=""
newest_status=""
while IFS= read -r spec; do
  if [[ -f "${spec}.status" ]]; then
    status=$(tr -d '[:space:]' < "${spec}.status")
  else
    status="missing"
  fi
  [[ "$status" == "implementing" ]] && exit 0
  newest=$spec
  newest_status=$status
done <<< "$specs"

echo "BLOCKED: no spec in this repository is in the 'implementing' phase \
(newest: '${newest#"$root"/}' is '${newest_status}'). Source edits are only \
permitted while a spec is implementing. Complete and get approval for the \
current phase first." >&2
exit 2
