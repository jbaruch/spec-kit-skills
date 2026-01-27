# Spec-Kit Skills Development Guide

**Last updated**: 2025-01-27

## Overview

This project contains a Claude Code skills bundle that replicates GitHub Spec-Kit functionality using the Claude skills format.

## Spec-Kit Workflow

This project uses specification-driven development. The phases are:

1. `/speckit-constitution` - Define project governance principles
2. `/speckit-specify` - Create feature specification from natural language
3. `/speckit-clarify` - Resolve ambiguities (max 5 questions)
4. `/speckit-plan` - Create technical implementation plan
5. `/speckit-checklist` - Generate domain-specific quality checklists
6. `/speckit-tasks` - Generate task breakdown
7. `/speckit-analyze` - Validate cross-artifact consistency
8. `/speckit-implement` - Execute implementation
9. `/speckit-taskstoissues` - Export tasks to GitHub Issues

**Never skip phases.** Each `/speckit-*` command validates its prerequisites.

Read `.specify/memory/constitution.md` for this project's governing principles.

## Project Structure

```text
.claude/
  skills/
    speckit-constitution/   # Governance principles skill
    speckit-specify/        # Feature specification skill
    speckit-clarify/        # Clarification skill
    speckit-plan/           # Technical planning skill
    speckit-checklist/      # Quality checklist skill
    speckit-tasks/          # Task generation skill
    speckit-analyze/        # Consistency analysis skill
    speckit-implement/      # Implementation execution skill
    speckit-taskstoissues/  # GitHub Issues export skill

.specify/
  memory/
    constitution.md         # Project constitution (created by /speckit-constitution)
  scripts/bash/
    common.sh               # Shared functions
    check-prerequisites.sh  # Validation script
    create-new-feature.sh   # Feature branch creation
    setup-plan.sh           # Plan initialization
    update-agent-context.sh # Agent file updates
  templates/
    spec-template.md        # Feature spec template
    plan-template.md        # Implementation plan template
    tasks-template.md       # Task list template
    checklist-template.md   # Checklist template
    agent-file-template.md  # Agent context file template

specs/                      # Feature specifications (created per feature)
  NNN-feature-name/
    spec.md                 # Feature specification
    plan.md                 # Implementation plan
    tasks.md                # Task breakdown
    research.md             # Research findings
    data-model.md           # Data model
    quickstart.md           # Quick start guide
    contracts/              # API contracts
    checklists/             # Quality checklists
```

## Commands

```bash
# Make scripts executable (if needed)
chmod +x .specify/scripts/bash/*.sh

# Check prerequisites for a feature
.specify/scripts/bash/check-prerequisites.sh --json

# Create a new feature
.specify/scripts/bash/create-new-feature.sh --json "Feature description"
```

## Skills Available

| Skill | Command | Description |
|-------|---------|-------------|
| Constitution | `/speckit-constitution` | Create project governance principles |
| Specify | `/speckit-specify` | Create feature spec from description |
| Clarify | `/speckit-clarify` | Resolve spec ambiguities |
| Plan | `/speckit-plan` | Create technical implementation plan |
| Checklist | `/speckit-checklist` | Generate quality checklists |
| Tasks | `/speckit-tasks` | Generate task breakdown |
| Analyze | `/speckit-analyze` | Validate cross-artifact consistency |
| Implement | `/speckit-implement` | Execute implementation |
| Tasks to Issues | `/speckit-taskstoissues` | Export tasks to GitHub Issues |

## Key Concepts

### Constitution

The constitution (`.specify/memory/constitution.md`) defines project governance principles. All skills load and validate against it. Critical gate skills (plan, analyze, implement) halt on violations.

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

<!-- SPEC-KIT-TECH-START -->
<!-- Tech stack will be inserted here by /speckit-plan -->
<!-- SPEC-KIT-TECH-END -->
