---
name: implement-with-notes
description: Implement a specification while maintaining implementation-notes.html as a guarded reviewer-decision log, then transfer every entry to the workflow's durable review artifact and verify the handoff before deleting the file. Use when the user asks to implement "with notes," wants durable implementation rationale, or supplies a specification that requires judgment calls.
---

# Implement with reviewer notes

Implement the specification supplied with the invocation while preserving every reviewer-relevant decision.

## Resolve material ambiguity

Default to making routine implementation decisions and recording them. Ask the user only when the specification leaves a material fork that changes what gets built: conflicting requirements, incompatible scope readings, or a missing constraint that repository evidence cannot settle. Batch questions into one round using a structured-question tool when available. If no answer is available, choose the most defensible path and record the assumption.

## Maintain the working notes

Before creating `implementation-notes.html`, check whether it already exists. Read and preserve it; never truncate or replace an existing file. Continue it only when it belongs to this task. If ownership is unclear or it belongs to concurrent work, resolve that conflict before implementation.

Update the file whenever you make or discover a decision not explicit in the specification, including:

- an unspecified decision or assumption;
- a change from the specification or initial approach;
- a tradeoff and its rationale;
- a constraint, caveat, compatibility issue, follow-up risk, or reviewer warning.

Keep entries concise, factual, organized HTML. Do not use the file as a routine progress log. Do not record credentials, secrets, personal data, exploit details inappropriate for the review audience, or other sensitive material; record a safe reference instead.

## Complete the durable handoff

Use the review surface attached to the change—such as a pull request, merge request, change request, or equivalent—as the preferred durable destination. If the workflow intentionally has no such artifact, use a clearly labeled `Implementation notes` section in the final report.

1. Keep `implementation-notes.html` intact until implementation and notes are final.
2. Transfer every entry, without replacing entries with a vague summary. Converting HTML to readable Markdown is allowed.
3. Read the destination back when the platform permits. For a final-report handoff, compare the prepared section against the file before sending it.
4. Only after complete transfer is verified, delete `implementation-notes.html` and ensure the deletion is included in the final change set or synchronized workspace.
5. If notes change afterward, restore the file, update and verify the durable destination again, then delete it again.

Never delete, truncate, hide, or exclude the notes before verified transfer. If the expected review artifact cannot be created or updated, retain the file, report the blocker, and do not claim the handoff is complete. Follow the active environment's approval rules before creating, editing, or publishing external review artifacts.

## Final response

Provide the review-artifact URL or identify the no-artifact destination. Confirm that every entry was transferred and read back, and that the working file was deleted only afterward. If blocked, state that the file remains and the handoff is incomplete.
