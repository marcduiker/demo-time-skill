---
name: demotime-authoring
description: Use when creating, editing, or scaffolding DemoTime YAML demo scripts (.demo/*.yaml) — including adding scenes, defining moves, or producing companion slide/insert files.
---

# DemoTime authoring

## What DemoTime is

[DemoTime](https://demotime.show/) is a VS Code extension that drives live demos from declarative YAML scripts. A demo file (typically `.demo/<topic>.yaml`) defines a sequence of **scenes**; each scene runs an ordered list of **moves** (open a slide, run a terminal command, insert code at a position, etc.). This skill helps you author those YAML files — generating new ones, editing existing ones, and scaffolding the companion slide/insert files that moves reference.

## Top-level YAML structure

```yaml
title: <string>
description: <string>
version: <int>    # demo file format version, currently 3
scenes:
  - id: <slug>          # unique, stable
    title: <string>
    moves:
      - action: <action-name>
        # action-specific params
```

Scene `id` must be unique within the file and stable across edits (don't renumber). If the target repo already uses a `scene-<random>-<random>` / `demo-<random>-<random>` id convention, follow it; otherwise use simple kebab-case slugs like `intro`, `run`, `cleanup`.

## Authoring workflow

1. **Confirm the job.** Ask the user whether they want a **new** demo, an **edit** to an existing one, or just **scaffolding** of companion files.
2. **For new demos**, ask for: the talk topic, a rough outline (slide-heavy vs. live-coding vs. mixed), and the target file path (default `.demo/<name>.yaml`).
3. **Identify which action categories the demo needs** and load only the matching `references/<category>.md` files. See *Reference loading rules* below.
4. **Draft the YAML scene by scene.** Start from the closest example in `examples/` and adapt.
5. **Create referenced companion files.** Whenever a move's `path:`, `contentPath:`, or `dest:` points at a file that doesn't exist yet, create it from the matching template under `templates/`. **Announce every file creation — never scaffold silently.**
6. **Run the validation checklist** (below).
7. **Show the user the generated file tree and the final YAML** and ask them to review.

## Reference loading rules

Match the user's intent to the right reference file, and load **only** that file:

| Intent | Load |
|--------|------|
| Slide *actions* (opening / advancing slides during a demo) | `references/preview.md`, `references/demotime.md` |
| Authoring or styling a slide *file* (frontmatter, layout choice, theme choice) | `references/slides-layouts.md`, `references/slides-themes.md` |
| Run terminal commands | `references/terminal.md` |
| Open / rename / create files | `references/file.md` |
| Live code edits (insert / replace / highlight) | `references/text.md`, `references/patch.md` |
| Trigger VS Code commands or keybindings | `references/vscode.md` |
| Pauses / timing | `references/time.md` |
| Clipboard, simulated typing, OS keystrokes | `references/interactions.md` |
| Snippets | `references/snippet.md` |
| External apps | `references/external.md` |
| GitHub Copilot | `references/copilot.md` |
| OS / desktop | `references/os-desktop.md` |
| EngageTime | `references/engagetime.md` |
| VS Code settings, themes, presentation view | `references/setting.md` |

**Never invent an action name, a layout name, or a theme name.** If the user asks for something you haven't seen in a loaded reference, load the candidate reference first. If it's still not there, WebFetch the canonical page (`https://demotime.show/actions/<category>/`, `https://demotime.show/slides/layouts/`, or `https://demotime.show/slides/themes/`) once and use the result.

DemoTime's countdown timer is **not** a YAML action — start and pause it by clicking the status-bar clock. Use `waitForTimeout` (`references/time.md`) for scripted pauses.

## Slide authoring (layouts, themes, styling)

Whenever you create or edit a slide markdown file, load `references/slides-layouts.md` and `references/slides-themes.md` and follow them. Quick rules:

- **Every slide starts with YAML frontmatter** containing at least `layout: <name>`. Default to `layout: default`. Use `intro` for the first slide of a talk and `section` for chapter breaks.
- **A `theme:` is optional per slide.** If the user has chosen a theme for the talk, set it once at the demo level (on the `openSlide` action via the `customTheme:` param — see `references/preview.md`) and let slides inherit it, rather than repeating the theme on every slide.
- **Pick from documented values only.** Built-in layouts: `default`, `intro`, `section`, `quote`, `video`, `image`, `image-left`, `image-right`, `two-columns`, `animated-svg`, `custom`. Built-in themes: `default`, `minimal`, `monomi`, `unnamed`, `quantum`, `frost`, `pixels`.
- **Use the matching template:**
  - `templates/slide.md` → `default`, `intro`, `section`, `quote` (adjust frontmatter `layout:` accordingly).
  - `templates/slide-image-right.md` → `image-right` and, by mirror, `image-left`.
  - `templates/slide-two-columns.md` → `two-columns`.
  - Other layouts: start from `templates/slide.md` and adapt — `references/slides-layouts.md` documents each layout's expected body structure.
- **Custom styling** (brand colors, custom fonts) → scaffold `.demo/themes/<name>.css` overriding the CSS variables listed in `references/slides-themes.md`, and wire it to the `openSlide` action via the `customTheme:` parameter. Do not invent CSS variables outside the documented surface.

## Validation checklist

Run before showing the user the result:

- [ ] Every `action:` value matches an action documented in the bundled references.
- [ ] All required params for that action are present and well-typed.
- [ ] All file paths in `path:`, `contentPath:`, `dest:` either already exist or will be created in this same change.
- [ ] Scene `id`s are unique within the file.
- [ ] `terminalId` values are consistent across paired actions — a scene that sends `ctrl+c` should target the same `terminalId` as the scene that started the process.

## Repo conventions (defaults)

Apply these when the target repo follows them; otherwise follow the repo's existing layout and note the deviation.

- Demo files live in `.demo/<topic>.yaml`.
- Slides live in `.demo/slides/<name>.md`.
- Code inserts live in `.demo/inserts/<NN>-<desc>.txt`.
- A single `terminalId` (e.g. `app-run`) is reused across scenes that share a shell.
- Typed commands the audience should **see**: `insertTypingMode: character-by-character`, `insertTypingSpeed: 75-100`.
- Setup commands the audience does **not** need to see typed: `insertTypingMode: instant`, `autoExecute: true`.
- Demos open with a `setPresentationView` followed by an `openSlide` to a title slide.

## Scaffolding companion files

When a generated scene references a slide or insert that doesn't exist, create it from the matching template:

- Slide → `templates/slide.md` (default), `templates/slide-image-right.md` (image layouts), or `templates/slide-two-columns.md` (two-columns layout). Choose based on the layout the user asked for, defaulting to `slide.md` with `layout: default`.
- Insert → `templates/insert.txt`.

Always set `layout:` in scaffolded slides. Apply `theme:` consistently across the talk — see *Slide authoring* above.

Don't put substantive content in scaffolded files — only a stub with the title (slides) or a header comment (inserts). The user fills in the content.

## Editing existing demos

- Read the full YAML first; understand its existing structure.
- Preserve existing scene `id`s — never renumber.
- Use `Edit` (not `Write`) so unrelated scenes aren't touched.
- Re-run the validation checklist over the changed scenes only.

## Examples

- `examples/minimal.yaml` — smallest valid demo (one slide). Use for short talks or sanity checks.
- `examples/slide-walk.yaml` — ~10 scenes, slides only. Use for keynote-style talks with no live coding.
- `examples/code-demo.yaml` — full code demo (intro → build → run → edit → re-run → cleanup). Most valuable starting point; encodes the repo conventions above.

## Out of scope

- Running or testing the DemoTime extension itself.
- Installing the DemoTime VS Code extension.
- Generating substantive slide *content* (only stub titles).
- Recording or exporting demo videos.
