---
name: implementation-instructions
description: Write a fully self-contained implementation prompt for a fresh agent session, grounded in verified repository state, with task, read-first list, scope, deferrals, durable implementation-note handoff, and definition of done. Use when the user wants to hand a task to another session or agent, asks for a handoff prompt, or says "write implementation instructions".
---

# Implementation instructions for a fresh session

Write a prompt for a fresh session that will implement the task given with the invocation. The target session has no shared memory with this one, so the prompt you produce must be fully self-contained: it must carry every piece of context, constraint, and success criterion the other session needs.

Before writing the prompt, establish ground truth: verify the ACTUAL current state of the repo and the work rather than describing it from memory, from this conversation, or from a local checkout you have not just confirmed. Fetch when safe and available, then compare the working branch against its upstream if one exists (e.g. `git fetch`, then `git status -sb` and `git log --oneline ..@{u}` / `@{u}..`) and note whether local is behind/ahead/diverged. Read the real files, modules, and spec/issue the task touches as they exist now, and confirm anything you intend to assert about current behavior against that observed state. Anything you cannot verify — no upstream, no remote, blocked fetch, missing spec — must be stated as a limitation in the produced prompt, never guessed. Every fact in the sections below must reflect observed current state, not inference.

Then close open decisions before writing. If the invocation leaves a genuine choice open that repo state cannot settle — the scope boundary (minimal slice vs. full feature), which items to defer, the target session's workflow (PR-based or not), or the acceptance bar — ask the user in one batched round (use the harness's structured-question tool if available, otherwise plain text). Ask only questions whose answers would change the produced prompt; never re-ask what the invocation or the repo already answers, and never pad with preference questions. If an answer cannot be obtained, pick the most defensible option and record it as an explicit assumption in the produced prompt.

Produce the prompt for the target session using the sections below, IN THIS ORDER. Fill each from the task and context above; if a section has no value for this task, state that explicitly rather than dropping it. Do not pad with prose — every line must carry an instruction or a fact the target session needs. Goal, definition of done, and good result come LAST, on purpose.

<task>
One line naming exactly what to implement, with a reference to the authoritative spec (issue, doc section, ticket, path).
</task>

<read_first>
A curated list of the most relevant files/docs the target session must read before acting on this specific task. No more than 10 files. No general onboarding. Include only task-specific rules, ADRs, design docs, specs, or code paths that materially constrain the implementation. For large files, include relevant symbols/sections and line ranges where useful.
</read_first>

<verify_first>
Include an explicit instruction to confirm the working state is current before editing — sync the branch with its remote if an upstream exists, and verify against the real files, not a stale local checkout or this prompt's snapshot, since state may have drifted between when this prompt was written and when it runs. If remote verification is unavailable, instruct the target session to state that limitation before proceeding.
</verify_first>

<reference_sources_and_adoption>
- Where relevant prior art lives (paths, repos).
- What to adopt, from where, and why — and how closely (port vs. conceptual reference).
</reference_sources_and_adoption>

<do_not_adopt>
State briefly what NOT to pull in, listed explicitly (architectures, systems, dependencies, features that are out of scope).
</do_not_adopt>

<scope_to_implement>
- How much to build (e.g. minimal useful slice, full feature, specific subset) — state which.
- A numbered, concrete list of the units of work, each independently checkable.
- Distinguish and never conflate:
    - Shortcut (forbidden): doing in-scope work cheaply, incompletely, or incorrectly.
    - Deferral (allowed): declaring something out-of-scope — every deferral must name what and why.
</scope_to_implement>

<implementation_notes_requirement>
Keep a running `implementation-notes.html` file throughout the work. Update it whenever you make or discover a decision that is not explicit in the spec, including decisions you had to make, changes from the spec or from an initial approach, tradeoffs and why, constraints, caveats, follow-up risks, or reviewer context someone must know to review the work. Keep the notes concise, factual, and organized in HTML. Do not use the notes file as a progress log for routine steps; record only information that affects understanding or reviewing the implementation.

Treat these notes as required review material, not a disposable working file. Before completing the task, copy every entry into a clearly labeled `Implementation notes` section of the PR body; converting HTML to readable Markdown is allowed, but omission or replacement with a vague summary is not. Read the PR body back and confirm the transfer succeeded. Only then delete `implementation-notes.html`; if it is tracked, commit and push its deletion so it is absent from the final PR diff. Never delete or truncate the file before the verified transfer. In a workflow that intentionally produces no PR, require the same verified transfer into the final report instead. If a PR is expected but cannot be created or its body cannot be updated, keep the file, report the blocker, and do not claim the handoff is complete. Follow the active harness's approval rules for creating or editing a PR.
</implementation_notes_requirement>

<reporting_requirement>
What the final response must contain: files changed; tests run and results; exact implemented scope; exact deferred scope and why each deferral belongs outside the chosen scope; comparison against the reference sources (what was adopted, what was intentionally not); the PR URL (or, in a no-PR workflow, where the work landed); confirmation that every implementation-note entry is in the PR body (or the agreed notes destination); and confirmation that `implementation-notes.html` was deleted only after that transfer was read back successfully. If the transfer is blocked, report that the file was retained and the handoff remains incomplete.
</reporting_requirement>

<goal>
The complete outcome, start to finish, and what it enables to be built on next.
</goal>

<definition_of_done>
Concrete, checkable conditions: existing behavior preserved, new behavior present and observable, tests proving it, the exact validation/gate commands to run, every implementation-note entry present in the verified PR body (or the agreed notes destination), and `implementation-notes.html` absent from the final PR diff only after that verified transfer.
</definition_of_done>

<good_result>
The success exemplar / acceptance bar: what a good implementation looks like, and explicitly what
it should NOT turn into (scope creep, ported machinery, premature abstraction).
</good_result>

Output only the finished prompt for the target session — ready to paste, with no commentary about how you wrote it.
