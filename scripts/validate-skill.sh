#!/usr/bin/env bash
# End-to-end validation of the demotime-authoring skill.
set -euo pipefail
cd "$(dirname "$0")/.."

echo "→ plugin manifest is valid JSON"
python3 -m json.tool .claude-plugin/plugin.json > /dev/null

echo "→ rebuilding known-actions index"
./scripts/build-known-actions.sh > /dev/null

echo "→ each action reference: H1 present, Source line present, summary table ↔ H2 consistent"
python3 - <<'PY'
import re, pathlib
expected = {"copilot","demotime","engagetime","external","file","interactions",
            "os-desktop","patch","preview","setting","snippet","terminal",
            "text","time","vscode"}
have = {p.stem for p in pathlib.Path("skills/demotime-authoring/references").glob("*.md")
        if not p.stem.startswith("slides-")}
missing = expected - have
assert not missing, f"Missing action reference files: {missing}"
for name in sorted(expected):
    p = pathlib.Path(f"skills/demotime-authoring/references/{name}.md")
    text = p.read_text()
    assert text.startswith("# "), f"{name}: missing H1"
    assert "Source: https://demotime.show/actions/" in text, f"{name}: missing Source line"
    # Summary table appears above the first per-action H2 (## `actionName`).
    m = re.search(r"^## `", text, re.M)
    summary = text[:m.start()] if m else text
    table = set(re.findall(r"^\|\s*`([^`]+)`\s*\|", summary, re.M))
    h2 = set(re.findall(r"^##\s+`([^`]+)`\s*$", text, re.M))
    assert table == h2, f"{name}: table vs H2 mismatch ({table ^ h2})"
print(f"OK — all 15 action references valid")
PY

echo "→ slide-authoring references present, with expected layouts/themes/CSS vars"
python3 - <<'PY'
import pathlib
layouts_text = pathlib.Path("skills/demotime-authoring/references/slides-layouts.md").read_text()
themes_text = pathlib.Path("skills/demotime-authoring/references/slides-themes.md").read_text()
assert layouts_text.startswith("# ") and "Source: https://demotime.show/slides/layouts/" in layouts_text
assert themes_text.startswith("# ") and "Source: https://demotime.show/slides/themes/" in themes_text
for layout in ["default","intro","section","quote","video","image",
               "image-left","image-right","two-columns","animated-svg","custom"]:
    assert f"`{layout}`" in layouts_text, f"slides-layouts.md missing {layout}"
for theme in ["default","minimal","monomi","unnamed","quantum","frost","pixels"]:
    assert f"`{theme}`" in themes_text, f"slides-themes.md missing {theme}"
for var in ["--demotime-color","--demotime-background","--demotime-heading-color",
            "--demotime-heading-background","--demotime-font-size",
            "--demotime-link-color","--demotime-link-active-color",
            "--demotime-blockquote-border","--demotime-blockquote-background"]:
    assert var in themes_text, f"slides-themes.md missing CSS variable {var}"
print("OK — slides-layouts.md (11 layouts) and slides-themes.md (7 themes, 9 vars) valid")
PY

echo "→ slide templates have valid frontmatter with the expected layout"
python3 - <<'PY'
import re, pathlib, yaml
for f, expected in [("slide.md", "default"),
                    ("slide-image-right.md", "image-right"),
                    ("slide-two-columns.md", "two-columns")]:
    text = pathlib.Path(f"skills/demotime-authoring/templates/{f}").read_text()
    m = re.match(r"^---\n(.*?)\n---\n", text, re.S)
    assert m, f"{f}: missing frontmatter"
    fm = yaml.safe_load(m.group(1))
    assert fm.get("layout") == expected, f"{f}: layout {fm.get('layout')!r} != {expected!r}"
print("OK — three slide templates have correct layout frontmatter")
PY

echo "→ each example: parses as YAML, unique scene ids, only known actions"
python3 - <<'PY'
import yaml, pathlib
known = set(pathlib.Path("scripts/known-actions.txt").read_text().split())
for p in sorted(pathlib.Path("skills/demotime-authoring/examples").glob("*.yaml")):
    demo = yaml.safe_load(p.read_text())
    ids = [s["id"] for s in demo["scenes"]]
    assert len(ids) == len(set(ids)), f"{p.name}: duplicate scene ids"
    used = {m["action"] for s in demo["scenes"] for m in s["moves"]}
    unknown = used - known
    assert not unknown, f"{p.name}: unknown actions {unknown}"
    print(f"OK {p.name} — {len(ids)} scenes, {len(used)} distinct actions")
PY

echo "→ SKILL.md front-matter valid + references all exist"
python3 - <<'PY'
import re, pathlib, yaml
text = pathlib.Path("skills/demotime-authoring/SKILL.md").read_text()
m = re.match(r"^---\n(.*?)\n---\n", text, re.S)
assert m, "Missing front-matter"
fm = yaml.safe_load(m.group(1))
assert fm["name"] == "demotime-authoring"
assert "description" in fm
refs = set(re.findall(r"`references/([a-z\-]+)\.md`", text))
for r in refs:
    assert pathlib.Path(f"skills/demotime-authoring/references/{r}.md").exists(), \
        f"SKILL.md references missing {r}.md"
print(f"OK — SKILL.md valid, references {len(refs)} files")
PY

echo "→ all good"
