# Spec-Kit Skills

An AI coding assistant skills bundle that replicates [GitHub Spec-Kit](https://github.com/github/spec-kit) functionality. Compatible with multiple AI agents including Claude Code, OpenAI Codex, Google Gemini, and OpenCode.

## What is This?

Spec-Kit Skills provides specification-driven development directly in your AI coding assistant. It implements the same workflow phases as vanilla Spec-Kit using AI agent skills, with integrated library documentation via Tessl tiles.

**Key Differences from Vanilla Spec-Kit:**
- **Vanilla**: Requires `specify-cli` installation via `uv tool install specify-cli`
- **Skills**: Install via Tessl - `tessl install tessl-labs/spec-kit`
- **Tessl Integration**: Automatic library documentation via Tessl tiles

## Quick Start

### Installation

```bash
# Install via Tessl
tessl install tessl-labs/spec-kit
```

This installs all 10 spec-kit skills into your project.

> **Don't have Tessl?** Install it first: `npm install -g @tessl/cli`

### Start Using

1. Launch your AI coding assistant in the project directory:
   ```bash
   claude          # Claude Code
   codex           # OpenAI Codex
   gemini          # Google Gemini CLI
   opencode        # OpenCode
   ```

2. Run your first skill:
   ```
   /speckit-00-constitution
   ```

### Workflow Overview

The workflow follows strict phase ordering. Each phase builds on the previous:

```
┌────────────────────────────────────────────────────────────────────────────┐
│  Utility: /speckit-core       →  Initialize project, status, help          │
├────────────────────────────────────────────────────────────────────────────┤
│  0. /speckit-00-constitution  →  Define project governance principles      │
│  1. /speckit-01-specify       →  Create feature specification              │
│  2. /speckit-02-clarify       →  Resolve ambiguities (optional)            │
│  3. /speckit-03-plan          →  Create technical implementation plan      │
│  4. /speckit-04-checklist     →  Generate quality checklists (optional)    │
│  5. /speckit-05-testify       →  Generate test specifications (TDD)        │
│  6. /speckit-06-tasks         →  Generate task breakdown                   │
│  7. /speckit-07-analyze       →  Validate consistency (optional)           │
│  8. /speckit-08-implement     →  Execute implementation                    │
│  9. /speckit-09-taskstoissues →  Export to GitHub Issues (optional)        │
└────────────────────────────────────────────────────────────────────────────┘
```

**Never skip phases.** Each skill validates its prerequisites before executing.

## Phase Separation

Understanding what belongs in each phase is critical:

| Content Type | Constitution | Specify | Plan |
|--------------|:------------:|:-------:|:----:|
| Governance principles | ✅ | | |
| Quality standards | ✅ | | |
| Development workflow rules | ✅ | | |
| User stories | | ✅ | |
| Requirements (functional) | | ✅ | |
| Acceptance criteria | | ✅ | |
| **Technology stack** | | | ✅ |
| **Framework choices** | | | ✅ |
| Data models | | | ✅ |
| Architecture decisions | | | ✅ |

**Important:** Constitution must be technology-agnostic. Tech stack decisions belong exclusively in the Plan phase.

## Tessl Integration

Spec-Kit Skills uses [Tessl](https://tessl.io) tiles to provide AI-optimized library documentation during planning and implementation.

### What are Tessl Tiles?

Tiles are versioned packages containing documentation, rules, and skills for libraries and frameworks. The [Tessl Registry](https://tessl.io/registry) contains 2,000+ evaluated tiles.

Tiles help AI agents:
- Use current API patterns (not outdated training data)
- Follow library-specific conventions
- Avoid common pitfalls and anti-patterns

### Tile Types

| Type | Purpose | When Used |
|------|---------|-----------|
| **Documentation** | Library usage specs and examples | Queried before writing library code |
| **Rules** | Behavioral guidelines | Auto-applied via `.tessl/RULES.md` |
| **Skills** | AI commands for specific tasks | Invoked during implementation |

### Which Skills Use Tiles?

| Skill | Tile Usage |
|-------|------------|
| `/speckit-03-plan` | **Tile Discovery** - Searches and installs tiles for technologies in Technical Context |
| `/speckit-06-tasks` | **Convention Queries** - Queries tiles for framework conventions when generating file paths |
| `/speckit-08-implement` | **Documentation Queries** - Queries tiles before writing library code; invokes skill tiles |

### How It Works

1. **During `/speckit-03-plan`:**
   - Extracts technologies from Technical Context (language, frameworks, storage, testing)
   - Searches for and installs relevant tiles
   - Queries best practices
   - Documents findings in `research.md` under "Tessl Tiles" section

2. **During `/speckit-08-implement`:**
   - Loads tile catalog from `research.md`
   - Queries `mcp__tessl__query_library_docs` before implementing library code
   - Invokes skill tiles when tasks match their purpose
   - Generates Tessl Tile Usage Report at completion

### Example Output

**research.md (Tessl Tiles section):**
```markdown
## Tessl Tiles

### Installed Tiles

| Technology | Tile                  | Type          | Version |
|------------|-----------------------|---------------|---------|
| Click      | tessl/pypi-click      | Documentation | 8.2.0   |
| pytest     | tessl/pypi-pytest     | Documentation | 8.4.0   |
| SQLite     | tessl/pypi-aiosqlite  | Documentation | 0.21.0  |
```

**Implementation Tile Usage Report:**
```
╭─────────────────────────────────────────────╮
│  TESSL TILE USAGE REPORT                    │
├─────────────────────────────────────────────┤
│  Documentation queries:  12                 │
│    - click: commands, options, groups       │
│    - pytest: fixtures, parametrize          │
│                                             │
│  Skills invoked:         0                  │
│  Rules applied:          Yes                │
│  Tiles used:             3 of 3 installed   │
╰─────────────────────────────────────────────╯
```

## TDD Support and Circular Verification Protection

Spec-Kit Skills includes built-in support for Test-Driven Development (TDD) with protection against a common AI pitfall: **circular verification**.

### The Problem: Circular Verification

When an AI implements code against test specifications, it may be tempted to modify the tests to match buggy code instead of fixing the code to pass the tests. This defeats the purpose of TDD.

### The Solution: Multi-Layer Protection

The `/speckit-05-testify` and `/speckit-08-implement` skills work together to prevent this:

1. **Hash-Based Integrity** - SHA256 hash of all assertion lines (Given/When/Then) stored in `context.json`
2. **Git Note Backup** - Tamper-resistant hash stored as git note (requires history rewrite to modify)
3. **Git Diff Detection** - Detects uncommitted changes to assertion lines
4. **Comprehensive Check** - Single script combining all checks with deterministic blocking

### Blocking Conditions

Implementation is **blocked** (not warned) when:

| Condition | Detection Method |
|-----------|------------------|
| Assertions modified | Hash mismatch in context.json or git note |
| Uncommitted assertion changes | `git diff` on Given/When/Then lines |
| TDD mandatory but testify not run | Hash missing + constitution requires TDD |

### How It Works

```
/speckit-05-testify                    /speckit-08-implement
       │                                       │
       ▼                                       ▼
┌─────────────────┐                  ┌─────────────────────┐
│ Generate tests  │                  │ comprehensive-check │
│ from spec.md    │                  │ (deterministic)     │
└────────┬────────┘                  └──────────┬──────────┘
         │                                      │
         ▼                                      ▼
┌─────────────────┐                  ┌─────────────────────┐
│ Store hash in:  │                  │ Verify hash from:   │
│ - context.json  │                  │ - context.json      │
│ - git note      │                  │ - git note          │
└─────────────────┘                  │ - git diff          │
                                     └──────────┬──────────┘
                                                │
                                     ┌──────────┴──────────┐
                                     │                     │
                                     ▼                     ▼
                              PASS/WARN              BLOCKED
                              (proceed)          (halt + explain)
```

### Constitutional TDD Requirements

The constitution can require, allow, or forbid TDD:

| Constitution Contains | TDD Status | Testify | Missing Hash at Implement |
|----------------------|------------|---------|---------------------------|
| "TDD MUST be used" | mandatory | Required | **BLOCKED** |
| No TDD indicators | optional | Optional | WARN |
| "test-after MUST be used" | forbidden | Error | N/A |

### Legitimate Test Changes

If requirements change and tests need updating:
1. Update `spec.md` with new requirements
2. Re-run `/speckit-05-testify` to regenerate tests
3. New hash is stored, implementation proceeds

This ensures test changes are intentional and traceable to requirement changes.

## Skills Reference

### /speckit-00-constitution

Creates project governance principles in `.specify/memory/constitution.md`.

**Run when:** Starting a new project or establishing governance for existing project.

**Creates:**
- `.specify/memory/constitution.md` - Project principles and non-negotiable rules

**Contains:**
- Core principles (e.g., Simplicity First, Test Coverage, CLI-First)
- Quality standards
- Development workflow rules
- Amendment process

**Does NOT contain:** Technology choices, frameworks, databases, languages.

---

### /speckit-01-specify

Creates a feature specification from natural language description.

**Prerequisites:** Constitution must exist.

**Run with:** Natural language feature description

**Creates:**
- `specs/NNN-feature-name/spec.md` - Feature specification
- `specs/NNN-feature-name/checklists/requirements.md` - Initial checklist
- Git branch `NNN-feature-name`

**Example:**
```
/speckit-01-specify Build a CLI task manager with add, list, and complete commands
```

---

### /speckit-02-clarify (Optional)

Identifies underspecified areas and asks targeted clarification questions.

**Prerequisites:** Specification must exist.

**Behavior:**
- Asks maximum 5 focused questions
- Updates spec.md with answers
- Marks clarification as complete in context

**Note:** Recommended for complex features, but plan can proceed without it.

---

### /speckit-03-plan

Creates technical implementation plan with technology decisions.

**Prerequisites:** Specification must exist (clarification recommended).

**Creates:**
- `specs/NNN-feature-name/plan.md` - Implementation plan
- `specs/NNN-feature-name/research.md` - Technology research (includes Tessl Tiles section)
- `specs/NNN-feature-name/data-model.md` - Data structures
- `specs/NNN-feature-name/quickstart.md` - Usage examples
- `specs/NNN-feature-name/contracts/` - API/CLI contracts

**Contains:**
- Technical Context (language, frameworks, storage, testing)
- Project structure
- Constitution compliance check
- Complexity tracking

**Tessl Integration:** Automatically searches for and installs tiles matching technologies in Technical Context, queries best practices, and documents findings in `research.md`.

---

### /speckit-04-checklist (Optional)

Generates domain-specific quality checklists for requirements validation.

**Prerequisites:** Plan must exist.

**Creates/Updates:**
- `specs/NNN-feature-name/checklists/*.md` - Domain-specific checklists

**Purpose:** "Unit tests for English" - validates REQUIREMENTS quality, not implementation.

**Note:** Implementation can proceed without checklists (user will be prompted to confirm).

---

### /speckit-05-testify

Generates test specifications from requirements before implementation (TDD support).

**Prerequisites:** Plan and spec must exist with acceptance scenarios.

**Creates:**
- `specs/NNN-feature-name/tests/test-specs.md` - Test specifications

**Purpose:** Enables Test-Driven Development by generating test specifications from requirements BEFORE implementation begins. Tests serve as acceptance criteria.

**TDD Assessment:** Analyzes constitution for TDD requirements:
- `mandatory` - Constitution requires TDD (e.g., "TDD MUST be used")
- `optional` - No TDD requirements found (can skip)
- `forbidden` - Constitution prohibits TDD (skill won't run)

**Circular Verification Protection:** Stores integrity hashes to prevent the AI from modifying tests to match buggy code.

**Note:** When TDD is mandatory in the constitution, `/speckit-08-implement` requires testify to have been run.

---

### /speckit-06-tasks

Generates actionable task breakdown from plan and specification.

**Prerequisites:** Plan must exist.

**Creates:**
- `specs/NNN-feature-name/tasks.md` - Task breakdown

**Task Format:**
```markdown
- [ ] T001 [P] [US1] Task description
      Files: src/path/to/file.py
```

Where:
- `T001` = Task ID
- `[P]` = Priority (P=Primary, S=Secondary)
- `[US1]` = User story reference

**Tessl Integration:** Queries framework tiles for project structure and test organization patterns.

---

### /speckit-07-analyze (Optional)

Validates cross-artifact consistency between spec, plan, and tasks.

**Prerequisites:** Tasks must exist.

**Checks:**
- All user stories have corresponding tasks
- All tasks trace back to requirements
- No orphaned artifacts
- Constitution compliance

**Note:** Recommended but not required before implementation.

---

### /speckit-08-implement

Executes implementation plan by processing tasks in order.

**Prerequisites:**
- Tasks must exist
- All checklists must be complete (100%)
- If TDD mandatory: testify must have been run

**Behavior:**
- Processes tasks sequentially
- Updates task status in tasks.md
- Runs tests after each task
- Halts on test failure

**Assertion Integrity Verification:** Before implementation, verifies test specifications haven't been tampered with:
```
╭─────────────────────────────────────────────────────────────────────────╮
│  ASSERTION INTEGRITY CHECK                                              │
├─────────────────────────────────────────────────────────────────────────┤
│  Context hash:  valid | invalid | missing                               │
│  Git note:      valid | invalid | missing                               │
│  Git diff:      clean | modified | untracked                            │
│  TDD status:    mandatory | optional                                    │
├─────────────────────────────────────────────────────────────────────────┤
│  Overall:       PASS | WARN | BLOCKED                                   │
╰─────────────────────────────────────────────────────────────────────────╯
```

**Tessl Integration:** Queries `mcp__tessl__query_library_docs` before implementing library code, invokes skill tiles when applicable, and generates usage report.

---

### /speckit-09-taskstoissues (Optional)

Exports tasks to GitHub Issues for project tracking.

**Prerequisites:** Tasks must exist, GitHub repository configured.

**Creates:** GitHub Issues with labels, assignments, and cross-references.

## Project Structure

After running the full workflow:

```
your-project/
├── .tessl/                         # Tessl installation (tiles, rules)
├── .specify/
│   └── memory/                     # Project artifacts (created by skills)
│       └── constitution.md         # Created by /speckit-00-constitution
├── specs/
│   └── NNN-feature-name/
│       ├── spec.md                 # Feature specification
│       ├── plan.md                 # Implementation plan
│       ├── tasks.md                # Task breakdown
│       ├── research.md             # Technology research + Tessl tiles
│       ├── data-model.md           # Data structures
│       ├── quickstart.md           # Usage examples
│       ├── contracts/              # API/CLI contracts
│       ├── checklists/             # Quality checklists
│       └── tests/
│           └── test-specs.md       # Test specifications (from /speckit-05-testify)
├── tessl.json                      # Tessl manifest (installed tiles)
├── AGENTS.md                       # Agent instructions (source of truth)
├── CLAUDE.md -> AGENTS.md          # Symlink for Claude Code
└── GEMINI.md -> AGENTS.md          # Symlink for Gemini
```

## Workflow Enforcement

The skills use scripts to enforce proper workflow (available in both Bash and PowerShell):

| Script | Purpose |
|--------|---------|
| `check-prerequisites` | Validates phase prerequisites |
| `create-new-feature` | Creates feature branch and directory |
| `setup-plan` | Initializes plan phase artifacts |
| `update-agent-context` | Updates AGENTS.md with tech stack |
| `common` | Shared utility functions |

Scripts are located in `.claude/skills/speckit-core/scripts/bash/` (Linux/macOS) and `.claude/skills/speckit-core/scripts/powershell/` (Windows).

### Prerequisite Checking

Skills automatically validate prerequisites. If you try to run `/speckit-03-plan` without a specification:

```
BLOCKED: Missing prerequisite
- Required: specs/NNN-feature-name/spec.md
- Run /speckit-01-specify first
```

### Branch Validation

The workflow requires proper Git branch naming:
- Format: `NNN-feature-name` (e.g., `001-task-cli`)
- Skills validate you're on the correct branch
- Prevents cross-feature contamination

## Comparison with Vanilla Spec-Kit

| Aspect | Vanilla Spec-Kit | Spec-Kit Skills |
|--------|------------------|-----------------|
| Installation | `uv tool install specify-cli` | `tessl install tessl-labs/spec-kit` |
| Commands | `/speckit.constitution` | `/speckit-00-constitution` |
| Prerequisites | Bash scripts | Bash + PowerShell scripts |
| Workflow enforcement | Identical | Identical |
| Phase separation | Identical | Identical |
| Output artifacts | Identical | Identical + Tessl tiles catalog |
| Windows support | Limited | Full (PowerShell scripts) |
| Library documentation | Manual | **Automatic via Tessl tiles** |
| Best practices lookup | Manual research | **Automatic tile queries** |

## Troubleshooting

### "Command not found" for skills

Ensure skills are installed:
```bash
tessl list
```

If not listed, reinstall:
```bash
tessl install tessl-labs/spec-kit
```

### Scripts not executable (Linux/macOS)

```bash
chmod +x .claude/skills/speckit-core/scripts/bash/*.sh
```

### Prerequisites failing

Check the current feature context:

**Bash:**
```bash
.claude/skills/speckit-core/scripts/bash/check-prerequisites.sh --json
```

**PowerShell:**
```powershell
.\.claude\skills\speckit-core\scripts\powershell\check-prerequisites.ps1 -Json
```

### Phase Separation Violations

Each artifact type has specific content. Mixing them causes problems:

| If you see... | In... | It belongs in... | Fix |
|---------------|-------|------------------|-----|
| Languages, frameworks, databases | Constitution | Plan | Re-run `/speckit-00-constitution` |
| Technology choices, libraries | Spec | Plan | Re-run `/speckit-01-specify` |
| Architecture decisions, data models | Spec | Plan | Re-run `/speckit-01-specify` |
| Governance principles, quality standards | Plan | Constitution | Re-run `/speckit-03-plan` |
| Development workflow rules | Spec or Plan | Constitution | Re-run the affected phase |

**Why this matters:**
- Constitution should be technology-agnostic (survives tech stack changes)
- Spec defines *what*, not *how* (implementation-independent)
- Plan defines *how* (all technical decisions in one place)

## Example: Task Management CLI

Here's a complete workflow example:

```bash
# 1. Initialize governance (required)
/speckit-00-constitution
# Answer questions about project principles

# 2. Create feature specification (required)
/speckit-01-specify Build a CLI task manager that lets users add tasks with
title and description, list all tasks, and mark tasks as complete.
Use SQLite for storage.

# 3. Clarify requirements (optional - recommended for complex features)
/speckit-02-clarify

# 4. Create technical plan (required)
/speckit-03-plan

# 5. Generate quality checklists (optional - recommended)
/speckit-04-checklist

# 6. Generate test specifications (optional - required if TDD in constitution)
/speckit-05-testify

# 7. Generate task breakdown (required)
/speckit-06-tasks

# 8. Validate consistency (optional - recommended)
/speckit-07-analyze

# 9. Implement (verifies test integrity if testify was run)
/speckit-08-implement

# 10. Export to GitHub Issues (optional)
/speckit-09-taskstoissues
```

## Upstream Relationship

This project tracks the upstream [GitHub Spec-Kit](https://github.com/github/spec-kit). See the `upstream/` directory for:

| Document | Purpose |
|----------|---------|
| [MIGRATION-ANALYSIS.md](upstream/MIGRATION-ANALYSIS.md) | How vanilla spec-kit was analyzed and converted |
| [TEST-REPORT.md](upstream/TEST-REPORT.md) | Comparison test results (happy path + adversarial) |
| [TEST-GUIDE.md](upstream/TEST-GUIDE.md) | How to run your own comparison tests |

**Current Version**: Based on Spec-Kit Template v0.0.90

## Supported Agents

| Agent | Instructions File |
|-------|-------------------|
| Claude Code | `CLAUDE.md` -> `AGENTS.md` |
| OpenAI Codex | `AGENTS.md` |
| Google Gemini | `GEMINI.md` -> `AGENTS.md` |
| OpenCode | `AGENTS.md` |

## Contributing

This is a community implementation of Spec-Kit for AI coding assistants. For the official Spec-Kit, see [github/spec-kit](https://github.com/github/spec-kit).

## License

MIT License - See [LICENSE](LICENSE) for details.
