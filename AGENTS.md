# Repo guide for AI agents

This repository is a Claude Code plugin that ships one skill, `demotime-authoring`. The skill itself lives at `skills/demotime-authoring/` and is content-only (Markdown + YAML + JSON — no runtime code).

## Source of truth

The canonical reference for every action, layout, and theme is `https://demotime.show/`:

- `https://demotime.show/actions/<category>/` — one page per action category.
- `https://demotime.show/slides/layouts/` and `https://demotime.show/slides/themes/` — slide authoring.
- `https://demotime.show/slides/themes/default/` — the full CSS-variable surface.

When the skill references something the canonical docs disagree with, the canonical docs win — update the local reference, do not invent or rename actions.

## Editing rules

- **Never invent action names, layout names, theme names, or CSS variables.** If you need something the bundled references don't cover, fetch the canonical page first and add it to the appropriate reference file.
- **Action reference format is fixed.** Each `references/<category>.md` follows: H1 title → `Source:` line → "Use this category for:" line → summary table (`| Action | Purpose |`) → `---` → one H2 per action with a params table and YAML example. The two `references/slides-*.md` files use a different shape (they enumerate layouts/themes, not parameterised actions).
- **After editing any reference**, rebuild the known-actions index:
  ```sh
  ./scripts/build-known-actions.sh
  ```
- **After any edit to the skill**, run the full validation:
  ```sh
  ./scripts/validate-skill.sh
  ```
  This must end with `→ all good`.

## Examples must only use documented actions

The three files under `skills/demotime-authoring/examples/` are validated against `scripts/known-actions.txt`. If validation reports an unknown action, **fix the reference (or the example) — do not invent**. If a referenced reference page exists but the action is missing, fetch and update the reference before changing the example.

## Conventions encoded in the skill

These are documented in `skills/demotime-authoring/SKILL.md` under "Repo conventions (defaults)". Follow them when authoring DemoTime demos elsewhere:

- Demo files: `.demo/<topic>.yaml`
- Slides: `.demo/slides/<name>.md`
- Inserts: `.demo/inserts/<NN>-<desc>.txt`
- Reuse a single `terminalId` across scenes sharing a shell.
- Audience-visible typing: `insertTypingMode: character-by-character`, `insertTypingSpeed: 75-100`.
- Setup typing: `insertTypingMode: instant`, `autoExecute: true`.

## Known divergences from canonical docs

- The `os-and-desktop` URL slug differs from this repo's local filename `os-desktop.md` (kept short).
- DemoTime's countdown timer has no YAML action — it is started/paused by clicking the status-bar clock. Don't reintroduce `startCountdown` / `stopCountdown` to examples.
- The `time` actions page covers only `waitForTimeout`, `waitForInput`, `pause` — not countdowns.
- The `demotime` actions page covers only `runDemoById` — start/next/previous/reset are not YAML actions.

## Git

Don't run `git add` or `git commit` unless explicitly asked. The repo owner commits manually.
