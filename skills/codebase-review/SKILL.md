---
name: codebase-review
description: Audit an entire codebase/workspace or explicitly bounded subsystem for maintainability, consistency, interfaces, tests, dead code, duplication, and reuse, with evidence-backed findings and scored files or modules. Use for project-wide code-quality or maintainability reviews; do not use for a commit, patch, or change-request diff.
---

# Codebase review

Review the codebase/workspace or user-supplied subsystem for maintainability, cleanliness, and consistency. Do not ask the user questions. If scope or intent is missing, state conservative assumptions and proceed; never silently present a sample as exhaustive coverage.

## Establish evidence

1. Read applicable project/workspace instructions and identify generated, vendored, build-output, fixture, and third-party trees before reviewing code.
2. Inventory the in-scope structure, languages, build systems, dependency manifests, test layout, architectural boundaries, and whether version control is present.
3. Read representative entry points, public interfaces, core logic, boundary adapters, configuration, and tests. For an exhaustive claim, inspect every in-scope source file; otherwise publish the sampling method and exact files read.
4. Run safe existing checks when available and relevant. Use the project's documented toolchain; do not install global tools, rewrite lockfiles, or assume network access merely to complete the review. Distinguish clearly among code inspected, commands executed, and behavior inferred. Never say tests pass when they were only read or could not run.
5. Treat dynamic loading, reflection, generated code, platform-specific code, and public APIs as possible evidence against a dead-code claim. Mark uncertain findings for confirmation.

## Evaluate

1. **Architecture and boundaries** — Check module cohesion, dependency direction, responsibility placement, coupling, and parallel implementations of the same concern.
2. **Interfaces and documentation** — Check whether public and boundary contracts are explicit, stable, appropriately documented, and consistent with callers and implementations.
3. **Consistency** — Check naming, project idioms, error handling, state management, configuration, and formatting without imposing unrelated personal preferences.
4. **Tests and verification** — Assess important behavior, failure paths, boundary conditions, integration seams, test reliability, and whether the documented verification workflow is executable.
5. **Dead or redundant code** — Identify unreachable, obsolete, duplicate, or superseded code only when evidence supports the claim.
6. **Reuse and abstraction** — Flag divergent duplication and abstractions at the wrong level. Prefer the language standard library and dependencies already present; recommend a new dependency only after verifying compatibility, maintenance, license, platform support, and concrete benefit. If offline or otherwise unable to verify it, label the recommendation unverified.
7. **Operational maintainability** — Check diagnostics, migration or compatibility burden, build reproducibility, and platform assumptions where they materially affect ongoing maintenance.

## Scale the review honestly

Score quality from 1–10 using a stated rubric. Score each source file only when every file was inspected. For larger scopes, score cohesive modules/directories, list representative files, and give unreviewed areas no score rather than inventing precision. Weight the overall score by risk and importance, not by averaging equally.

## Report

Write the report in this order:

1. assumptions and scope;
2. coverage map: inspected, executed, sampled, and not reviewed;
3. prioritized findings, ordered by severity and maintenance risk;
4. rubric and component scores;
5. overall score with rationale;
6. verification run and exact results;
7. limitations that prevent stronger conclusions.

For each finding include evidence (file and symbol/line where possible), impact, confidence (`confirmed`, `risk`, or `hypothesis`), and the smallest credible remediation. Include specific strengths only when evidence supports them; do not pad the report with vague praise.
