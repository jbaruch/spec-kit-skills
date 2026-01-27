---
name: speckit-03-plan
description: Create technical implementation plan from feature specification
---

# Spec-Kit Plan

Execute the implementation planning workflow using the plan template to generate design artifacts.

## User Input

```text
$ARGUMENTS
```

You **MUST** consider the user input before proceeding (if not empty).

## Constitution Loading (REQUIRED)

Before ANY action, load and internalize the project constitution:

1. Read constitution:
   ```bash
   cat .specify/memory/constitution.md 2>/dev/null || echo "NO_CONSTITUTION"
   ```

2. If file doesn't exist:
   ```
   ERROR: Project constitution not found at .specify/memory/constitution.md

   STOP - Cannot proceed without constitution.
   Run /speckit-00-constitution first to define project principles.
   ```

3. Parse all principles, constraints, and governance rules.

4. **Validation commitment:** Every output will be validated against each principle before being written.

## Prerequisites Check

1. Run setup script:
   ```bash
   .specify/scripts/bash/setup-plan.sh --json
   ```

2. Parse JSON for:
   - `FEATURE_SPEC` - path to spec.md
   - `IMPL_PLAN` - path to plan.md
   - `SPECS_DIR` - feature directory
   - `BRANCH` - current branch name

3. If error or missing spec.md:
   ```
   ERROR: spec.md not found in feature directory.
   Run /speckit-01-specify first to create the feature specification.
   ```

## Execution Flow

### 1. Setup

- Run setup script to get paths and copy plan template
- Read `FEATURE_SPEC` and constitution
- Load `IMPL_PLAN` template

### 2. Execute Plan Workflow

Follow the structure in IMPL_PLAN template to:

1. **Fill Technical Context** (mark unknowns as "NEEDS CLARIFICATION"):
   - Language/Version
   - Primary Dependencies
   - Storage
   - Testing
   - Target Platform
   - Project Type
   - Performance Goals
   - Constraints
   - Scale/Scope

2. **Fill Constitution Check section** from constitution principles

3. **Evaluate gates** - ERROR if violations cannot be justified

### 3. Phase 0: Outline & Research

1. **Extract unknowns from Technical Context**:
   - For each NEEDS CLARIFICATION -> research task
   - For each dependency -> best practices task
   - For each integration -> patterns task

2. **Research each unknown** and document findings

3. **Consolidate findings** in `research.md`:
   - Decision: [what was chosen]
   - Rationale: [why chosen]
   - Alternatives considered: [what else evaluated]

**Output**: `research.md` with all NEEDS CLARIFICATION resolved

### 4. Phase 1: Design & Contracts

**Prerequisites:** `research.md` complete

1. **Extract entities from feature spec** -> `data-model.md`:
   - Entity name, fields, relationships
   - Validation rules from requirements
   - State transitions if applicable

2. **Generate API contracts** from functional requirements:
   - For each user action -> endpoint
   - Use standard REST/GraphQL patterns
   - Output OpenAPI/GraphQL schema to `/contracts/`

3. **Create quickstart.md** with test scenarios

4. **Agent context update**:
   ```bash
   .specify/scripts/bash/update-agent-context.sh claude
   ```
   This updates CLAUDE.md with the new technology stack.

**Output**: `data-model.md`, `/contracts/*`, `quickstart.md`, updated agent file

### 5. Constitution Check (Post-Design)

Re-evaluate the Constitution Check after design phase:

- Verify all technical decisions align with principles
- If ANY violation detected:
  - STOP immediately
  - State: "CONSTITUTION VIOLATION: [Principle Name]"
  - Explain what specifically violates the principle
  - Suggest compliant alternative approach
  - DO NOT proceed with "best effort" or workarounds

## Output Validation (REQUIRED)

Before writing ANY artifact:

1. Review output against EACH constitutional principle
2. If ANY violation detected:
   - STOP immediately
   - State: "CONSTITUTION VIOLATION: [Principle Name]"
   - Explain: What specifically violates the principle
   - Suggest: Compliant alternative approach
3. If compliant, proceed and note: "Validated against constitution v[VERSION]"

## Key Rules

- Use absolute paths
- ERROR on gate failures or unresolved clarifications
- Command ends after Phase 1 design is complete

## Report

Output:
- Branch name
- IMPL_PLAN path
- Generated artifacts list:
  - research.md
  - data-model.md
  - contracts/*
  - quickstart.md
- Agent file update status

## Next Steps

After completing the plan:

1. **Recommended**: Run `/speckit-04-checklist` to create domain-specific quality checklists
   - Generates "unit tests for English" to validate requirements quality
   - Helps catch requirement gaps before implementation
   - Required to reach 100% before `/speckit-07-implement`

2. **Required**: Run `/speckit-05-tasks` to generate the task breakdown

Suggest to user:
```
Plan complete! Next steps:
- /speckit-04-checklist - (Recommended) Generate quality checklists for requirements validation
- /speckit-05-tasks - Generate task breakdown from plan
```
