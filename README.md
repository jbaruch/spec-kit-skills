# Spec-Kit Skills

An AI coding assistant skills bundle that replicates [GitHub Spec-Kit](https://github.com/github/spec-kit) functionality. Compatible with multiple AI agents including Claude Code, OpenAI Codex, Google Gemini, and OpenCode.

## What is This?

Spec-Kit Skills provides specification-driven development directly in your AI coding assistant without requiring external CLI tools. It implements the same workflow phases as vanilla Spec-Kit using the native skills system.

**Key Differences from Vanilla Spec-Kit:**
- **Vanilla**: Requires `specify-cli` installation via `uv tool install specify-cli`
- **Skills**: Zero installation - just copy the `.claude/skills/` directory to your project
- **Tessl Integration**: Automatic library documentation via Tessl tiles (when installed)

## Quick Start

### Installation

#### Linux/macOS (Bash)

```bash
# Copy skills bundle (symlinks preserved)
cp -r .claude .codex .gemini .opencode .specify AGENTS.md CLAUDE.md GEMINI.md your-project/

# Make scripts executable
chmod +x your-project/.specify/scripts/bash/*.sh
```

#### Windows (PowerShell)

```powershell
# Copy skills bundle
Copy-Item -Recurse .claude, .codex, .gemini, .opencode, .specify, AGENTS.md your-project/

# Create instruction file copies (symlinks require admin rights on Windows)
Copy-Item AGENTS.md your-project/CLAUDE.md
Copy-Item AGENTS.md your-project/GEMINI.md

# If skills symlinks didn't copy correctly, create junctions instead:
cmd /c mklink /J your-project\.codex\skills your-project\.claude\skills
cmd /c mklink /J your-project\.gemini\skills your-project\.claude\skills
cmd /c mklink /J your-project\.opencode\skills your-project\.claude\skills
```

> **Note:** Git on Windows converts symlinks to text files by default. Use `git config core.symlinks true` and clone with admin rights, or manually create junctions as shown above.

#### Start Using

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
│  1. /speckit-00-constitution  →  Define project governance principles      │
│  2. /speckit-01-specify       →  Create feature specification              │
│  3. /speckit-02-clarify       →  Resolve ambiguities (optional)            │
│  4. /speckit-03-plan          →  Create technical implementation plan      │
│  5. /speckit-04-checklist     →  Generate quality checklists (optional)    │
│  6. /speckit-05-tasks         →  Generate task breakdown                   │
│  7. /speckit-06-analyze       →  Validate consistency (optional)           │
│  8. /speckit-07-implement     →  Execute implementation                    │
│  9. /speckit-08-taskstoissues →  Export to GitHub Issues (optional)        │
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

Spec-Kit Skills integrates with [Tessl](https://tessl.io) to provide AI-optimized library documentation during planning and implementation. This integration is **automatic when Tessl is installed** and **gracefully skipped** when not available.

### What is Tessl?

Tessl is a **package manager for AI agent skills and context**. It provides "tiles" - versioned packages containing documentation, rules, and skills for libraries and frameworks. The [Tessl Registry](https://tessl.io/registry) contains 2,000+ evaluated tiles.

Tiles help AI agents:
- Use current API patterns (not outdated training data)
- Follow library-specific conventions
- Avoid common pitfalls and anti-patterns
- Leverage pre-built skills for common tasks

### Tile Types

| Type | Purpose | When Used |
|------|---------|-----------|
| **Documentation** | Library usage specs and examples | Queried before writing library code |
| **Rules** | Behavioral guidelines | Auto-applied via `.tessl/RULES.md` |
| **Skills** | AI commands for specific tasks | Invoked during implementation |

All tile types are **versioned and tracked** in `tessl.json`, ensuring reproducible agent behavior across environments. Skills can be discovered via `tessl skill search` or the [Tessl Registry](https://tessl.io/registry), which includes quality evaluations for each tile.

### Which Skills Use Tessl?

| Skill | Tessl Usage |
|-------|-------------|
| `/speckit-03-plan` | **Tile Discovery** - Searches and installs tiles for all technologies in Technical Context |
| `/speckit-05-tasks` | **Convention Queries** - Queries tiles for framework conventions when generating file paths |
| `/speckit-07-implement` | **Mandatory Queries** - Queries documentation before writing library code; invokes skill tiles |

### How It Works

1. **During `/speckit-03-plan`:**
   - Detects Tessl availability
   - Extracts technologies from Technical Context (language, frameworks, storage, testing)
   - Searches for and installs relevant tiles
   - Queries best practices
   - Documents findings in `research.md` under "Tessl Tiles" section

2. **During `/speckit-07-implement`:**
   - Loads tile catalog from `research.md`
   - Before implementing code using a tiled library, queries `mcp__tessl__query_library_docs`
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

### Available Skills

No skill tiles installed for this stack.

### Technologies Without Tiles

- Python 3.12: No specific version tile (using general patterns)
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
│    Source: .tessl/RULES.md                  │
│                                             │
│  Tiles used:             3 of 3 installed   │
╰─────────────────────────────────────────────╯
```

### Installation (Optional)

Tessl integration is optional. If not installed, skills continue without tile documentation.

```bash
npm install -g @tessl/cli
```

Explore available tiles at the [Tessl Registry](https://tessl.io/registry).

### Without Tessl

When Tessl is not installed, you'll see a one-time informational message:
```
ℹ️ Tessl not installed. Tile-based documentation unavailable.
   Install Tessl for enhanced library documentation: https://tessl.io
```

The workflow continues normally - Tessl enhances but is not required.

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
- `specs/NNN-feature-name/research.md` - Technology research (includes Tessl Tiles section if Tessl installed)
- `specs/NNN-feature-name/data-model.md` - Data structures
- `specs/NNN-feature-name/quickstart.md` - Usage examples
- `specs/NNN-feature-name/contracts/` - API/CLI contracts

**Contains:**
- Technical Context (language, frameworks, storage, testing)
- Project structure
- Constitution compliance check
- Complexity tracking

**Tessl Integration:** If Tessl is installed, this skill automatically:
- Searches for tiles matching technologies in Technical Context
- Installs relevant documentation, rules, and skill tiles
- Queries best practices from installed tiles
- Documents all tiles in `research.md` for use in implementation

---

### /speckit-04-checklist (Optional)

Generates domain-specific quality checklists for requirements validation.

**Prerequisites:** Plan must exist.

**Creates/Updates:**
- `specs/NNN-feature-name/checklists/*.md` - Domain-specific checklists

**Purpose:** "Unit tests for English" - validates REQUIREMENTS quality, not implementation.

**Note:** Implementation can proceed without checklists (user will be prompted to confirm).

---

### /speckit-05-tasks

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

**Tessl Integration:** If tiles are installed, queries framework conventions for:
- Project structure and file path generation
- Test organization patterns

---

### /speckit-06-analyze (Optional)

Validates cross-artifact consistency between spec, plan, and tasks.

**Prerequisites:** Tasks must exist.

**Checks:**
- All user stories have corresponding tasks
- All tasks trace back to requirements
- No orphaned artifacts
- Constitution compliance

**Note:** Recommended but not required before implementation.

---

### /speckit-07-implement

Executes implementation plan by processing tasks in order.

**Prerequisites:**
- Tasks must exist
- All checklists must be complete (100%)

**Behavior:**
- Processes tasks sequentially
- Updates task status in tasks.md
- Runs tests after each task
- Halts on test failure

**Tessl Integration:** If Tessl is installed, this skill:
- Loads tile catalog from `research.md`
- **Mandatory**: Queries `mcp__tessl__query_library_docs` before implementing code that uses a tiled library
- Invokes skill tiles when tasks match their purpose (e.g., test generation, API scaffolding)
- Generates Tessl Tile Usage Report showing documentation queries, skills invoked, and rules applied

---

### /speckit-08-taskstoissues (Optional)

Exports tasks to GitHub Issues for project tracking.

**Prerequisites:** Tasks must exist, GitHub repository configured.

**Creates:** GitHub Issues with labels, assignments, and cross-references.

## Project Structure

After running the full workflow:

```
your-project/
├── .claude/
│   └── skills/                  # Primary skills location (source of truth)
│       ├── speckit-00-constitution/
│       ├── speckit-01-specify/
│       ├── speckit-02-clarify/
│       ├── speckit-03-plan/
│       ├── speckit-04-checklist/
│       ├── speckit-05-tasks/
│       ├── speckit-06-analyze/
│       ├── speckit-07-implement/
│       └── speckit-08-taskstoissues/
├── .codex/skills -> ../.claude/skills   # Symlink for Codex
├── .gemini/skills -> ../.claude/skills  # Symlink for Gemini
├── .opencode/skills -> ../.claude/skills # Symlink for OpenCode
├── .specify/
│   ├── memory/
│   │   └── constitution.md      # Project governance
│   ├── scripts/bash/            # Workflow scripts (Linux/macOS)
│   ├── scripts/powershell/      # Workflow scripts (Windows)
│   └── templates/               # Artifact templates
├── specs/
│   └── NNN-feature-name/
│       ├── spec.md              # Feature specification
│       ├── plan.md              # Implementation plan
│       ├── tasks.md             # Task breakdown
│       ├── research.md          # Technology research
│       ├── data-model.md        # Data structures
│       ├── quickstart.md        # Usage examples
│       ├── contracts/           # API/CLI contracts
│       └── checklists/          # Quality checklists
├── AGENTS.md                    # Agent instructions (source of truth)
├── CLAUDE.md -> AGENTS.md       # Symlink for Claude Code
└── GEMINI.md -> AGENTS.md       # Symlink for Gemini
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

Scripts are located in `.specify/scripts/bash/` (Linux/macOS) and `.specify/scripts/powershell/` (Windows).

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
| Installation | `uv tool install specify-cli` | Copy directories |
| Commands | `/speckit.constitution` | `/speckit-00-constitution` |
| Prerequisites | Bash scripts | Bash + PowerShell scripts |
| Workflow enforcement | Identical | Identical |
| Phase separation | Identical | Identical |
| Output artifacts | Identical | Identical + Tessl tiles catalog |
| Windows support | Limited | Full (PowerShell scripts) |
| Library documentation | Manual | **Automatic via Tessl tiles** |
| Best practices lookup | Manual research | **Automatic tile queries** |

**Robustness:** Both implementations use scripts for workflow enforcement, providing identical protection against:
- Out-of-order phase execution
- Missing prerequisites
- Branch validation
- Empty/invalid inputs

## Troubleshooting

### "Command not found" for skills

Ensure skills are in the correct location for your agent:

**Bash:**
```bash
ls -la .claude/skills/speckit-*/SKILL.md
ls -la .codex/skills .gemini/skills .opencode/skills
```

**PowerShell:**
```powershell
Get-ChildItem .claude\skills\speckit-*\SKILL.md
Get-ChildItem .codex\skills, .gemini\skills, .opencode\skills
```

### Scripts not executable (Linux/macOS)

```bash
chmod +x .specify/scripts/bash/*.sh
```

### Prerequisites failing

Check the current feature context:

**Bash:**
```bash
.specify/scripts/bash/check-prerequisites.sh --json
```

**PowerShell:**
```powershell
.\.specify\scripts\powershell\check-prerequisites.ps1 -Json
```

### Symlinks not working (Windows)

Git on Windows converts symlinks to text files by default. Fix with:

```powershell
# Create directory junctions for skills
cmd /c mklink /J .codex\skills .claude\skills
cmd /c mklink /J .gemini\skills .claude\skills
cmd /c mklink /J .opencode\skills .claude\skills

# Copy instruction files (or enable symlinks with admin rights)
Copy-Item AGENTS.md CLAUDE.md
Copy-Item AGENTS.md GEMINI.md
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

# 6. Generate task breakdown (required)
/speckit-05-tasks

# 7. Validate consistency (optional - recommended)
/speckit-06-analyze

# 8. Implement (prompts to confirm if checklists incomplete)
/speckit-07-implement

# 9. Export to GitHub Issues (optional)
/speckit-08-taskstoissues
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

| Agent | Skills Location | Instructions File |
|-------|-----------------|-------------------|
| Claude Code | `.claude/skills/` | `CLAUDE.md` -> `AGENTS.md` |
| OpenAI Codex | `.codex/skills/` -> symlink | `AGENTS.md` |
| Google Gemini | `.gemini/skills/` -> symlink | `GEMINI.md` -> `AGENTS.md` |
| OpenCode | `.opencode/skills/` -> symlink | `AGENTS.md` |

> **Windows:** Symlinks require admin rights or Developer Mode. Use directory junctions (`mklink /J`) as an alternative. See [Troubleshooting](#symlinks-not-working-windows).

## Contributing

This is a community implementation of Spec-Kit for AI coding assistants. For the official Spec-Kit, see [github/spec-kit](https://github.com/github/spec-kit).

## License

MIT License - See [LICENSE](LICENSE) for details.
