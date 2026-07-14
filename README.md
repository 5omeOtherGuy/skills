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

There is no universal skill directory. First verify the discovery roots, precedence, and link support of the installed harness version. Keep one clone as the canonical source; point harnesses at it natively when possible.

On a Unix-like system with Bash, the bundled helper can create conservative machine-local symlinks. Replace `/verified/harness/skills` with a discovery root you have confirmed:

```bash
git clone https://github.com/5omeOtherGuy/skills.git ~/.local/share/agent-workflow-skills

bash ~/.local/share/agent-workflow-skills/skills/agents-hub/scripts/sync-skills.sh \
  --hub ~/.local/share/agent-workflow-skills/skills \
  --target /verified/harness/skills \
  --dry-run
```

Inspect the dry run, then repeat without `--dry-run`. Add `--skill implementation-instructions` (repeatable) to install only selected skills. The helper never overwrites real paths or foreign links and prunes stale links only with explicit `--prune`.

Do not use the helper for clone-portable repository links: it creates absolute symlinks. On Windows or filesystems without reliable Unix symlinks, use a verified native discovery root, configured additional root, junction, or managed projection as described by `agents-hub`.

After installation, start a clean harness session and verify actual discovery and triggering. Filesystem wiring alone is not proof that a harness loaded a skill.

## Layout

Each directory under `skills/` is independently installable and contains a `SKILL.md`. Supporting files live beside that skill.

## License

Licensed under either of:

- Apache License, Version 2.0 ([LICENSE-APACHE](LICENSE-APACHE))
- MIT License ([LICENSE-MIT](LICENSE-MIT))

at your option.
