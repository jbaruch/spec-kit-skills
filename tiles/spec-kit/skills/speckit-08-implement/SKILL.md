---
name: speckit-08-implement
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

   Cannot proceed without constitution.
   Run: /speckit-00-constitution
   ```

3. Parse all principles, constraints, and governance rules.

4. **Extract Enforcement Rules**:
   - Find all lines containing "MUST", "MUST NOT", "SHALL", "SHALL NOT", "REQUIRED", "NON-NEGOTIABLE"
   - Build enforcement checklist:
     ```
     CONSTITUTION ENFORCEMENT RULES:
     [MUST] ...
     [MUST NOT] ...
     [REQUIRED] ...
     ```
   - These rules will be checked BEFORE EVERY FILE WRITE

5. **Validation commitment:** Before writing ANY file, validate against each principle.

6. **Hard Gate Declaration**: State explicitly:
   ```
   ╭─────────────────────────────────────────────────────╮
   │  CONSTITUTION ENFORCEMENT GATE ACTIVE               │
   ├─────────────────────────────────────────────────────┤
   │  Extracted: X enforcement rules                     │
   │  Mode: STRICT - violations HALT implementation      │
   │  Checked: Before EVERY file write                   │
   ╰─────────────────────────────────────────────────────╯
   ```

## Prerequisites Check

1. Run prerequisites check (choose based on platform):

   **Unix/macOS/Linux:**
   ```bash
   .specify/scripts/bash/check-prerequisites.sh --json --require-tasks --include-tasks
   ```

   **Windows (PowerShell):**
   ```powershell
   pwsh .specify/scripts/powershell/check-prerequisites.ps1 -Json -RequireTasks -IncludeTasks
   ```

2. Parse JSON for `FEATURE_DIR` and `AVAILABLE_DOCS`.

3. If error or missing `tasks.md`:
   ```
   ERROR: tasks.md not found in feature directory.

   Run: /speckit-06-tasks
   ```

## Comprehensive Pre-Implementation Validation

**BEFORE any implementation, perform complete validation sweep:**

### 1. Artifact Completeness Check

Verify all required artifacts exist and are complete:

| Artifact | Required | Check |
|----------|----------|-------|
| constitution.md | YES | Has principles section |
| spec.md | YES | Has Requirements + Success Criteria |
| plan.md | YES | Has Technical Context defined |
| tasks.md | YES | Has at least one task |
| research.md | NO | Warn if missing |
| data-model.md | NO | Warn if missing |
| checklists/*.md | YES | At least one checklist |

### 2. Cross-Artifact Consistency Check

Validate relationships between artifacts:

1. **Spec → Tasks Traceability**:
   - Every FR-XXX requirement should have corresponding task(s)
   - Every user story should have a task phase
   - Report: "Coverage: X/Y requirements have tasks (Z%)"

2. **Plan → Tasks Alignment**:
   - Tech stack in plan matches task file paths (e.g., Python → .py files)
   - Project structure matches task paths
   - WARN if mismatch: "Plan says Python but tasks create .js files"

3. **Constitution → Plan Compliance**:
   - Re-verify no constitution violations in plan
   - Extract MUST/MUST NOT rules and validate

### 3. Implementation Readiness Score

```
╭─────────────────────────────────────────────────────╮
│  IMPLEMENTATION READINESS                            │
├─────────────────────────────────────────────────────┤
│  Artifacts:        X/Y complete              [✓/✗]  │
│  Spec Coverage:    X% requirements → tasks   [✓/✗]  │
│  Plan Alignment:   [Aligned/X mismatches]    [✓/✗]  │
│  Constitution:     [Compliant/X violations]  [✓/✗]  │
│  Checklists:       X/Y at 100%               [✓/✗]  │
│  Dependencies:     [Valid/Circular detected] [✓/✗]  │
├─────────────────────────────────────────────────────┤
│  OVERALL READINESS: [READY/BLOCKED]                 │
│  Blocking Issues: [None/List issues]                │
╰─────────────────────────────────────────────────────╯
```

**If BLOCKED**: List all blocking issues and required actions
**If READY**: Proceed to Checklist Gating

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
- **IF EXISTS**: Read `research.md` for technical decisions and Tessl tile catalog
- **IF EXISTS**: Read `quickstart.md` for integration scenarios
- **IF EXISTS**: Read `tests/test-specs.md` for test specifications from testify

### 1.1 Testify Output Check (TDD Support)

Check if test specifications exist from `/speckit-05-testify`:

1. Look for `FEATURE_DIR/tests/test-specs.md`
2. If found:
   - Note testify was run
   - Read TDD Assessment from the file
   - If TDD was **mandatory**, tests serve as acceptance criteria
   - Display: "Test specifications found. Implementing to pass test specs."
3. If not found:
   - Check constitution for TDD requirements
   - If TDD is **mandatory** in constitution:
     ```
     ERROR: TDD is required but testify was not run.

     The constitution requires test-first development.
     Run: /speckit-05-testify
     ```
   - If TDD is **optional**: Note that testify was skipped and continue

### 1.2 Assertion Integrity Verification (CRITICAL GATE)

**If test-specs.md exists**, verify assertion integrity BEFORE any implementation using the comprehensive check:

**Unix/macOS/Linux:**
```bash
.specify/scripts/bash/testify-tdd.sh comprehensive-check "FEATURE_DIR/tests/test-specs.md" ".specify/context.json" ".specify/memory/constitution.md"
```

**Windows (PowerShell):**
```powershell
pwsh .specify/scripts/powershell/testify-tdd.ps1 comprehensive-check "FEATURE_DIR/tests/test-specs.md" ".specify/context.json" ".specify/memory/constitution.md"
```

**Parse the JSON result:**

```json
{
    "overall_status": "PASS|WARN|BLOCKED",
    "block_reason": "...",
    "tdd_determination": "mandatory|optional|forbidden",
    "checks": {
        "context_hash": "valid|invalid|missing",
        "git_note": "valid|invalid|missing|skipped",
        "git_diff": "clean|modified|untracked|skipped"
    }
}
```

**Handle result based on `overall_status`:**

| Status | Action |
|--------|--------|
| `PASS` | Proceed with implementation |
| `WARN` | Display warning, proceed with implementation |
| `BLOCKED` | **HARD STOP** - display block reason and halt |

**If `BLOCKED`:**

```
╭─────────────────────────────────────────────────────────────────────────╮
│  ASSERTION INTEGRITY FAILURE                                            │
├─────────────────────────────────────────────────────────────────────────┤
│  [block_reason from JSON]                                               │
│                                                                         │
│  This is a BLOCKING error. Implementation cannot proceed.               │
│                                                                         │
│  Checks performed:                                                      │
│    Context hash: [context_hash]                                         │
│    Git note:     [git_note]                                             │
│    Git diff:     [git_diff]                                             │
│    TDD status:   [tdd_determination]                                    │
│                                                                         │
│  To resolve:                                                            │
│  1. If requirements changed: Update spec.md, re-run /speckit-05-testify │
│  2. If accidental edit: Restore test-specs.md from git                  │
│  3. If uncommitted changes: git checkout FEATURE_DIR/tests/test-specs.md│
│  4. If TDD mandatory but hash missing: Run /speckit-05-testify          │
│                                                                         │
│  Modifying test assertions to match buggy code defeats TDD.             │
│  The correct path is: fix the code to pass the tests.                   │
╰─────────────────────────────────────────────────────────────────────────╯

ERROR: Cannot proceed. Assertion integrity check failed.
```

**Blocking conditions (enforced by script, not LLM discretion):**
- `context_hash` or `git_note` is `invalid` → assertions were tampered with
- `git_diff` is `modified` → uncommitted changes to assertions
- `tdd_determination` is `mandatory` AND both hashes are `missing` → TDD required but testify not run

**Do NOT proceed with implementation if overall_status is BLOCKED.**

### 1.3 Circular Verification Warning

**IMPORTANT**: When test specifications exist from testify:

```
╭─────────────────────────────────────────────────────────────────────────╮
│  CIRCULAR VERIFICATION WARNING                                          │
├─────────────────────────────────────────────────────────────────────────┤
│  Test specifications define the expected behavior.                      │
│                                                                         │
│  During implementation:                                                 │
│  ✓ Fix code to pass tests - do NOT modify test assertions               │
│  ✓ Structural changes (file names, organization) are acceptable         │
│  ✗ Do NOT weaken assertions to make failing code pass                   │
│  ✗ Do NOT change expected values to match buggy implementation          │
│                                                                         │
│  If a test seems wrong, the requirement may need revision.              │
│  Re-run /speckit-05-testify after updating spec.md.                     │
╰─────────────────────────────────────────────────────────────────────────╯
```

This warning should be displayed once at the start of implementation when test specs exist.

### 2. Tessl Integration (MANDATORY if Tessl installed)

**Purpose**: Use Tessl tiles for accurate, up-to-date library documentation during implementation. This prevents API drift, outdated patterns, and spinning on obscure library features.

#### 2.1 Check Tessl Availability

**Platform Detection**:
- Unix/Linux/macOS: `command -v tessl >/dev/null 2>&1`
- Windows PowerShell: `Get-Command tessl -ErrorAction SilentlyContinue`

**If Tessl NOT Available**:
Display once and continue:
```
ℹ️ Tessl not installed. Tile-based documentation unavailable.
   Install Tessl for enhanced library documentation: https://tessl.io
```
Then proceed without Tessl (skip to section 3).

**If Tessl Available**: Integration is **automatic and mandatory**. Continue with sections 2.2-2.6.

#### 2.2 Load Tessl Context from research.md

If `/speckit-03-plan` was run with Tessl available, `research.md` contains a "Tessl Tiles" section with:
- List of installed tiles
- Available skills from skill tiles
- Technologies without tiles

**Read this section** to understand what tiles are available for implementation.

If `research.md` doesn't have a Tessl section (plan was run without Tessl), initialize tiles now:

```
mcp__tessl__status()
```

If no tiles installed, search and install for technologies in plan.md Technical Context:

```
mcp__tessl__search(query="<technology>")
mcp__tessl__install(packageName="<workspace/tile-name>")
```

#### 2.3 Initialize Tile Usage Tracking

Create an internal tracking structure for the completion report:
```
TESSL_USAGE = {
    "documentation_queries": [],    # Track (library, topic, task_id)
    "skills_invoked": [],           # Track (skill_name, task_ids)
    "rules_applied": false          # Set true if .tessl/RULES.md exists
}
```

Check if rules are being applied:
```bash
test -f .tessl/RULES.md && echo "RULES_ACTIVE" || echo "NO_RULES"
```

#### 2.4 Documentation Query Pattern (REQUIRED for each task)

**Before implementing ANY code that uses an installed tile's library**:

1. **Identify the library and feature needed** for the current task
2. **Query the tile**:
   ```
   mcp__tessl__query_library_docs(query="<specific task context for library>")
   ```
3. **Apply patterns** from the response to implementation
4. **Track the query** in TESSL_USAGE

**Example queries by task type**:
- Creating a CLI command: `mcp__tessl__query_library_docs(query="click command with options and arguments")`
- Database connection: `mcp__tessl__query_library_docs(query="sqlite3 connection context manager")`
- Writing tests: `mcp__tessl__query_library_docs(query="pytest fixtures for database testing")`
- API endpoint: `mcp__tessl__query_library_docs(query="fastapi route with request validation")`

**Query when**:
- Starting a task that uses a library with an installed tile
- Implementing non-trivial library features
- Encountering library-related errors
- Unsure about current best practices

**Do NOT query**:
- For basic language constructs (loops, conditionals)
- For the same pattern already queried this session
- When task doesn't involve an installed tile's library

#### 2.5 Skill Tile Usage During Implementation

**Skill tiles** provide specialized AI commands that can automate parts of implementation.

**Before starting each task**:
1. Check if any installed skill tile is relevant to the task
2. Skills are cataloged in research.md "Available Skills" section

**Examples of skill tile usage**:
- Database migration task → invoke migration skill if installed
- API endpoint scaffolding → invoke API scaffold skill if installed
- Test generation → invoke test generation skill if installed

**Pattern for invoking a skill tile**:
```
Skill(skill="<skill-name>", args="<context from current task>")
```

**After skill invocation**:
- Integrate skill output into implementation
- Track invocation in TESSL_USAGE.skills_invoked
- Continue with manual implementation for any gaps

**Example**:
```
Task: T015 Create unit tests for UserService

Check research.md → skill tile "test-gen" is installed
Invoke: Skill(skill="test-gen", args="UserService in src/services/user_service.py")
Integrate generated tests
Track: TESSL_USAGE.skills_invoked.append(("test-gen", ["T015"]))
```

#### 2.6 Handle Tessl Failures Gracefully

- **MCP tool unavailable**: Log warning, continue without tile queries
- **Query returns no useful result**: Proceed with best knowledge
- **Tile not found**: Note in report, implement without tile guidance
- **Network issues**: Log warning, continue implementation

**Skip Tessl if**: User passes `--no-tessl` flag.

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

**Note:** Tessl was initialized in step 2. Use `mcp__tessl__query_library_docs` before implementing features that use installed tile libraries.

#### 5.2 Remaining Phases

Continue with remaining phases:
- **Phase 2: Foundational** - blocking prerequisites
- **Phase 3+: User Stories** - in priority order (P1, P2, P3...)
- **Final Phase: Polish** - cross-cutting concerns

**Implementation execution rules**:
- **Tessl queries**: Before implementing code using an installed tile's library, query `mcp__tessl__query_library_docs` (see section 2.4)
- **Skill tiles**: Check if a skill tile can automate part of the task (see section 2.5)
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

### 9. Tessl Tile Usage Report (if Tessl was used)

If Tessl was available and used during implementation, generate a usage report:

```
╭─────────────────────────────────────────────╮
│  TESSL TILE USAGE REPORT                    │
├─────────────────────────────────────────────┤
│  Documentation queries:  X                  │
│    - <library>: <topics queried>            │
│    - <library>: <topics queried>            │
│                                             │
│  Skills invoked:         X                  │
│    - /<skill-name> (task IDs)               │
│    - /<skill-name> (task IDs)               │
│                                             │
│  Rules applied:          [Yes/No]           │
│    Source: .tessl/RULES.md                  │
│                                             │
│  Tiles used:             X of Y installed   │
│  Unused tiles:           <list if any>      │
╰─────────────────────────────────────────────╯
```

**Report includes**:
- Count of documentation queries made
- Which libraries were queried and for what topics
- Which skill tiles were invoked and for which tasks
- Whether rules from `.tessl/RULES.md` were applied
- Coverage: how many installed tiles were actually used

## Error Handling

| Condition | Detection | Response |
|-----------|-----------|----------|
| Tasks file missing | File not found | STOP with "Run /speckit-06-tasks first" |
| Plan file missing | File not found | STOP with "Run /speckit-03-plan first" |
| Constitution violation | Principle check fails | STOP, explain violation, suggest alternative |
| Checklist incomplete | User says "no" | STOP gracefully with instructions |
| Task fails | Non-zero exit or error | Report error, halt sequential tasks |

## Next Steps

After implementation:

1. **Required**: Run tests to verify functionality
2. **Required**: Commit and push changes
3. **Optional**: Run `/speckit-09-taskstoissues` to create GitHub Issues
   - Exports remaining tasks to GitHub for project tracking
   - Useful for team collaboration and sprint planning
   - Creates issues with labels, assignments, and cross-references

Suggest to user:
```
Implementation complete! Next steps:
- Run tests to verify functionality
- Commit and push changes
- /speckit-09-taskstoissues - (Optional) Export remaining tasks to GitHub Issues
```
