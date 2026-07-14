---
name: implement-with-notes
description: Implement a specification while maintaining implementation-notes.html as a guarded reviewer-decision log. Transfer every entry to a readable durable review artifact and delete the file only after verified handoff; retain it when no such destination exists. Use when the user asks to implement "with notes," wants durable implementation rationale, or supplies a specification that requires judgment calls.
---

# Implement with reviewer notes

Implement the specification supplied with the invocation while preserving every reviewer-relevant decision.

## Resolve material ambiguity

Default to making routine implementation decisions and recording them. Ask the user only when the specification leaves a material fork that changes what gets built: conflicting requirements, incompatible scope readings, or a missing constraint that repository evidence cannot settle. Batch questions into one round using a structured-question tool when available. If no answer is available, choose the most defensible path and record the assumption.

## Maintain the working notes

Before creating `implementation-notes.html`, confirm the task workspace is writable and check whether the file already exists. Read and preserve it; never truncate or replace an existing file. Continue it only when it belongs to this task. If the workspace is read-only, ownership is unclear, or the file belongs to concurrent work, report or resolve that blocker before implementation.

Update the file whenever you make or discover a decision not explicit in the specification, including:

- an unspecified decision or assumption;
- a change from the specification or initial approach;
- a tradeoff and its rationale;
- a constraint, caveat, compatibility issue, follow-up risk, or reviewer warning.

Keep entries concise, factual, organized HTML. Do not use the file as a routine progress log. Do not record credentials, secrets, personal data, exploit details inappropriate for the review audience, or other sensitive material; record a safe reference instead.

If no reviewer-facing entry was needed, verify the staging file has no entries, state `No implementation notes` in the final response, and remove the empty file. The durable-transfer requirement below applies whenever at least one entry exists.

## Complete the durable handoff

Use a durable review surface attached to the change—such as a pull request, merge request, change request, reviewed issue, or equivalent—as the destination. It must be updateable and readable back. If the workflow has no such artifact, include a clearly labeled `Implementation notes` section in the final report but retain the working file; delivery of a final response cannot be verified before it is sent.

1. Keep `implementation-notes.html` intact until implementation and notes are final.
2. Transfer every entry without replacing entries with a vague summary. Converting HTML to readable Markdown is allowed.
3. Read the durable destination back and compare it with the file.
4. Only after complete transfer is verified, delete `implementation-notes.html` and ensure the deletion is included in the final change set or synchronized workspace.
5. If notes change afterward, restore the file, update and verify the durable destination again, then delete it again.

Never delete, truncate, hide, or exclude the notes before verified durable transfer. If no readable durable destination exists or the expected artifact cannot be created or updated, retain the file, copy every entry into the final report, report the handoff pending, and do not claim deletion is complete. Follow the active environment's approval rules before creating, editing, or publishing external review artifacts.

## Final response

Provide the durable review-artifact URL and confirm complete transfer/read-back followed by deletion. If no readable artifact exists or transfer is blocked, include every note in the final response and state that the file remains and durable handoff is pending.
