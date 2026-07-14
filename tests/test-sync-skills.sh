#!/usr/bin/env bash
set -euo pipefail

script=${1:-"$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)/skills/agents-hub/scripts/sync-skills.sh"}
failures=0

fail() {
  echo "FAIL: $*" >&2
  failures=$((failures + 1))
}

assert_contains() {
  local text=$1 expected=$2 label=$3
  [[ "$text" == *"$expected"* ]] || fail "$label (missing: $expected)"
}

assert_not_contains() {
  local text=$1 unexpected=$2 label=$3
  [[ "$text" != *"$unexpected"* ]] || fail "$label (unexpected: $unexpected)"
}

make_skill() {
  local hub=$1 name=$2
  mkdir -p "$hub/$name"
  printf '%s\n' '---' "name: $name" 'description: test skill' '---' > "$hub/$name/SKILL.md"
}

tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT

# Dry-run output must describe planned actions without claiming they happened.
hub="$tmp/dry hub"
target="$tmp/dry target"
make_skill "$hub" alpha-skill
mkdir -p "$target"
ln -s "$hub/removed-skill" "$target/removed-skill"
output=$(bash "$script" --hub "$hub" --target "$target" --dry-run --prune 2>&1) || fail "dry run exits successfully"
assert_contains "$output" "would link" "dry run identifies a planned link"
assert_contains "$output" "would prune" "dry run identifies a planned prune"
assert_not_contains "$output" $'\nlinked  ' "dry run does not claim a link was created"
assert_not_contains "$output" $'\npruned  ' "dry run does not claim a link was removed"
[[ ! -e "$target/alpha-skill" && ! -L "$target/alpha-skill" ]] || fail "dry run created a link"
[[ -L "$target/removed-skill" ]] || fail "dry run pruned a link"

# A relative link resolving to the same canonical skill is already synchronized.
hub="$tmp/relative hub"
target="$tmp/relative target"
make_skill "$hub" alpha-skill
mkdir -p "$target"
(
  cd "$target"
  ln -s "../relative hub/alpha-skill" alpha-skill
)
output=$(bash "$script" --hub "$hub" --target "$target" 2>&1) || fail "relative-link sync exits successfully"
assert_not_contains "$output" "SKIP foreign link" "equivalent relative link is not foreign"
[[ "$(readlink "$target/alpha-skill")" == "../relative hub/alpha-skill" ]] || fail "equivalent relative link was replaced"

# Repeated --skill flags project only the requested valid skills.
hub="$tmp/select hub"
target="$tmp/select target"
make_skill "$hub" alpha-skill
make_skill "$hub" beta-skill
make_skill "$hub" gamma-skill
output=$(bash "$script" --hub "$hub" --target "$target" --skill alpha-skill --skill gamma-skill 2>&1) || fail "selected sync exits successfully"
[[ -L "$target/alpha-skill" ]] || fail "selected alpha skill was not linked"
[[ ! -e "$target/beta-skill" && ! -L "$target/beta-skill" ]] || fail "unselected beta skill was linked"
[[ -L "$target/gamma-skill" ]] || fail "selected gamma skill was not linked"

# Unknown selections fail before creating a target.
missing_target="$tmp/missing target"
if bash "$script" --hub "$hub" --target "$missing_target" --skill absent-skill >/dev/null 2>&1; then
  fail "unknown skill selection succeeded"
fi
[[ ! -e "$missing_target" ]] || fail "unknown skill selection mutated the filesystem"

if ((failures > 0)); then
  echo "$failures test(s) failed" >&2
  exit 1
fi

echo "all sync-skills tests passed"
