---
name: speckit-implement
description: Execute implementation plan by processing all tasks in tasks.md
---

# Spec-Kit Implement

Execute the implementation plan by processing and executing all tasks defined in tasks.md.

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
   Run /speckit-constitution first to define project principles.
   ```

3. Parse all principles, constraints, and governance rules.

4. **Validation commitment:** Before writing ANY file, validate against each principle.

## Prerequisites Check

1. Run prerequisites check:
   ```bash
   .specify/scripts/bash/check-prerequisites.sh --json --require-tasks --include-tasks
   ```

2. Parse JSON for `FEATURE_DIR` and `AVAILABLE_DOCS`.

3. If error or missing `tasks.md`:
   ```
   ERROR: tasks.md not found in feature directory.
   Run /speckit-tasks first to create the task list.
   ```

## Checklist Gating (CRITICAL)

**Before implementation begins**, check checklists status:

1. Scan all checklist files in `FEATURE_DIR/checklists/`

2. For each checklist, count:
   - Total items: All lines matching `- [ ]` or `- [X]` or `- [x]`
   - Completed items: Lines matching `- [X]` or `- [x]`
   - Incomplete items: Lines matching `- [ ]`

3. Create status table:

   | Checklist | Total | Completed | Incomplete | Status |
   |-----------|-------|-----------|------------|--------|
   | ux.md     | 12    | 12        | 0          | PASS   |
   | test.md   | 8     | 5         | 3          | FAIL   |

4. Calculate overall status:
   - **PASS**: All checklists have 0 incomplete items
   - **FAIL**: One or more checklists have incomplete items

5. **If any checklist is incomplete**:
   - Display the table with incomplete item counts
   - **STOP** and ask: "Some checklists are incomplete. Do you want to proceed with implementation anyway? (yes/no)"
   - Wait for user response before continuing
   - If user says "no" or "wait" or "stop", halt execution
   - If user says "yes" or "proceed" or "continue", proceed to next step

6. **If all checklists are complete**: Automatically proceed

## Execution Flow

### 1. Load Implementation Context

- **REQUIRED**: Read `tasks.md` for complete task list and execution plan
- **REQUIRED**: Read `plan.md` for tech stack, architecture, and file structure
- **IF EXISTS**: Read `data-model.md` for entities and relationships
- **IF EXISTS**: Read `contracts/` for API specifications
- **IF EXISTS**: Read `research.md` for technical decisions
- **IF EXISTS**: Read `quickstart.md` for integration scenarios

### 2. Project Setup Verification

**Create/verify ignore files based on actual project setup:**

**Detection & Creation Logic**:
- Check if git repo: `git rev-parse --git-dir 2>/dev/null` -> create/verify `.gitignore`
- Check if Dockerfile exists or Docker in plan.md -> create/verify `.dockerignore`
- Check if .eslintrc* exists -> create/verify `.eslintignore`
- Check if eslint.config.* exists -> ensure config's `ignores` entries cover required patterns
- Check if .prettierrc* exists -> create/verify `.prettierignore`
- Check if .npmrc or package.json exists -> create/verify `.npmignore` (if publishing)
- Check if terraform files (*.tf) exist -> create/verify `.terraformignore`
- Check if helm charts present -> create/verify `.helmignore`

**Common Patterns by Technology** (from plan.md tech stack):
- **Node.js/JavaScript/TypeScript**: `node_modules/`, `dist/`, `build/`, `*.log`, `.env*`
- **Python**: `__pycache__/`, `*.pyc`, `.venv/`, `venv/`, `dist/`, `*.egg-info/`
- **Java**: `target/`, `*.class`, `*.jar`, `.gradle/`, `build/`
- **C#/.NET**: `bin/`, `obj/`, `*.user`, `*.suo`, `packages/`
- **Go**: `*.exe`, `*.test`, `vendor/`, `*.out`
- **Rust**: `target/`, `debug/`, `release/`, `*.rs.bk`
- **Universal**: `.DS_Store`, `Thumbs.db`, `*.tmp`, `*.swp`, `.vscode/`, `.idea/`

### 3. Parse tasks.md

Extract:
- Task phases: Setup, Tests, Core, Integration, Polish
- Task dependencies: Sequential vs parallel execution rules
- Task details: ID, description, file paths, parallel markers [P]
- Execution flow: Order and dependency requirements

### 4. Execute Implementation

**Phase-by-phase execution**:
- Complete each phase before moving to the next
- Respect dependencies: Run sequential tasks in order
- Parallel tasks [P] can run together (different files, no dependencies)
- Follow TDD approach: Execute test tasks before implementation tasks
- Validation checkpoints: Verify each phase completion before proceeding

**Implementation execution rules**:
- Setup first: Initialize project structure, dependencies, configuration
- Tests before code: If tests requested, write them first and verify they fail
- Core development: Implement models, services, CLI commands, endpoints
- Integration work: Database connections, middleware, logging, external services
- Polish and validation: Unit tests, performance optimization, documentation

### 5. Output Validation (REQUIRED)

Before writing ANY file:

1. Review output against EACH constitutional principle
2. If ANY violation detected:
   - STOP immediately
   - State: "CONSTITUTION VIOLATION: [Principle Name]"
   - Explain: What specifically violates the principle
   - Suggest: Compliant alternative approach
   - DO NOT proceed with "best effort" or workarounds
3. If compliant, proceed with file write

### 6. Progress Tracking

- Report progress after each completed task
- Halt execution if any non-parallel task fails
- For parallel tasks [P], continue with successful tasks, report failed ones
- Provide clear error messages with context for debugging
- Suggest next steps if implementation cannot proceed
- **IMPORTANT**: For completed tasks, mark the task as [X] in the tasks file

### 7. Completion Validation

- Verify all required tasks are completed
- Check that implemented features match the original specification
- Validate that tests pass and coverage meets requirements
- Confirm the implementation follows the technical plan
- Report final status with summary of completed work

## Error Handling

| Condition | Detection | Response |
|-----------|-----------|----------|
| Tasks file missing | File not found | STOP with "Run /speckit-tasks first" |
| Plan file missing | File not found | STOP with "Run /speckit-plan first" |
| Constitution violation | Principle check fails | STOP, explain violation, suggest alternative |
| Checklist incomplete | User says "no" | STOP gracefully with instructions |
| Task fails | Non-zero exit or error | Report error, halt sequential tasks |

## Next Steps

After implementation:
- Run tests to verify functionality
- Run `/speckit-taskstoissues` to create GitHub issues for any remaining work
- Commit and push changes

Note: This command assumes a complete task breakdown exists in tasks.md. If tasks are incomplete or missing, suggest running `/speckit-tasks` first to regenerate the task list.
