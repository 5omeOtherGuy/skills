---
name: agents-hub
description: Establish, audit, migrate, or repair a single-source skill and instruction hub across coding-agent harnesses. Use before changing skill placement, installing or moving shared skills, editing AGENTS.md/CLAUDE.md or equivalent instruction wiring, onboarding a new harness or machine, or diagnosing discovery, precedence, symlink, import, and scope problems.
---

# Agent configuration hub

Create one canonical source for each shared skill or instruction and project it into each harness through mechanisms that harness actually supports. Treat every path and discovery rule as machine- and version-dependent until verified.

## Invariants

- Keep one authoritative source per skill or instruction. A link, import, junction, or generated projection is not another source.
- Preserve harness-specific content in that harness's own configuration area.
- Never overwrite, merge, move, prune, or relink unfamiliar content without identifying its owner and confirming destructive choices.
- Never infer discovery from a directory name alone. Verify it from current documentation, command help, configuration, or a functional test.
- Prefer reversible wiring. Inspect the resolved destination before editing through any link.
- Do not promise universal support: record unsupported mechanisms and use the safest available alternative.

## 1. Inventory the actual setup

Start with the harnesses named by the user and those relevant to the requested operation. Do not assume a fixed harness list.

For each harness:

1. Locate the executable and record its version.
2. Check environment variables, command-line flags, and configuration that can relocate its home or discovery roots.
3. Establish, with evidence:
   - global and repository skill roots;
   - global and repository instruction files;
   - ancestor traversal and precedence rules;
   - support for extra roots, imports, symlinks, junctions, or aliases;
   - trust, approval, ownership, and permission constraints;
   - reload or restart behavior.
4. Inspect only relevant candidate roots with `ls -la`, `readlink`, and a canonical-path tool available on the platform. Do not broadly scan private home-directory contents.
5. Locate existing canonical files and detect duplicate names, shadowing, overrides, broken links, and generated copies.

Use a compact working matrix and mark unverified fields `unknown` rather than guessing:

| Harness + version | Global skills | Repo skills | Instruction chain | Projection support | Reload | Evidence |
|---|---|---|---|---|---|---|

If documentation and observed behavior disagree, trust a minimal functional test and report the discrepancy.

## 2. Close only material scope gaps

After inventory, ask one batched round of questions only for choices the request and machine state do not settle:

- Which of the discovered or requested harnesses are in scope?
- Is the change global, repository-local, or both?
- Should a skill auto-trigger, be explicitly invoked, or support both?
- When existing sources conflict, which source should become authoritative?

Use a structured-question tool when available. Do not ask users for facts that inspection can establish. If an answer is unavailable, choose the least destructive option and state the assumption.

## 3. Choose the canonical layout

Preserve an established, working canonical root unless the task is to migrate it. For a new setup:

- use a user-selected root when given;
- otherwise prefer a neutral global hub already discovered natively by the most in-scope harnesses;
- if none exists, use a clearly named user configuration/data directory appropriate to the operating system;
- for repository-shared material, prefer a version-controlled neutral directory rather than one harness's private directory.

Keep each skill in `<skill-name>/SKILL.md`. Require a lowercase kebab-case directory name matching frontmatter `name`; make `description` state both capability and trigger conditions. Check all discovered roots and bundled skill sets for name collisions before creating or renaming anything.

Keep shared instructions concise. Put a harness-specific rule in the harness-specific layer, not in the shared source with an implicit exception.

## 4. Select a projection per harness

Choose the first verified mechanism that preserves one source of truth:

1. Native discovery of the canonical root.
2. A configured additional discovery root.
3. A supported import/include from the harness's instruction file.
4. A symlink, junction, or alias supported by both the platform and harness.
5. A deterministic managed copy only when no reference mechanism exists, with an ownership marker and repeatable sync command; never hand-edit the projection.

Use relative repository links when they are supported and must survive clones. Prefer imports or managed projections when symlinks are unreliable on the target filesystem, operating system, archive format, or contributor workflow.

Respect instruction precedence: a higher-precedence override can disconnect lower shared instructions even when every path exists. Preserve required bootstrap/import lines when adding harness-specific content.

For POSIX symlink projections, use the bundled helper only with explicit, verified paths:

```bash
bash scripts/sync-skills.sh \
  --hub "/canonical/skills" \
  --target "/harness/skills" \
  --dry-run
```

Inspect the dry run, then repeat without `--dry-run`. Add `--target` again for additional verified targets. Use `--prune` only when stale links owned by that hub should be removed. The helper does not configure harness discovery and is not a substitute for verification.

## 5. Apply changes safely

Before writing, show or establish the mapping `canonical source -> projection` for every in-scope harness.

- Create parents narrowly; do not replace existing real directories.
- Move a canonical directory once rather than copying it into another root.
- Keep content edits at the canonical path. Linked projections need no content sync.
- Treat foreign links, real directories, override files, and same-name bundled skills as conflicts to resolve explicitly.
- Keep generated projections reproducible and exclude them from manual editing.
- Follow the active environment's approval rules for destructive or externally visible operations.

When migrating an existing setup, inventory consumers first, establish new projections second, verify them third, and remove old projections last. Keep the old source until every consumer passes functional verification.

## 6. Verify structure and behavior

Run all applicable checks:

1. Canonical-path check: every projection resolves to the intended source, or every managed copy matches it.
2. Integrity check: no broken links, duplicate authoritative files, unintended overrides, or name collisions remain.
3. Metadata check: every skill has valid frontmatter and matching directory/name.
4. Discovery check: each harness lists or loads the skill/instructions from a clean session after any required reload.
5. Trigger check: auto-trigger and explicit invocation behave according to scope.
6. Precedence check: repository and harness-specific instructions augment rather than silently replace shared instructions.
7. Isolation check: out-of-scope harnesses and repositories are unchanged.

Report the canonical paths, projections, evidence used, checks run, assumptions, and any unsupported harness/platform behavior. Do not describe wiring as complete when only filesystem checks passed.

## Onboard an unfamiliar harness

Do not add a hardcoded exception first. Re-run the inventory, add one evidence-backed matrix row, select the least invasive projection, and functionally verify it. Update reusable documentation or tooling only when the behavior is stable and broadly applicable; keep machine-specific facts in local configuration.
