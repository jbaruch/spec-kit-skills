---
name: speckit-07-implement
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
   Run /speckit-00-constitution first to define project principles.
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
   Run /speckit-05-tasks first to create the task list.
   ```

## Checklist Gating (CRITICAL)

**Before implementation begins**, check checklists status.

**Use this approach** (do NOT write custom bash for counting):

1. **Read each checklist file** in `FEATURE_DIR/checklists/` using the Read tool
2. **Count manually** by scanning the content:
   - Incomplete: lines starting with `- [ ]`
   - Complete: lines starting with `- [x]` or `- [X]`
3. **Build status table** from the counts

Example output:

| Checklist | Total | Completed | Incomplete | Status |
|-----------|-------|-----------|------------|--------|
| ux.md     | 12    | 12        | 0          | PASS   |
| test.md   | 8     | 5         | 3          | FAIL   |

**Decision logic:**
- **PASS**: All checklists have 0 incomplete items → proceed automatically
- **FAIL**: Any checklist has incomplete items → ask user:
  ```
  Some checklists are incomplete. Do you want to proceed with implementation anyway? (yes/no)
  ```
  - If "no"/"wait"/"stop": halt execution
  - If "yes"/"proceed"/"continue": proceed to next step

## Execution Flow

### 1. Load Implementation Context

- **REQUIRED**: Read `tasks.md` for complete task list and execution plan
- **REQUIRED**: Read `plan.md` for tech stack, architecture, and file structure
- **IF EXISTS**: Read `data-model.md` for entities and relationships
- **IF EXISTS**: Read `contracts/` for API specifications
- **IF EXISTS**: Read `research.md` for technical decisions
- **IF EXISTS**: Read `quickstart.md` for integration scenarios

### 2. Tessl Initialization (Optional but Recommended)

Initialize Tessl and install tiles for the planned tech stack BEFORE any implementation begins.

**Why Tessl:** AI agents often drift, misuse APIs, or fall back on outdated patterns when working with libraries. Tessl provides 10,000+ "tiles" of agent-optimized documentation that keeps implementation aligned with current best practices and prevents spinning on obscure library usage.

1. **Check if Tessl is available:**
   ```bash
   command -v tessl >/dev/null 2>&1 && echo "TESSL_AVAILABLE" || echo "TESSL_NOT_FOUND"
   ```

2. **If Tessl is NOT available**, display a gentle recommendation:
   ```
   ╭──────────────────────────────────────────────────────────────────╮
   │  Tessl not detected                                              │
   │                                                                  │
   │  Tessl helps AI agents write better code by providing accurate, │
   │  up-to-date documentation for libraries and frameworks.         │
   │                                                                  │
   │  Without Tessl, I may:                                          │
   │  • Use outdated API patterns                                    │
   │  • Miss library-specific conventions                            │
   │  • Spin on obscure library features                             │
   │                                                                  │
   │  Learn more: https://tessl.io                                   │
   │  Quick install: npm install -g tessl                            │
   ╰──────────────────────────────────────────────────────────────────╯
   ```
   Then proceed without Tessl.

3. **If Tessl IS available**, initialize and install tiles from plan.md:

   a. Initialize Tessl:
   ```bash
   tessl init --agent claude-code
   ```

   b. Extract technologies from plan.md **Technical Context** section:
   - Language/Version (e.g., Python, Node.js, TypeScript)
   - Primary Dependencies (e.g., Click, Express, React)
   - Storage (e.g., SQLite, PostgreSQL, MongoDB)
   - Testing (e.g., pytest, Jest, Vitest)
   - Any other frameworks/libraries mentioned

   c. For each technology, search for available tiles and install:
   ```bash
   # Search for tile
   tessl search <technology>

   # If tile found, install it
   tessl install tessl/<tile-name>
   ```

   Example for Python + Click + SQLite + pytest stack:
   ```bash
   tessl search python      # → install tessl/python if found
   tessl search click       # → install tessl/click if found
   tessl search sqlite      # → install tessl/sqlite3 if found
   tessl search pytest      # → install tessl/pytest if found
   ```

   d. Report installed tiles:
   ```
   Tessl initialized with tiles:
   ✓ tessl/python
   ✓ tessl/click
   ✓ tessl/sqlite3
   ✓ tessl/pytest
   ✗ tessl/somelib (not found in registry)

   Library documentation now available via MCP.
   ```

**Skip if:** User passes `--no-tessl` flag.

### 3. Project Setup Verification

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

### 4. Parse tasks.md

Extract:
- Task phases: Setup, Tests, Core, Integration, Polish
- Task dependencies: Sequential vs parallel execution rules
- Task details: ID, description, file paths, parallel markers [P]
- Execution flow: Order and dependency requirements

### 5. Execute Implementation

**Phase-by-phase execution**:
- Complete each phase before moving to the next
- Respect dependencies: Run sequential tasks in order
- Parallel tasks [P] can run together (different files, no dependencies)
- Follow TDD approach: Execute test tasks before implementation tasks
- Validation checkpoints: Verify each phase completion before proceeding

#### 5.1 Phase 1: Setup

Execute Setup phase tasks:
- Initialize project structure
- Create configuration files (package.json, pyproject.toml, etc.)
- Install dependencies (`npm install`, `pip install`, etc.)

**Note:** Tessl was already initialized in step 2 with tiles for the planned tech stack.

#### 5.2 Remaining Phases

Continue with remaining phases:
- **Phase 2: Foundational** - blocking prerequisites
- **Phase 3+: User Stories** - in priority order (P1, P2, P3...)
- **Final Phase: Polish** - cross-cutting concerns

**Implementation execution rules**:
- Tests before code: If tests requested, write them first and verify they fail
- Core development: Implement models, services, CLI commands, endpoints
- Integration work: Database connections, middleware, logging, external services
- Polish and validation: Unit tests, performance optimization, documentation

### 6. Output Validation (REQUIRED)

Before writing ANY file:

1. Review output against EACH constitutional principle
2. If ANY violation detected:
   - STOP immediately
   - State: "CONSTITUTION VIOLATION: [Principle Name]"
   - Explain: What specifically violates the principle
   - Suggest: Compliant alternative approach
   - DO NOT proceed with "best effort" or workarounds
3. If compliant, proceed with file write

### 7. Progress Tracking

- Report progress after each completed task
- Halt execution if any non-parallel task fails
- For parallel tasks [P], continue with successful tasks, report failed ones
- Provide clear error messages with context for debugging
- Suggest next steps if implementation cannot proceed
- **IMPORTANT**: For completed tasks, mark the task as [X] in the tasks file

### 8. Completion Validation

- Verify all required tasks are completed
- Check that implemented features match the original specification
- Validate that tests pass and coverage meets requirements
- Confirm the implementation follows the technical plan
- Report final status with summary of completed work

## Error Handling

| Condition | Detection | Response |
|-----------|-----------|----------|
| Tasks file missing | File not found | STOP with "Run /speckit-05-tasks first" |
| Plan file missing | File not found | STOP with "Run /speckit-03-plan first" |
| Constitution violation | Principle check fails | STOP, explain violation, suggest alternative |
| Checklist incomplete | User says "no" | STOP gracefully with instructions |
| Task fails | Non-zero exit or error | Report error, halt sequential tasks |

## Next Steps

After implementation:

1. **Required**: Run tests to verify functionality
2. **Required**: Commit and push changes
3. **Optional**: Run `/speckit-05-taskstoissues` to create GitHub Issues
   - Exports remaining tasks to GitHub for project tracking
   - Useful for team collaboration and sprint planning
   - Creates issues with labels, assignments, and cross-references

Suggest to user:
```
Implementation complete! Next steps:
- Run tests to verify functionality
- Commit and push changes
- /speckit-05-taskstoissues - (Optional) Export remaining tasks to GitHub Issues
```
