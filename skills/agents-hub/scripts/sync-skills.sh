#!/usr/bin/env bash
# Project ~/.agents/skills (the central hub) into harnesses that do not
# discover it natively: Claude Code (~/.claude/skills).
# iris, pi, and codex read ~/.agents/skills directly — no symlinks needed there.
#
# Safe to re-run any time. Only touches symlinks that point into ~/.agents/skills;
# real directories (harness-specific skills) and foreign symlinks are left alone.
set -euo pipefail

HUB="$HOME/.agents/skills"
TARGETS=("$HOME/.claude/skills")

for dir in "${TARGETS[@]}"; do
  mkdir -p "$dir"

  # prune symlinks into the hub whose target skill no longer exists
  for link in "$dir"/*; do
    [ -L "$link" ] || continue
    dest=$(readlink "$link")
    case "$dest" in
      "$HUB"/*) [ -e "$link" ] || { rm "$link"; echo "pruned  ${link}"; } ;;
    esac
  done

  # link every hub skill (a dir or symlink containing SKILL.md)
  for skill in "$HUB"/*/; do
    name=$(basename "$skill")
    [ -f "$skill/SKILL.md" ] || continue
    link="$dir/$name"
    if [ -L "$link" ]; then
      [ "$(readlink "$link")" = "$HUB/$name" ] || { ln -sfn "$HUB/$name" "$link"; echo "updated ${link}"; }
    elif [ -e "$link" ]; then
      echo "SKIP    ${link} exists and is not a hub symlink (harness-specific skill shadows hub)" >&2
    else
      ln -s "$HUB/$name" "$link"
      echo "linked  ${link}"
    fi
  done
done
echo "sync complete"
