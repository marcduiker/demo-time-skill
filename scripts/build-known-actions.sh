#!/usr/bin/env bash
# Extract every action name (H2 ``-wrapped) from action reference files only.
# The slides-*.md references use H2s for layouts/themes, not actions, so we
# exclude them.
set -euo pipefail
cd "$(dirname "$0")/.."
# shellcheck disable=SC2046
grep -hE '^## `[^`]+`$' \
  $(ls skills/demotime-authoring/references/*.md | grep -v '/slides-') \
  | sed -E 's/^## `([^`]+)`$/\1/' \
  | sort -u > scripts/known-actions.txt
wc -l < scripts/known-actions.txt
