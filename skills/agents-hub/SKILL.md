---
name: agents-hub
description: Design and maintain one shared skill and instruction hub across multiple coding-agent harnesses without duplicated sources of truth. Use before creating, installing, moving, renaming, or deleting shared skills; changing AGENTS.md or CLAUDE.md scope; or explaining which harness discovers which configuration.
---

# Cross-harness agents hub

Maintain one canonical source for every shared skill or instruction. Harness-specific directories may contain links or imports to that source, never copied content that can drift.

## Establish the environment first

1. Detect installed harnesses (for example, `command -v claude codex pi iris`). Do not reason about harnesses that are not installed.
2. Verify each installed version's discovery behavior from its current documentation or observed configuration. Treat the paths below as common defaults, not universal guarantees.
3. Before changing anything, ask only for scope the request leaves unresolved, batched into one round (use a structured-question tool when available):
   - Which harnesses should see it: all installed harnesses or named ones?
   - Is it global or limited to one repository?
   - Should it auto-trigger from its description or be explicitly invoked?
4. Inspect links with `ls -la` and `readlink` before editing. State where a write through a link will actually land.

## Common default locations

| Purpose | Claude Code | Codex CLI | pi | Iris |
|---|---|---|---|---|
| Global skills | `~/.claude/skills` | `~/.agents/skills` and `~/.codex/skills` | `~/.agents/skills` and `~/.pi/agent/skills` | `~/.agents/skills` and `~/.iris/skills` |
| Global instructions | `~/.claude/CLAUDE.md` | `~/.codex/AGENTS.md` | `~/.pi/agent/AGENTS.md` | `~/.iris/AGENTS.md` |
| Repository instructions | ancestor `CLAUDE.md` files | ancestor `AGENTS.md` files | ancestor `AGENTS.md` or `CLAUDE.md` files | ancestor `AGENTS.md` or `CLAUDE.md` files |
| Repository skills | `.claude/skills` | `.agents/skills` | `.agents/skills` or `.pi/skills` | `.agents/skills` or `.codex/skills` |

Discovery behavior changes between harness versions. Verify it before wiring a new setup.

## Place skills by scope

| Scope | Canonical location | Projection |
|---|---|---|
| All harnesses, global | `~/.agents/skills/<name>/SKILL.md` | Link it into any installed harness that does not discover the hub natively |
| One harness, global | That harness's own global skills directory | None |
| All harnesses, one repository | `<repo>/.agents/skills/<name>/SKILL.md` | Add relative repository links only for harnesses that require them |
| One harness, one repository | That harness's repository skills directory | None |

For a hub skill, keep one directory per skill and a `SKILL.md` whose kebab-case `name` matches the directory. Its frontmatter description must say what it does and when it should trigger. Keep shared skills independent of harness-specific tool names when a portable instruction is possible.

Before creating or renaming a skill, check every installed skill root and bundled skill set for a collision. Prefer a more specific name over shadowing an existing skill.

After adding, renaming, or deleting a global hub skill, run `scripts/sync-skills.sh`. Content-only edits need no synchronization because links resolve to the canonical file. A warning that a real directory shadows a hub skill is a conflict to resolve, not ignore.

## Place instructions by scope

| Scope | Canonical location |
|---|---|
| Shared, global | One shared instruction file imported or linked by each installed harness |
| One harness, global | That harness's global instruction file |
| Shared, one repository | `<repo>/AGENTS.md`, with a relative `CLAUDE.md` link or an `@AGENTS.md` import where needed |
| One harness, one repository | A harness-specific file that imports shared repository instructions before its additions |

Do not duplicate the same rule across instruction files. Preserve existing imports and pointer lines. If a harness refuses instruction-file symlinks, use an import or a short pointer supported by that harness instead. Prefer an import file over a repository symlink when Windows compatibility matters.

## Safe moves

When moving a skill between scopes:

1. Identify its current canonical directory and every link to it.
2. Move the real directory once; do not copy it.
3. Replace or remove stale projections.
4. Run the sync script when the global hub changed.
5. Verify that every installed harness resolves the intended canonical `SKILL.md`.

Never overwrite a real harness-specific directory with a hub link, edit a symlink as though it were harness-specific, or create a second authoritative copy.

## Verify

```bash
# Broken links in common skill roots
find ~/.agents/skills ~/.claude/skills ~/.codex/skills \
  ~/.pi/agent/skills ~/.iris/skills -xtype l 2>/dev/null

# Every hub directory has a skill definition
for dir in ~/.agents/skills/*/; do
  [ -f "$dir/SKILL.md" ] || echo "missing SKILL.md: $dir"
done

# Inspect instruction wiring rather than assuming it
ls -la ~/.claude/CLAUDE.md ~/.codex/AGENTS.md \
  ~/.pi/agent/AGENTS.md ~/.iris/AGENTS.md 2>/dev/null
```

Repair toward one canonical source per fact. Do not invent parallel wiring to hide a failed check.
