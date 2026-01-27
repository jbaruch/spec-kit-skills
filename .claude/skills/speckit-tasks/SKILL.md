---
name: speckit-tasks
description: Generate actionable task breakdown from plan and specification
---

# Spec-Kit Tasks

Generate an actionable, dependency-ordered tasks.md for the feature based on available design artifacts.

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

2. If exists, parse all principles - especially those affecting task ordering (e.g., TDD requirements).

## Prerequisites Check

1. Run prerequisites check:
   ```bash
   .specify/scripts/bash/check-prerequisites.sh --json
   ```

2. Parse JSON for `FEATURE_DIR` and `AVAILABLE_DOCS`.

3. If error or missing `plan.md`:
   ```
   ERROR: plan.md not found in feature directory.
   Run /speckit-plan first to create the implementation plan.
   ```

## Execution Flow

### 1. Load Design Documents

Read from FEATURE_DIR:
- **Required**: `plan.md` (tech stack, libraries, structure), `spec.md` (user stories with priorities)
- **Optional**: `data-model.md` (entities), `contracts/` (API endpoints), `research.md` (decisions), `quickstart.md` (test scenarios)

### 2. Execute Task Generation

1. Load `plan.md` and extract tech stack, libraries, project structure
2. Load `spec.md` and extract user stories with their priorities (P1, P2, P3, etc.)
3. If `data-model.md` exists: Extract entities and map to user stories
4. If `contracts/` exists: Map endpoints to user stories
5. If `research.md` exists: Extract decisions for setup tasks
6. Generate tasks organized by user story
7. Generate dependency graph showing user story completion order
8. Create parallel execution examples per user story
9. Validate task completeness

### 3. Task Format (REQUIRED)

Every task MUST strictly follow this format:

```text
- [ ] [TaskID] [P?] [Story?] Description with file path
```

**Format Components**:

1. **Checkbox**: ALWAYS start with `- [ ]` (markdown checkbox)
2. **Task ID**: Sequential number (T001, T002, T003...) in execution order
3. **[P] marker**: Include ONLY if task is parallelizable (different files, no dependencies)
4. **[Story] label**: REQUIRED for user story phase tasks only
   - Format: [US1], [US2], [US3], etc.
   - Setup phase: NO story label
   - Foundational phase: NO story label
   - User Story phases: MUST have story label
   - Polish phase: NO story label
5. **Description**: Clear action with exact file path

**Examples**:
- CORRECT: `- [ ] T001 Create project structure per implementation plan`
- CORRECT: `- [ ] T005 [P] Implement authentication middleware in src/middleware/auth.py`
- CORRECT: `- [ ] T012 [P] [US1] Create User model in src/models/user.py`
- CORRECT: `- [ ] T014 [US1] Implement UserService in src/services/user_service.py`
- WRONG: `- [ ] Create User model` (missing ID and Story label)
- WRONG: `T001 [US1] Create model` (missing checkbox)
- WRONG: `- [ ] [US1] Create User model` (missing Task ID)

### 4. Phase Structure

- **Phase 1**: Setup (project initialization)
- **Phase 2**: Foundational (blocking prerequisites - MUST complete before user stories)
- **Phase 3+**: User Stories in priority order (P1, P2, P3...)
  - Within each story: Tests (if requested) -> Models -> Services -> Endpoints -> Integration
  - Each phase should be independently testable
- **Final Phase**: Polish & Cross-Cutting Concerns

### 5. Task Organization

**From User Stories (spec.md)** - PRIMARY ORGANIZATION:
- Each user story (P1, P2, P3...) gets its own phase
- Map all related components to their story:
  - Models needed for that story
  - Services needed for that story
  - Endpoints/UI needed for that story
  - Tests specific to that story (if requested)
- Mark story dependencies

**From Contracts**:
- Map each contract/endpoint to the user story it serves
- Each contract -> contract test task [P] before implementation

**From Data Model**:
- Map each entity to the user story(ies) that need it
- If entity serves multiple stories: Put in earliest story or Setup phase
- Relationships -> service layer tasks

**From Setup/Infrastructure**:
- Shared infrastructure -> Setup phase (Phase 1)
- Foundational/blocking tasks -> Foundational phase (Phase 2)
- Story-specific setup -> within that story's phase

### 6. Generate tasks.md

Use template structure with:
- Correct feature name from plan.md
- Phase 1: Setup tasks
- Phase 2: Foundational tasks
- Phase 3+: One phase per user story (in priority order)
- Final Phase: Polish & cross-cutting concerns
- Dependencies section
- Parallel execution examples
- Implementation strategy section (MVP first, incremental delivery)

## Report

Output:
- Path to generated tasks.md
- Summary:
  - Total task count
  - Task count per user story
  - Parallel opportunities identified
  - Independent test criteria for each story
  - Suggested MVP scope (typically just User Story 1)
  - Format validation confirmation

## Next Steps

After generating tasks:

1. **Recommended**: Run `/speckit-analyze` to validate cross-artifact consistency
   - Checks all user stories have corresponding tasks
   - Verifies all tasks trace back to requirements
   - Detects orphaned artifacts and constitution violations
   - Catches issues before implementation begins

2. **Required**: Run `/speckit-implement` to execute the implementation
   - Note: Requires all checklists to be 100% complete

Suggest to user:
```
Tasks generated! Next steps:
- /speckit-analyze - (Recommended) Validate consistency between spec, plan, and tasks
- /speckit-implement - Execute implementation (requires 100% checklist completion)
```
