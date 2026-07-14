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

Clone the repository, then link the skills you want into your harness's discovered skill directory. Keep the clone as the canonical source so updates do not create drifting copies.

```bash
git clone https://github.com/5omeOtherGuy/skills.git ~/.local/share/agent-workflow-skills
mkdir -p ~/.agents/skills
for skill in ~/.local/share/agent-workflow-skills/skills/*; do
  ln -s "$skill" ~/.agents/skills/"$(basename "$skill")"
done
```

Some harnesses discover `~/.agents/skills` directly. For a harness that does not, link the selected skills from the hub into its own skills directory. The `agents-hub` skill includes a conservative sync script for the common Claude Code setup:

```bash
~/.agents/skills/agents-hub/scripts/sync-skills.sh
```

Verify discovery behavior for the installed harness version before changing configuration. Existing real skill directories are never safe to overwrite with links.

## Layout

Each directory under `skills/` is independently installable and contains a `SKILL.md`. Supporting files live beside that skill.

## License

Licensed under either of:

- Apache License, Version 2.0 ([LICENSE-APACHE](LICENSE-APACHE))
- MIT License ([LICENSE-MIT](LICENSE-MIT))

at your option.
