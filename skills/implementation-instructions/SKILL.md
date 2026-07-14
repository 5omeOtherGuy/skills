---
name: implementation-instructions
description: Produce a verified, self-contained implementation prompt for a fresh agent session, including current state, read-first sources, scope, constraints, deferrals, durable implementation-note handoff, verification, and definition of done. Use when handing a coding task to another session or agent or when the user asks for implementation instructions or a handoff prompt.
---

# Implementation instructions for a fresh session

Write a ready-to-paste prompt for a fresh session that has no memory of this conversation. Carry every verified fact, constraint, open assumption, and success condition needed to implement the task without reconstructing hidden context.

## Establish ground truth

Inspect the actual task environment before writing:

1. Read applicable repository/agent instructions, the authoritative specification or user request, and the relevant implementation and test paths.
2. Determine whether the target session will share this filesystem, checkout, credentials, tools, and network access. When it will not, include repository/revision retrieval instructions and replace machine-local absolute paths with portable references.
3. Detect the version-control and collaboration model rather than assuming Git or a hosted pull request. Inspect the current revision, branch/bookmark when applicable, working changes, remotes/upstream when present, and divergence using native tools.
4. Refresh remote state only when available, safe, and permitted. Never disturb unfamiliar or uncommitted work to make the state cleaner. If state cannot be refreshed or verified, carry that limitation into the prompt.
5. Confirm every current-behavior claim against files or executed checks. Distinguish observed facts, documented claims, and inferences.
6. Verify that named commands, paths, dependencies, reference repositories, and review surfaces actually exist in this environment. Use platform-appropriate syntax; do not invent a familiar workflow.

Then close only material decisions the environment cannot settle: implementation depth, scope boundaries, deferrals, compatibility target, review workflow, or acceptance bar. Ask one batched round using a structured-question tool when available. Do not re-ask answered questions or solicit preferences that would not change the prompt. If no answer is available, choose the least risky defensible option and label it as an assumption.

## Produce the prompt

Use the sections below in this order. Keep every section, writing `None` plus a brief reason when it genuinely does not apply. Every line must be an instruction or verified fact useful to the target session. Keep goal, definition of done, and good result last.

<task>
Name exactly what to implement in one sentence. Cite the authoritative issue, document, ticket, path, or state that the user request is the only specification.
</task>

<current_state>
Summarize the verified revision/workspace state, current behavior, relevant existing seams, working changes that must be preserved, and anything that could not be verified. If the target does not share the workspace, say how to obtain the exact project and revision. Label time-sensitive facts as a snapshot the target session must re-check.
</current_state>

<read_first>
List at most 10 task-specific instruction, specification, architecture, decision, implementation, and test files. Put applicable repository/agent instructions first. Prefer repository-relative paths; when another checkout or remote source is required, identify it unambiguously. For large files, name relevant sections, symbols, or line ranges. Do not include generic onboarding.
</read_first>

<verify_first>
Tell the target session to re-check repository state and every drift-prone fact before editing, using the repository's native version-control workflow when one exists. Require it to preserve unfamiliar work and report unavailable remote verification rather than guessing.
</verify_first>

<environment_and_constraints>
State verified operating-system, shell, runtime/toolchain, package-manager, version-control, workspace, permission/approval, security, compatibility, and repository-specific constraints only where they affect this task.
</environment_and_constraints>

<reference_sources_and_adoption>
List relevant prior art and what to adopt from each source, why, and how closely: direct port, adapted implementation, interface pattern, or conceptual reference. Distinguish checked-out, remote-only, and unavailable sources.
</reference_sources_and_adoption>

<do_not_adopt>
List architectures, dependencies, features, compatibility burdens, and unrelated cleanup that must remain out of scope.
</do_not_adopt>

<scope_to_implement>
State the implementation depth: minimal useful slice, full feature, or named subset. Give a numbered list of independently checkable work units, including required compatibility or migration work. Distinguish:
- Shortcut (forbidden): doing in-scope work incompletely or incorrectly.
- Deferral (allowed): explicitly excluding named work for a stated reason.
</scope_to_implement>

<implementation_notes_requirement>
Require a running `implementation-notes.html` reviewer-decision log. Before creating it, inspect and preserve any existing file; do not overwrite concurrent or unrelated notes. Record only unspecified decisions, assumptions, deviations, tradeoffs, constraints, caveats, compatibility concerns, follow-up risks, and reviewer warnings—not routine progress or sensitive data.

Keep the file until every entry has been transferred verbatim in substance to a durable review artifact attached to the change (pull request, merge request, change request, reviewed issue, or equivalent) and read back. Delete it only after verified transfer and ensure deletion is included in the final change set.

If the workflow has no durable artifact that can be updated and read back, include every entry in a clearly labeled final-report section but retain `implementation-notes.html`; final-response delivery cannot be verified before the response is sent. Report that durable handoff and deletion remain pending rather than risking the only copy. Follow approval rules for external artifact changes.
</implementation_notes_requirement>

<reporting_requirement>
Require: changed files; checks executed and exact results; implemented scope; deferred scope with reasons; assumptions and verification limits; reference adoption and intentional non-adoption; review-artifact URL or no-artifact status; and confirmation of complete note transfer/read-back and subsequent deletion. If no readable durable artifact exists or transfer is blocked, require the file to remain and the handoff to be reported pending.
</reporting_requirement>

<goal>
State the complete outcome, what user-visible or system capability it provides, and what it enables next without expanding current scope.
</goal>

<definition_of_done>
Give concrete observable conditions for preserved and new behavior, compatibility, tests, and integration. Name only validation commands confirmed to exist, including platform-specific variants when needed. Require complete durable note transfer and removal of the working notes file only when that transfer was read back; otherwise require the file to remain with the pending handoff reported.
</definition_of_done>

<good_result>
Describe the acceptance bar and explicitly reject likely failure modes: scope creep, copied machinery, hidden deferrals, platform assumptions, premature abstractions, or test-only shortcuts.
</good_result>

Output only the finished target-session prompt, with no commentary about how it was produced.
