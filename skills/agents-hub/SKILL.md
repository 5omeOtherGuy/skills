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

## 1. Discover the machine and narrow scope

Start with the harnesses named by the user and those relevant to the requested operation. Do not assume a fixed harness list or Unix layout.

1. Record the operating system, shell, home/config/data conventions, filesystem/link capabilities, and whether work runs locally, remotely, in a container, or across filesystems.
2. Locate named harnesses and record their versions. For a new setup, distinguish intended-but-not-installed harnesses from installed ones.
3. Perform only enough non-invasive discovery to present real choices. Do not broadly scan private home-directory contents.
4. Ask one batched round only for choices the request and machine state do not settle:
   - Which discovered or intended harnesses are in scope?
   - Is the change global, repository-local, or both?
   - Should a skill auto-trigger, be explicitly invoked, or support both?
   - When existing sources conflict, which source should become authoritative?

Use a structured-question tool when available. Do not ask for facts inspection can establish or re-ask decisions already supplied. If an answer is unavailable, choose the least destructive option and state the assumption.

## 2. Inventory in-scope harnesses

For each in-scope harness, check environment variables, command-line flags, and configuration that can relocate its home or discovery roots. Establish, with evidence:

- global and repository skill roots;
- global and repository instruction filenames and formats;
- ancestor traversal, merge order, replacement/override behavior, and size limits;
- import/include syntax, path resolution, cycle behavior, and symlink policy;
- support for extra skill roots, symlinks, junctions, aliases, or managed projections;
- trust, approval, ownership, sandbox, and permission constraints;
- reload or restart behavior.

Inspect only relevant candidate roots with platform-appropriate directory, link, and canonical-path tools. Locate existing canonical files and detect duplicate names, shadowing, overrides, broken links, generated copies, and import cycles.

Use a compact working matrix and mark unverified fields `unknown` rather than guessing:

| Harness + version | Skills | Instruction chain | Projection support | Reload | State | Evidence |
|---|---|---|---|---|---|---|

Use `planned` when a harness is not installed and only documentation was checked, `wired` when filesystem/configuration changes exist, and `verified` only after the harness loads them in a functional test. If documentation and observed behavior disagree, trust a minimal functional test and report the discrepancy.

## 3. Choose the canonical layout

Preserve an established, working canonical root unless the task is to migrate it. For a new setup:

- use a user-selected root when given;
- otherwise prefer a neutral global hub already discovered natively by the most in-scope harnesses;
- if none exists, use a clearly named user configuration/data directory appropriate to the operating system;
- for repository-shared material, prefer a version-controlled neutral directory rather than one harness's private directory.

Keep each skill in `<skill-name>/SKILL.md`. Require a lowercase kebab-case directory name matching frontmatter `name`; make `description` state both capability and trigger conditions. Check all discovered roots and bundled skill sets for name collisions before creating or renaming anything.

Keep shared instructions concise. Put a harness-specific rule in the harness-specific layer, not in the shared source with an implicit exception.

## 4. Select wiring by artifact type

Use only mechanisms verified for that harness and version.

For **skills**, prefer in order:

1. Native discovery of the canonical root.
2. A configured additional skill root.
3. A symlink, junction, or alias supported by both platform and harness.
4. A user-approved deterministic managed projection only when no reference mechanism exists.

For **instructions**, prefer in order:

1. Native loading of the canonical shared file when filename, format, and scope agree.
2. A supported import/include from a thin harness-specific instruction file.
3. A symlink or junction when the harness and platform both follow it safely.
4. A user-approved deterministic managed projection only when no reference mechanism exists.

A prose pointer telling an agent to read another file is wiring only if the harness demonstrably loads and follows it; otherwise treat it as unverified. Never create import cycles. Keep a generated projection reproducible, record its source and hash outside the discovery root when extra files there are unsafe, and never hand-edit it. If no safe projection exists, report that strict single-source operation is unsupported instead of inventing fragile wiring.

Use relative repository links when supported and required to survive clones. Prefer imports or managed projections when links are unreliable on the target filesystem, operating system, archive format, or contributor workflow.

Respect instruction precedence: a higher-precedence override can disconnect lower shared instructions even when every path exists. Preserve required bootstrap/import lines when adding harness-specific content, and verify whether layers merge or replace one another.

For machine-local POSIX skill symlinks, use the bundled helper only with explicit, verified paths:

```bash
bash scripts/sync-skills.sh \
  --hub "/canonical/skills" \
  --target "/harness/skills" \
  --dry-run
```

Inspect the dry run, then repeat without `--dry-run`. Add `--target` for another verified target and `--skill` for a selected skill. Use `--prune` only when stale links owned by that hub should be removed. The helper creates absolute links: do not use it for clone-portable repository wiring. It neither configures discovery nor wires instruction files.

## 5. Apply changes safely

Before writing, establish the mapping `canonical source -> projection` for every in-scope skill and instruction file. Read each target and its resolved source before editing so a write-through link cannot modify an unintended file.

- Create parents narrowly; do not replace existing real directories.
- Move a canonical directory once rather than copying it into another root.
- Keep content edits at the canonical path. Referenced projections need no content sync.
- Treat foreign links, real directories, override files, same-name bundled skills, and existing imports as conflicts to resolve explicitly.
- Keep generated projections reproducible and exclude them from manual editing.
- Follow the active environment's approval rules for destructive or externally visible operations.

When migrating an existing setup, inventory consumers first, establish new projections second, verify them third, and remove old projections last. Keep the old source until every consumer passes functional verification.

## 6. Verify structure and behavior

Run all applicable checks:

1. Canonical-path check: every reference resolves to the intended source, or every managed projection matches its recorded source hash.
2. Integrity check: no broken links, duplicate authoritative files, unintended overrides, import cycles, name collisions, or truncated instructions remain.
3. Metadata check: every skill has valid frontmatter and matching directory/name.
4. Discovery check: each installed harness lists or loads the skill and instruction source from a clean session after any required reload.
5. Trigger check: auto-trigger and explicit invocation behave according to scope.
6. Instruction check: use harness introspection or a harmless behavior test to prove shared and harness-specific layers load in the intended order rather than replacing one another.
7. Isolation check: out-of-scope harnesses and repositories are unchanged.
8. State check: label uninstalled harnesses `planned`, filesystem-only results `wired`, and only runtime-tested results `verified`.

Report canonical paths, projections, evidence, checks, assumptions, and unsupported harness/platform behavior. Do not describe wiring as complete or portable when only filesystem checks passed.

## Onboard an unfamiliar harness

Do not add a hardcoded exception first. Re-run the inventory, add one evidence-backed matrix row, select the least invasive projection, and functionally verify it. Update reusable documentation or tooling only when the behavior is stable and broadly applicable; keep machine-specific facts in local configuration.
