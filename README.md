# Skills

Portable workflow skills for coding-agent harnesses that support `SKILL.md`.

## Included skills

| Skill | Purpose | User questions |
|---|---|---|
| `agents-hub` | Maintain one source of truth across harness skill and instruction directories | One batched scope round only when scope is unresolved |
| `plan-review` | Critique implementation plans with a scored, prioritized risk report | Never; states assumptions and proceeds |
| `codebase-review` | Audit maintainability across a repository or a bounded area | Never; states assumptions and proceeds |
| `implementation-instructions` | Produce a verified, self-contained handoff prompt for a fresh implementation session | One batched round for material decisions repository state cannot settle |
| `implement-with-notes` | Implement while preserving reviewer-facing decisions through a verified durable handoff | One batched round only for material specification forks |

## Install

Clone the repository, then expose the skills you want through a skill root your installed harness actually discovers. Keep the clone as the canonical source so updates do not create drifting copies. For example, on a Unix-like machine where `~/.agents/skills` is a verified discovery root:

```bash
git clone https://github.com/5omeOtherGuy/skills.git ~/.local/share/agent-workflow-skills
mkdir -p ~/.agents/skills
for skill in ~/.local/share/agent-workflow-skills/skills/*; do
  ln -s "$skill" ~/.agents/skills/"$(basename "$skill")"
done
```

Some harnesses discover the canonical hub directly. For a harness that does not, first verify its actual skill directory and symlink support. The `agents-hub` skill includes a conservative POSIX helper that requires explicit paths and supports a dry run:

```bash
~/.agents/skills/agents-hub/scripts/sync-skills.sh \
  --hub "$HOME/.agents/skills" \
  --target "/verified/harness/skills" \
  --dry-run
```

Inspect the output, then repeat without `--dry-run`. The helper never overwrites real paths or foreign links and only prunes stale links when explicitly passed `--prune`. On platforms without POSIX symlinks, follow the skill's discovery workflow and use a verified native root, import, junction, or managed projection instead.

Verify discovery and instruction precedence for the installed harness version before changing configuration. Filesystem wiring alone does not prove that a harness loaded a skill. Existing real skill directories are never safe to overwrite with links.

## Layout

Each directory under `skills/` is independently installable and contains a `SKILL.md`. Supporting files live beside that skill.

## License

Licensed under either of:

- Apache License, Version 2.0 ([LICENSE-APACHE](LICENSE-APACHE))
- MIT License ([LICENSE-MIT](LICENSE-MIT))

at your option.
