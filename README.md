# demotime-authoring

A Claude Code plugin that ships a single skill, `demotime-authoring`, which helps you author [DemoTime](https://demotime.show/) demo scripts — the YAML files (`.demo/*.yaml`) that drive DemoTime's VS Code extension, plus the slide markdown and insert files those scripts reference.

## What the skill does

When you ask Claude to create, edit, or scaffold a DemoTime demo, the skill activates and:

- Generates new `.demo/<name>.yaml` files from a topic + outline.
- Edits existing demos, preserving scene `id`s.
- Scaffolds companion files (slides, inserts, custom themes) from templates.
- Loads only the action/layout/theme references relevant to your request.
- Validates against the canonical action set documented at `https://demotime.show/actions/`.

The skill knows every documented DemoTime action across 15 categories (91 action names total), every built-in slide layout (11), every built-in theme (7), and the CSS-variable surface for custom theming.

## Installing

Add this repo as a Claude Code plugin marketplace, then install the plugin:

```sh
/plugin marketplace add marcduiker/demo-time-skill
/plugin install demotime-authoring@marcduiker-ai-marketplace
```

Or symlink the skill directly into your user skills folder:

```sh
ln -s "$(pwd)/skills/demotime-authoring" ~/.claude/skills/demotime-authoring
```

## Layout

```
.claude-plugin/plugin.json              # plugin manifest
.claude-plugin/marketplace.json         # marketplace catalog (single-plugin)
skills/demotime-authoring/
  SKILL.md                              # always-loaded entry point
  references/                           # on-demand, one per action category + slides
  examples/                             # minimal, slide-walk, code-demo
  templates/                            # slide and insert stubs
scripts/
  build-known-actions.sh                # regenerate scripts/known-actions.txt
  validate-skill.sh                     # full validation pass
```

## Validating after edits

```sh
./scripts/validate-skill.sh
```

This re-runs every consistency check: JSON manifest validity, action-reference structure, slide-authoring references, template frontmatter, example YAML parseability, and SKILL.md cross-references.

## License

MIT
