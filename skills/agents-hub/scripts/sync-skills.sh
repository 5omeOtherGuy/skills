#!/usr/bin/env bash
# Project one canonical skill directory into one or more Unix-like harness skill
# directories using conservative symlinks. Discovery configuration is external.
set -euo pipefail

usage() {
  cat <<'EOF'
Usage: sync-skills.sh --hub PATH --target PATH [--target PATH ...]
                      [--skill NAME ...] [--dry-run] [--prune]

Options:
  --hub PATH      Canonical directory containing <name>/SKILL.md directories.
  --target PATH   Harness skill directory to receive links. Repeatable.
  --skill NAME    Project only this skill. Repeatable; omit to project all skills.
  --dry-run       Print changes without modifying the filesystem.
  --prune         Remove broken target links whose recorded destination is in this hub.
  -h, --help      Show this help.

The script preflights every target and aborts before changes on any path conflict.
It never overwrites real files/directories or links owned by another hub.
EOF
}

hub=""
targets=()
requested_names=()
dry_run=false
prune=false

while (($#)); do
  case "$1" in
    --hub)
      (($# >= 2)) || { echo "--hub requires a path" >&2; exit 2; }
      hub=$2
      shift 2
      ;;
    --target)
      (($# >= 2)) || { echo "--target requires a path" >&2; exit 2; }
      targets+=("$2")
      shift 2
      ;;
    --skill)
      (($# >= 2)) || { echo "--skill requires a name" >&2; exit 2; }
      requested_names+=("$2")
      shift 2
      ;;
    --dry-run)
      dry_run=true
      shift
      ;;
    --prune)
      prune=true
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "unknown argument: $1" >&2
      usage >&2
      exit 2
      ;;
  esac
done

[[ -n "$hub" ]] || { echo "--hub is required" >&2; exit 2; }
((${#targets[@]} > 0)) || { echo "at least one --target is required" >&2; exit 2; }
[[ -d "$hub" ]] || { echo "hub is not a directory: $hub" >&2; exit 2; }
hub=$(cd "$hub" && pwd -P)

skills=()
for skill in "$hub"/*; do
  [[ -d "$skill" && -f "$skill/SKILL.md" ]] || continue
  name=${skill##*/}
  if [[ ! "$name" =~ ^[a-z0-9]+(-[a-z0-9]+)*$ ]]; then
    echo "SKIP invalid skill directory name: $skill" >&2
    continue
  fi
  skills+=("$skill")
done

((${#skills[@]} > 0)) || { echo "no valid skills found in hub: $hub" >&2; exit 1; }

if ((${#requested_names[@]} > 0)); then
  selected_skills=()
  for requested in "${requested_names[@]}"; do
    [[ "$requested" =~ ^[a-z0-9]+(-[a-z0-9]+)*$ ]] || {
      echo "invalid skill name: $requested" >&2
      exit 2
    }

    match=""
    for skill in "${skills[@]}"; do
      if [[ "${skill##*/}" == "$requested" ]]; then
        match=$skill
        break
      fi
    done
    [[ -n "$match" ]] || { echo "skill not found in hub: $requested" >&2; exit 2; }

    duplicate=false
    for skill in "${selected_skills[@]}"; do
      [[ "$skill" == "$match" ]] && duplicate=true
    done
    $duplicate || selected_skills+=("$match")
  done
  skills=("${selected_skills[@]}")
fi

link_matches_skill() {
  local link=$1 skill=$2 destination resolved_link resolved_skill
  [[ -L "$link" ]] || return 1
  destination=$(readlink "$link")
  [[ "$destination" == "$skill" ]] && return 0
  [[ -e "$link" ]] || return 1
  resolved_link=$(cd "$link" && pwd -P) || return 1
  resolved_skill=$(cd "$skill" && pwd -P) || return 1
  [[ "$resolved_link" == "$resolved_skill" ]]
}

# Validate every target before changing any of them so collisions cannot leave a
# partial projection.
conflicts=0
for target in "${targets[@]}"; do
  [[ -n "$target" && "$target" != "/" ]] || { echo "unsafe target: ${target:-<empty>}" >&2; exit 2; }
  if [[ -e "$target" && ! -d "$target" ]]; then
    echo "target exists but is not a directory: $target" >&2
    exit 2
  fi
  [[ -d "$target" ]] || continue

  for skill in "${skills[@]}"; do
    link="$target/${skill##*/}"
    if [[ -L "$link" ]]; then
      if ! link_matches_skill "$link" "$skill"; then
        echo "CONFLICT foreign link: $link -> $(readlink "$link")" >&2
        conflicts=$((conflicts + 1))
      fi
    elif [[ -e "$link" ]]; then
      echo "CONFLICT existing path: $link" >&2
      conflicts=$((conflicts + 1))
    fi
  done
done

if ((conflicts > 0)); then
  echo "sync aborted: $conflicts target conflict(s); no changes made" >&2
  exit 1
fi

for target in "${targets[@]}"; do

  if [[ ! -d "$target" ]]; then
    if $dry_run; then
      echo "would create target $target"
    else
      mkdir -p "$target"
    fi
  fi

  if $prune && [[ -d "$target" ]]; then
    for link in "$target"/*; do
      [[ -L "$link" ]] || continue
      destination=$(readlink "$link")
      case "$destination" in
        "$hub"/*)
          if [[ ! -e "$link" ]]; then
            if $dry_run; then
              echo "would prune $link"
            else
              rm -- "$link"
              echo "pruned  $link"
            fi
          fi
          ;;
      esac
    done
  fi

  for skill in "${skills[@]}"; do
    name=${skill##*/}
    link="$target/$name"

    if [[ -L "$link" ]]; then
      if link_matches_skill "$link" "$skill"; then
        continue
      fi
      echo "sync aborted: target changed during sync: $link" >&2
      exit 1
    elif [[ -e "$link" ]]; then
      echo "sync aborted: target changed during sync: $link" >&2
      exit 1
    elif $dry_run; then
      echo "would link $link -> $skill"
    else
      ln -s "$skill" "$link"
      echo "linked  $link -> $skill"
    fi
  done
done

if $dry_run; then
  echo "dry run complete"
else
  echo "sync complete"
fi
