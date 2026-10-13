#!/usr/bin/env bash
# Re-sync the bundled plugins from their upstream GitHub repos.
# Idempotent: safe to run repeatedly (locally or in GitHub Actions).
# Usage:  bash sync-upstream.sh
set -euo pipefail

ROOT="$(cd "$(dirname "$0")" && pwd)"
WORK="$(mktemp -d)"
trap 'rm -rf "$WORK"' EXIT

clone() { git clone --depth 1 --quiet "$1" "$2"; }

# ---------------------------------------------------------------- nature-skills
echo "== nature-skills =="
clone https://github.com/Yuan1z0825/nature-skills.git "$WORK/nature-skills"
rm -rf "$WORK/nature-skills/.git"
rm -rf "$ROOT/nature-skills"
cp -r "$WORK/nature-skills" "$ROOT/nature-skills"
# upstream ships no Claude plugin manifest -> inject one so it installs as a plugin
mkdir -p "$ROOT/nature-skills/.claude-plugin"
cat > "$ROOT/nature-skills/.claude-plugin/plugin.json" <<'JSON'
{
  "name": "nature-skills",
  "description": "A growing collection of Claude skills for producing academic work at Nature-journal standard. Covers research writing and proposals, manuscript polishing, reviewer simulation, statistics, citation retrieval/verification, data availability, figures, paper reading/translation, reviewer responses, and paper-to-PPTX conversion.",
  "version": "1.1.0",
  "author": { "name": "Yuan1z0825", "email": "" },
  "license": "Apache-2.0",
  "homepage": "https://github.com/Yuan1z0825/nature-skills",
  "repository": "https://github.com/Yuan1z0825/nature-skills",
  "keywords": ["nature", "academic", "science", "figure", "writing", "citation", "publication", "proposal", "reviewer"]
}
JSON

# --------------------------------------------------------------- writing-skills
echo "== writing-skills =="
rm -rf "$ROOT/writing-skills/skills"
mkdir -p "$ROOT/writing-skills/skills"
cat <<'LIST' | while IFS='|' read -r name url; do
[ -z "$name" ] && continue
humanizer|https://github.com/blader/humanizer.git
humanizer-zh|https://github.com/op7418/Humanizer-zh.git
anti-defensive-writing|https://github.com/Kiterlin/anti-defensive-writing.git
anti-defensive-writing-zh|https://github.com/Devilyuu/anti-defensive-writing-zh.git
LIST
  echo "   - $name"
  clone "$url" "$WORK/$name"
  rm -rf "$WORK/$name/.git" "$WORK/$name/tests"
  cp -r "$WORK/$name" "$ROOT/writing-skills/skills/$name"
done
mkdir -p "$ROOT/writing-skills/.claude-plugin"
cat > "$ROOT/writing-skills/.claude-plugin/plugin.json" <<'JSON'
{
  "name": "writing-skills",
  "description": "Writing-quality skills: remove AI tells (humanizer, humanizer-zh) and reduce defensive/hedged academic writing (anti-defensive-writing, anti-defensive-writing-zh). Full versions including reference files and scripts.",
  "version": "1.0.0",
  "author": { "name": "blader / op7418 / Kiterlin / Devilyuu" },
  "license": "MIT",
  "keywords": ["writing", "editing", "ai-detection", "academic", "hedging"]
}
JSON

# ----------------------------------------------------- academic-research-skills
# You can ALSO add ARS directly from upstream (it ships its own marketplace.json).
# Kept mirrored here so this marketplace is self-contained.
echo "== academic-research-skills =="
clone https://github.com/Imbad0202/academic-research-skills.git "$WORK/ars"
rm -rf "$WORK/ars/.git"
rm -rf "$ROOT/academic-research-skills"
cp -r "$WORK/ars" "$ROOT/academic-research-skills"

echo "== sync complete =="
