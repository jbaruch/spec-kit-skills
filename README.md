# Spec-Kit Skills

A Claude Code skills bundle that replicates [GitHub Spec-Kit](https://github.com/github/spec-kit) functionality using the native Claude Code skills format.

## What is This?

Spec-Kit Skills provides specification-driven development directly in Claude Code without requiring external CLI tools. It implements the same workflow phases as vanilla Spec-Kit but uses Claude's native skills system.

**Key Difference from Vanilla Spec-Kit:**
- **Vanilla**: Requires `specify-cli` installation via `uv tool install specify-cli`
- **Skills**: Zero installation - just copy the `.claude/skills/` directory to your project

## Quick Start

### Installation

1. Copy the skills bundle to your project:

```bash
cp -r .claude/skills/speckit-* your-project/.claude/skills/
cp -r .specify your-project/
```

2. Ensure scripts are executable:

```bash
chmod +x your-project/.specify/scripts/bash/*.sh
```

3. Start using skills in Claude Code:

```
/speckit-constitution
```

### Workflow Overview

The workflow follows strict phase ordering. Each phase builds on the previous:

```
┌─────────────────────────────────────────────────────────────────────┐
│  1. /speckit-constitution  →  Define project governance principles  │
│  2. /speckit-specify       →  Create feature specification          │
│  3. /speckit-clarify       →  Resolve ambiguities (optional)        │
│  4. /speckit-plan          →  Create technical implementation plan  │
│  5. /speckit-checklist     →  Generate quality checklists           │
│  6. /speckit-tasks         →  Generate task breakdown               │
│  7. /speckit-analyze       →  Validate cross-artifact consistency   │
│  8. /speckit-implement     →  Execute implementation                │
│  9. /speckit-taskstoissues →  Export tasks to GitHub Issues         │
└─────────────────────────────────────────────────────────────────────┘
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

## Skills Reference

### /speckit-constitution

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

### /speckit-specify

Creates a feature specification from natural language description.

**Prerequisites:** Constitution must exist.

**Run with:** Natural language feature description

**Creates:**
- `specs/NNN-feature-name/spec.md` - Feature specification
- `specs/NNN-feature-name/checklists/requirements.md` - Initial checklist
- Git branch `NNN-feature-name`

**Example:**
```
/speckit-specify Build a CLI task manager with add, list, and complete commands
```

---

### /speckit-clarify

Identifies underspecified areas and asks targeted clarification questions.

**Prerequisites:** Specification must exist.

**Behavior:**
- Asks maximum 5 focused questions
- Updates spec.md with answers
- Marks clarification as complete in context

---

### /speckit-plan

Creates technical implementation plan with technology decisions.

**Prerequisites:** Specification must exist (clarification recommended).

**Creates:**
- `specs/NNN-feature-name/plan.md` - Implementation plan
- `specs/NNN-feature-name/research.md` - Technology research
- `specs/NNN-feature-name/data-model.md` - Data structures
- `specs/NNN-feature-name/quickstart.md` - Usage examples
- `specs/NNN-feature-name/contracts/` - API/CLI contracts

**Contains:**
- Technical Context (language, frameworks, storage, testing)
- Project structure
- Constitution compliance check
- Complexity tracking

---

### /speckit-checklist

Generates domain-specific quality checklists for requirements validation.

**Prerequisites:** Plan must exist.

**Creates/Updates:**
- `specs/NNN-feature-name/checklists/*.md` - Domain-specific checklists

**Purpose:** "Unit tests for English" - validates REQUIREMENTS quality, not implementation.

---

### /speckit-tasks

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

---

### /speckit-analyze

Validates cross-artifact consistency between spec, plan, and tasks.

**Prerequisites:** Tasks must exist.

**Checks:**
- All user stories have corresponding tasks
- All tasks trace back to requirements
- No orphaned artifacts
- Constitution compliance

---

### /speckit-implement

Executes implementation plan by processing tasks in order.

**Prerequisites:**
- Tasks must exist
- All checklists must be complete (100%)

**Behavior:**
- Processes tasks sequentially
- Updates task status in tasks.md
- Runs tests after each task
- Halts on test failure

---

### /speckit-taskstoissues

Exports tasks to GitHub Issues for project tracking.

**Prerequisites:** Tasks must exist, GitHub repository configured.

**Creates:** GitHub Issues with labels, assignments, and cross-references.

## Project Structure

After running the full workflow:

```
your-project/
├── .claude/
│   └── skills/
│       ├── speckit-constitution/
│       ├── speckit-specify/
│       ├── speckit-clarify/
│       ├── speckit-plan/
│       ├── speckit-checklist/
│       ├── speckit-tasks/
│       ├── speckit-analyze/
│       ├── speckit-implement/
│       └── speckit-taskstoissues/
├── .specify/
│   ├── memory/
│   │   └── constitution.md      # Project governance
│   ├── scripts/bash/            # Workflow enforcement scripts
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
└── CLAUDE.md                    # Claude Code context file
```

## Workflow Enforcement

The skills use bash scripts to enforce proper workflow:

| Script | Purpose |
|--------|---------|
| `check-prerequisites.sh` | Validates phase prerequisites |
| `create-new-feature.sh` | Creates feature branch and directory |
| `setup-plan.sh` | Initializes plan phase artifacts |
| `update-agent-context.sh` | Updates CLAUDE.md with tech stack |
| `common.sh` | Shared utility functions |

### Prerequisite Checking

Skills automatically validate prerequisites. If you try to run `/speckit-plan` without a specification:

```
BLOCKED: Missing prerequisite
- Required: specs/NNN-feature-name/spec.md
- Run /speckit-specify first
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
| Commands | `/speckit.constitution` | `/speckit-constitution` |
| Prerequisites | Bash scripts | Same bash scripts |
| Workflow enforcement | Identical | Identical |
| Phase separation | Identical | Identical |
| Output artifacts | Identical | Identical |

**Robustness:** Both implementations share the same bash scripts for workflow enforcement, providing identical protection against:
- Out-of-order phase execution
- Missing prerequisites
- Branch validation
- Empty/invalid inputs

## Troubleshooting

### "Command not found" for skills

Ensure skills are in the correct location:
```bash
ls -la .claude/skills/speckit-*/SKILL.md
```

### Scripts not executable

```bash
chmod +x .specify/scripts/bash/*.sh
```

### Prerequisites failing

Check the current feature context:
```bash
.specify/scripts/bash/check-prerequisites.sh --json
```

### Constitution has tech stack

If your constitution contains technology choices (languages, frameworks, databases), this violates phase separation. Tech stack belongs ONLY in `/speckit-plan`. Re-run `/speckit-constitution` to fix.

## Example: Task Management CLI

Here's a complete workflow example:

```bash
# 1. Initialize governance
/speckit-constitution
# Answer questions about project principles

# 2. Create feature specification
/speckit-specify Build a CLI task manager that lets users add tasks with
title and description, list all tasks, and mark tasks as complete.
Use SQLite for storage.

# 3. Clarify requirements (optional but recommended)
/speckit-clarify

# 4. Create technical plan
/speckit-plan

# 5. Generate quality checklists
/speckit-checklist

# 6. Generate task breakdown
/speckit-tasks

# 7. Validate consistency
/speckit-analyze

# 8. Implement (requires 100% checklist completion)
/speckit-implement

# 9. Export to GitHub Issues (optional)
/speckit-taskstoissues
```

## Upstream Relationship

This project tracks the upstream [GitHub Spec-Kit](https://github.com/github/spec-kit). See the `upstream/` directory for:

| Document | Purpose |
|----------|---------|
| [MIGRATION-ANALYSIS.md](upstream/MIGRATION-ANALYSIS.md) | How vanilla spec-kit was analyzed and converted |
| [TEST-REPORT.md](upstream/TEST-REPORT.md) | Comparison test results (happy path + adversarial) |
| [TEST-GUIDE.md](upstream/TEST-GUIDE.md) | How to run your own comparison tests |

**Current Version**: Based on Spec-Kit Template v0.0.90

## Contributing

This is a community implementation of Spec-Kit for Claude Code. For the official Spec-Kit, see [github/spec-kit](https://github.com/github/spec-kit).

## License

MIT License - See [LICENSE](LICENSE) for details.
