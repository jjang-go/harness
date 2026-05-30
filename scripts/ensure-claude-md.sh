#!/usr/bin/env bash
# harness-starter — ensure a project CLAUDE.md exists (non-destructive).
#
# Runs on SessionStart. If the project has no CLAUDE.md, install the bundled
# default. The bundled file carries its MIT third-party notice in its header,
# so copying it verbatim keeps that notice intact (license requirement).
#
# If a CLAUDE.md already exists, do nothing — the project's own content is left
# untouched. Use `/setup-harness` for the interactive integration options
# (keep / replace / migrate existing to .claude/HARNESS.md / overwrite).
set -euo pipefail

project_dir="${CLAUDE_PROJECT_DIR:-$PWD}"
plugin_root="${CLAUDE_PLUGIN_ROOT:-}"

# Need a resolvable plugin root and bundled source; otherwise no-op.
[ -n "$plugin_root" ] || exit 0
source_file="$plugin_root/templates/CLAUDE.md"
[ -f "$source_file" ] || exit 0

target_file="$project_dir/CLAUDE.md"

# Never overwrite or modify an existing CLAUDE.md.
# Treat a broken symlink (-e is false, -L is true) as "present" too, so we
# never clobber a user's symlinked CLAUDE.md.
if [ -e "$target_file" ] || [ -L "$target_file" ]; then
  exit 0
fi

# If the copy fails (permissions, disk full, ...), do not block the session.
cp "$source_file" "$target_file" || exit 0
echo "harness-starter: created CLAUDE.md (bundled third-party content under MIT — see the notice at the top of the file)."
