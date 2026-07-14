---
name: codebase-review
description: Review a whole codebase (not a diff) for maintainability, cleanliness, and consistency, with per-file (or per-module, for large repos) quality scores and a prioritized report. Use when the user asks for a project-wide review, code-quality audit, or maintainability assessment of a repository. For reviewing a diff/PR, use the harness's diff-review tooling instead.
---

# Codebase review

Review this codebase. The goal is to review the project for maintainability, cleanliness, and consistency. If the user supplied a scope or notes with the invocation, honor them; otherwise review the whole project. Do not ask the user questions; if the scope is underspecified, state your assumptions at the top of the report and proceed.

1. Ensure that the coding style is consistent through the whole application.
2. Check that all parts of the project have clean and well-documented interfaces.
3. Check that the codebase is well tested.
4. Check for dead code.
5. Check that similar logic is not duplicated unnecessarily to avoid the risk of logic diverging; use abstractions where it makes sense.
6. Review the code for unnecessary re-implementation of code that could be reused from the language's stdlib or an existing project dependency.
7. Score quality 1–10 with justification: per file where feasible; for large codebases, score cohesive modules/directories instead, sampling representative files and naming which files you actually read. State the rubric before assigning scores.

Write a detailed report at the end: prioritized findings (highest maintainability risk first), each backed by specific file references — no vague praise — and give the project an overall score.
