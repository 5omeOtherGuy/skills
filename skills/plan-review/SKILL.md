---
name: plan-review
description: Review an implementation plan for maintainability, integration seams, reuse, abstraction level, blast radius, and test strategy, with scores and a prioritized risk report. Use when the user asks to review, critique, or score a plan, design doc, or proposed approach before implementation.
---

# Plan review

Review this implementation plan (given with the invocation as a path or pasted text). The goal is to evaluate whether, if executed as written, it would produce a maintainable, clean, and consistent result in the target system — especially where the plan integrates with or changes existing functionality.

Do not ask the user questions; work with what the invocation provides. If the plan, its target codebase, or the review scope is underspecified, state your assumptions explicitly at the top of the report and proceed.

Judge the plan as a maintainer worried about the future cost and risk of this change, not just whether it will ship.

1. Consistency with what exists — Does the plan follow the established architecture, patterns, naming, and conventions of the current codebase? Flag anywhere it introduces a parallel or divergent way of doing something the project already does.
2. Integration seams — Are the boundaries between the new feature and existing functionality clearly defined? Are the interfaces/contracts it adds or changes clean, explicit, and well-specified? Identify vague, hand-wavy, or under-specified integration points.
3. Reuse over reinvention (internal) — Does the plan reuse existing helpers, modules, and abstractions, or does it re-implement logic the project already has? Call out any duplication that risks the two copies diverging over time.
4. Reuse over reinvention (external) — Does it handroll anything that stdlib or an existing project dependency already provides? Flag it and name the alternative.
5. Right level of abstraction — Are new abstractions justified by real complexity or duplication they remove, or is the plan over-engineering (speculative configurability, one-use layers) or under-engineering (copy-paste that should be shared)?
6. Impact on existing code — Where does this touch, modify, or expand current behavior? Assess backward-compatibility, migration, and the blast radius. Flag anywhere existing behavior could silently change.
7. Test & verification strategy — Does the plan specify how new and changed behavior will be tested, including the integration points with existing functionality? Identify coverage gaps.
8. Dead-on-arrival / scope risk — Flag steps that are unnecessary, redundant, or scope creep that doesn't serve the plan's stated goal.
9. Scoring — Give each major section/component of the plan a quality score of 1–10 with justification, then an overall score. State the rubric you're using for the scores before assigning them.

Write a detailed report at the end with prioritized findings (highest maintainability/integration risk first), and give the plan an overall score. Back every significant finding with a specific reference to the plan; do not give vague praise.
