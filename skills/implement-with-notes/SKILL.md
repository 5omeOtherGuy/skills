---
name: implement-with-notes
description: Implement a specification while maintaining implementation-notes.html, transfer every reviewer-facing entry into its durable review destination, verify the transfer, then delete the file. Use when the user asks to implement something "with notes", wants a durable review decision log, or provides a specification whose execution will involve judgment calls.
---

# Implement with reviewer notes

Implement the spec given with the invocation.

Where the spec is ambiguous, default to deciding yourself and recording the decision in the notes — that is what the notes are for. Ask the user only when the spec leaves a material fork that changes what gets built (conflicting requirements, two incompatible readings of scope, a missing constraint you cannot infer from the codebase), batched into one round (use the harness's structured-question tool if available, otherwise plain text). If no answer is available, take the most defensible path and record it as an explicit assumption in the notes.

Keep a running `implementation-notes.html` file throughout the work. Update it whenever you make or discover a decision that is not explicit in the spec, including:

- decisions you had to make that were not specified
- things you had to change from the spec or from an initial approach
- tradeoffs you made and why
- constraints, caveats, follow-up risks, or reviewer context someone must know to review the work

Make the notes useful to a reviewer: keep them concise, factual, and organized in HTML. Do not use the notes file as a progress log for routine steps; record only information that affects understanding or reviewing the implementation.

## Durable review handoff

The PR body is the authoritative final home because reviewers see it with the diff and it survives squash merging. Treat the notes file as a guarded staging artifact:

1. Keep `implementation-notes.html` intact until the implementation and notes are final.
2. Copy every note entry into a clearly labeled `Implementation notes` section of the PR body. Converting the HTML to readable Markdown is allowed; omitting entries or replacing them with a summary is not.
3. Read the PR body back and verify that the complete transfer succeeded.
4. Only after verification, delete `implementation-notes.html`. If it is tracked, commit and push the deletion so the file is absent from the final PR diff.
5. If notes change afterward, recreate or restore the file, update and verify the PR body again, then delete the file again.

Never delete, truncate, overwrite, or exclude the notes before the verified PR-body transfer. In a workflow that intentionally produces no PR, perform the same verified transfer into the final report instead. If a PR is expected but cannot be created or its body cannot be updated, retain the file, report the blocker, and do not claim the review handoff is complete. Follow the active harness's approval rules for creating or editing a PR.

In the final response, provide the PR URL (or, in a no-PR workflow, where the notes landed) and confirm both the verified transfer and subsequent file deletion. If blocked, state that the file remains and the handoff is incomplete.
