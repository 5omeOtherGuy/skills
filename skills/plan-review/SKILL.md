---
name: plan-review
description: Review an implementation plan, design proposal, or technical approach for consistency, integration seams, reuse, abstraction, feasibility, blast radius, and verification, with a scored and prioritized risk report. Use before implementation when the user asks to critique, assess, or score a proposed change.
---

# Plan review

Evaluate whether executing the supplied plan would produce a maintainable, coherent change in its target system. Review as a maintainer responsible for future cost and risk, not only initial delivery.

Do not ask the user questions. Work from the plan and available repository evidence. State assumptions and unavailable evidence at the top; never turn an unverified claim into a finding of fact.

## Ground the review

1. Identify the plan's stated goal, scope, non-goals, constraints, acceptance criteria, and authoritative references.
2. When a target codebase/workspace is available, read applicable instructions and the specific architecture, interfaces, dependencies, tests, and files the plan claims it will change. Do not review from the plan alone while asserting facts about unread code.
3. When only plan text is available, evaluate its internal quality and label codebase-dependent conclusions as unverified.
4. Reference plan sections, steps, or quotations for every significant finding; reference repository files and symbols when they supply the evidence.

## Evaluate

1. **Consistency** — Does the approach follow established architecture, naming, conventions, and dependency direction, or create a parallel system?
2. **Integration seams** — Are changed contracts, ownership boundaries, data flow, failure behavior, and compatibility expectations explicit?
3. **Internal reuse** — Does it use existing modules and helpers without forcing unrelated responsibilities into them or duplicating logic that can diverge?
4. **External reuse** — Does it use the standard library or existing dependencies appropriately? Verify availability and fit before recommending a new library; include compatibility, maintenance, license, supported platforms, adoption cost, and offline/deployment constraints. Label anything you cannot verify rather than presenting it as an available solution.
5. **Abstraction level** — Are abstractions justified by current complexity and real reuse, avoiding both speculative layers and brittle copy-paste?
6. **Feasibility and sequencing** — Are prerequisites, migration order, intermediate states, rollout, rollback, and ownership clear enough to execute safely?
7. **Blast radius** — Does the plan identify affected behavior, callers, data, configuration, operations, supported environments, backward compatibility, and failure modes?
8. **Tests and verification** — Does it prove new and preserved behavior at the right layers, including integration seams, failure paths, migration, and platform-relevant checks?
9. **Scope discipline** — Flag omissions that block the goal, shortcuts that make in-scope work incorrect, and additions that are unnecessary scope creep.

## Score and report

State a 1–10 rubric before scoring. Score the fixed dimensions above and, when useful, major plan components. Mark a genuinely irrelevant dimension `not applicable` without penalty; mark a relevant but unverifiable dimension `insufficient evidence` and explain what is missing. Derive the overall score from risk and importance rather than a mechanical average.

Report in this order:

1. assumptions and evidence limits;
2. prioritized findings, highest implementation/maintenance risk first—each with a plan reference, supporting repository evidence when available, impact, and the smallest concrete plan revision;
3. unanswered requirements the implementer would otherwise have to guess;
4. dimension and component scores with concise justification;
5. overall score and the minimum changes needed to make the plan implementation-ready.

Avoid vague praise. Include strengths only when they are specific and relevant to execution risk.
