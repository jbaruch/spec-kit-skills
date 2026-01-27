# Spec-Kit Skills Development Guide

**Last updated**: 2025-01-27

## Overview

This project contains a Claude Code skills bundle that replicates GitHub Spec-Kit functionality using the Claude skills format.

## Spec-Kit Workflow

This project uses specification-driven development. The phases are:

1. `/speckit-00-constitution` - Define project governance principles
2. `/speckit-01-specify` - Create feature specification from natural language
3. `/speckit-02-clarify` - Resolve ambiguities (max 5 questions)
4. `/speckit-03-plan` - Create technical implementation plan
5. `/speckit-04-checklist` - Generate domain-specific quality checklists
6. `/speckit-05-tasks` - Generate task breakdown
7. `/speckit-06-analyze` - Validate cross-artifact consistency
8. `/speckit-07-implement` - Execute implementation
9. `/speckit-05-taskstoissues` - Export tasks to GitHub Issues

**Never skip phases.** Each `/speckit-*` command validates its prerequisites.

Read `.specify/memory/constitution.md` for this project's governing principles.

## Project Structure

```text
.claude/
  skills/
    speckit-00-constitution/   # Governance principles skill
    speckit-01-specify/        # Feature specification skill
    speckit-02-clarify/        # Clarification skill
    speckit-03-plan/           # Technical planning skill
    speckit-04-checklist/      # Quality checklist skill
    speckit-05-tasks/          # Task generation skill
    speckit-06-analyze/        # Consistency analysis skill
    speckit-07-implement/      # Implementation execution skill
    speckit-08-taskstoissues/  # GitHub Issues export skill

.specify/
  memory/
    constitution.md         # Project constitution (created by /speckit-00-constitution)
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
| Constitution | `/speckit-00-constitution` | Create project governance principles |
| Specify | `/speckit-01-specify` | Create feature spec from description |
| Clarify | `/speckit-02-clarify` | Resolve spec ambiguities |
| Plan | `/speckit-03-plan` | Create technical implementation plan |
| Checklist | `/speckit-04-checklist` | Generate quality checklists |
| Tasks | `/speckit-05-tasks` | Generate task breakdown |
| Analyze | `/speckit-06-analyze` | Validate cross-artifact consistency |
| Implement | `/speckit-07-implement` | Execute implementation |
| Tasks to Issues | `/speckit-05-taskstoissues` | Export tasks to GitHub Issues |

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
<!-- Tech stack will be inserted here by /speckit-03-plan -->
<!-- SPEC-KIT-TECH-END -->
