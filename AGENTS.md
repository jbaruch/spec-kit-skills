# Spec-Kit Skills Development Guide

**Last updated**: 2025-02-02

## Overview

This project contains an AI coding assistant skills bundle that replicates GitHub Spec-Kit functionality. Skills are compatible with multiple AI agents (Claude Code, Codex, Gemini, OpenCode).

## Spec-Kit Workflow

This project uses specification-driven development. The phases are:

1. `/speckit-00-constitution` - Define project governance principles
2. `/speckit-01-specify` - Create feature specification from natural language
3. `/speckit-02-clarify` - Resolve ambiguities (max 5 questions)
4. `/speckit-03-plan` - Create technical implementation plan
5. `/speckit-04-checklist` - Generate domain-specific quality checklists
6. `/speckit-05-testify` - Generate test specifications (TDD support, optional unless constitutionally required)
7. `/speckit-06-tasks` - Generate task breakdown
8. `/speckit-07-analyze` - Validate cross-artifact consistency
9. `/speckit-08-implement` - Execute implementation
10. `/speckit-09-taskstoissues` - Export tasks to GitHub Issues

**Never skip phases.** Each `/speckit-*` command validates its prerequisites.

Read `FRAMEWORK-PRINCIPLES.md` for this framework's development principles.

## Project Structure

```text
.claude/skills/              # Primary skills location (source of truth)
  speckit-core/              # Core skill with scripts and templates
    scripts/bash/            # Bash scripts for all skills
    scripts/powershell/      # PowerShell scripts for Windows
    templates/               # Framework templates (do not edit)
  speckit-00-constitution/   # Constitution skill
  speckit-01-specify/        # Specification skill
  ...                        # Other speckit-XX-* skills
.codex/skills/               # Symlink -> .claude/skills
.gemini/skills/              # Symlink -> .claude/skills
.opencode/skills/            # Symlink -> .claude/skills

.specify/
  memory/                    # Project-specific artifacts (created by skills)
    constitution.md          # Project constitution (created by /speckit-00-constitution)

specs/                       # Feature specifications (created per feature)
  NNN-feature-name/
    spec.md                  # Feature specification
    plan.md                  # Implementation plan
    tasks.md                 # Task breakdown
    research.md              # Research findings
    data-model.md            # Data model
    quickstart.md            # Quick start guide
    contracts/               # API contracts
    checklists/              # Quality checklists
    tests/                   # Test specifications (created by /speckit-05-testify)
      test-specs.md          # Generated test specifications
```

## Commands

```bash
# Make scripts executable (if needed)
chmod +x .claude/skills/speckit-core/scripts/bash/*.sh

# Check prerequisites for a feature
.claude/skills/speckit-core/scripts/bash/check-prerequisites.sh --json

# Create a new feature
.claude/skills/speckit-core/scripts/bash/create-new-feature.sh --json "Feature description"
```

## Skills Available

| Skill | Command | Description |
|-------|---------|-------------|
| Core | `/speckit-core` | Initialize project, check status, show help |
| Constitution | `/speckit-00-constitution` | Create project governance principles |
| Specify | `/speckit-01-specify` | Create feature spec from description |
| Clarify | `/speckit-02-clarify` | Resolve spec ambiguities |
| Plan | `/speckit-03-plan` | Create technical implementation plan |
| Checklist | `/speckit-04-checklist` | Generate quality checklists |
| Testify | `/speckit-05-testify` | Generate test specs (TDD support) |
| Tasks | `/speckit-06-tasks` | Generate task breakdown |
| Analyze | `/speckit-07-analyze` | Validate cross-artifact consistency |
| Implement | `/speckit-08-implement` | Execute implementation |
| Tasks to Issues | `/speckit-09-taskstoissues` | Export tasks to GitHub Issues |

## Key Concepts

### Constitution

The constitution (`.specify/memory/constitution.md`) is a **project artifact** created by `/speckit-00-constitution` when users adopt the framework. It defines project-specific governance principles. All skills load and validate against it. Critical gate skills (plan, analyze, implement) halt on violations.

**Note**: The framework's own development principles are in `FRAMEWORK-PRINCIPLES.md`.

### Self-Validating Skills

Each skill checks its own prerequisites. Users invoke the skill they want, get feedback if prerequisites are missing.

### File-Based State

The `.specify/context.json` file persists state between skill invocations:
- Current feature
- Available artifacts
- Clarification status
- Checklist completion

### Checklist Gating

Checklists are "unit tests for English" - they validate REQUIREMENTS quality, not implementation. The implement skill gates on checklist completion.

### TDD Support (Testify)

The `/speckit-05-testify` skill generates test specifications from requirements before implementation:

- **When mandatory**: If the constitution contains TDD requirements (e.g., "test-first MUST be used"), testify is required before implementation
- **When optional**: If no TDD requirements exist, testify can be skipped
- **What it produces**: A `tests/test-specs.md` file with acceptance, contract, and validation test specifications derived from spec.md, plan.md, and data-model.md

Test specifications serve as acceptance criteria for implementation. The implement skill warns against modifying test assertions to match buggy code.

### Cross-Agent Support

Skills are stored in `.claude/skills/` with symlinks for other agents:
- `.codex/skills/` → `.claude/skills/`
- `.gemini/skills/` → `.claude/skills/`
- `.opencode/skills/` → `.claude/skills/`

Instruction files: `CLAUDE.md` and `GEMINI.md` are symlinks to this file (`AGENTS.md`).

<!-- SPEC-KIT-TECH-START -->
<!-- Tech stack will be inserted here by /speckit-03-plan -->
<!-- SPEC-KIT-TECH-END -->

# Tessl Rules <!-- tessl-managed -->

@.tessl/RULES.md follow the [instructions](.tessl/RULES.md)
