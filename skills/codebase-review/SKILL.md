---
name: codebase-review
description: Audit an entire repository or explicitly bounded subsystem for maintainability, consistency, interfaces, tests, dead code, duplication, and reuse, with evidence-backed findings and scored files or modules. Use for project-wide code-quality or maintainability reviews; do not use for a commit, patch, or pull-request diff.
---

# Codebase review

Review the repository or user-supplied subsystem for maintainability, cleanliness, and consistency. Do not ask the user questions. If scope or intent is missing, state conservative assumptions and proceed; never silently present a sample as exhaustive coverage.

## Establish evidence

1. Read applicable repository instructions and identify generated, vendored, build-output, fixture, and third-party trees before reviewing code.
2. Inventory the in-scope structure, languages, build systems, dependency manifests, test layout, and architectural boundaries.
3. Read representative entry points, public interfaces, core logic, boundary adapters, configuration, and tests. For an exhaustive claim, inspect every in-scope source file; otherwise publish the sampling method and exact files read.
4. Run safe existing checks when available and relevant. Distinguish clearly among code inspected, commands executed, and behavior inferred. Never say tests pass when they were only read or could not run.
5. Treat dynamic loading, reflection, generated code, platform-specific code, and public APIs as possible evidence against a dead-code claim. Mark uncertain findings for confirmation.

## Evaluate

1. **Architecture and boundaries** — Check module cohesion, dependency direction, responsibility placement, coupling, and parallel implementations of the same concern.
2. **Interfaces and documentation** — Check whether public and boundary contracts are explicit, stable, appropriately documented, and consistent with callers and implementations.
3. **Consistency** — Check naming, project idioms, error handling, state management, configuration, and formatting without imposing unrelated personal preferences.
4. **Tests and verification** — Assess important behavior, failure paths, boundary conditions, integration seams, test reliability, and whether the documented verification workflow is executable.
5. **Dead or redundant code** — Identify unreachable, obsolete, duplicate, or superseded code only when evidence supports the claim.
6. **Reuse and abstraction** — Flag divergent duplication and abstractions at the wrong level. Prefer the language standard library and dependencies already present; recommend a new dependency only after verifying compatibility, maintenance, license, and concrete benefit.
7. **Operational maintainability** — Check diagnostics, migration or compatibility burden, build reproducibility, and platform assumptions where they materially affect ongoing maintenance.

## Scale the review honestly

Score quality from 1–10 using a stated rubric. Score each source file only when every file was inspected. For larger scopes, score cohesive modules/directories, list representative files, and give unreviewed areas no score rather than inventing precision. Weight the overall score by risk and importance, not by averaging equally.

## Report

Order findings by severity and maintenance risk. For each finding include evidence (file and symbol/line where possible), impact, and the smallest credible remediation. Separate confirmed defects from risks or hypotheses.

End with:

- assumptions and scope;
- coverage map: inspected, executed, sampled, and not reviewed;
- prioritized findings;
- rubric and component scores;
- overall score with rationale;
- verification run and exact results;
- limitations that prevent stronger conclusions.

Include specific strengths only when evidence supports them; do not pad the report with vague praise.
