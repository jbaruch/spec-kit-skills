---
name: speckit-core
description: Initialize spec-kit project, check status, and display workflow help
---

# Spec-Kit Core

Core skill providing project initialization, status checking, and workflow help.

## User Input

```text
$ARGUMENTS
```

Parse the user input to determine which subcommand to execute.

## Subcommands

This skill supports three subcommands:

1. **init** - Initialize spec-kit in a new or existing project
2. **status** - Show current project and feature status
3. **help** - Display workflow phases and command reference

If no subcommand is provided, show help.

## Subcommand: init

Initialize spec-kit in the current directory.

### Execution Flow

1. **Check if already initialized**:
   ```bash
   test -d ".specify/memory" && echo "ALREADY_INITIALIZED"
   ```

2. **Create directory structure**:
   ```bash
   mkdir -p .specify/memory
   mkdir -p specs
   ```

3. **Initialize Git (if needed)**:
   ```bash
   .claude/skills/speckit-core/scripts/bash/init-project.sh --json
   ```

4. **Report**:
   ```
   Spec-Kit initialized!

   Directory structure created:
   - .specify/memory/    (project artifacts)
   - specs/              (feature specifications)

   Next step: /speckit-00-constitution
   ```

### If Already Initialized

```
Spec-Kit is already initialized in this project.

Current status:
- Constitution: [exists/missing]
- Features: X feature directories in specs/

Run /speckit-core status for detailed status.
```

## Subcommand: status

Show the current project and feature status.

### Execution Flow

1. **Get paths and status**:
   ```bash
   .claude/skills/speckit-core/scripts/bash/check-prerequisites.sh --json --paths-only
   ```

2. **Check constitution**:
   ```bash
   test -f ".specify/memory/constitution.md" && echo "CONSTITUTION_EXISTS"
   ```

3. **List features**:
   ```bash
   ls -d specs/[0-9][0-9][0-9]-*/ 2>/dev/null | wc -l
   ```

4. **For current feature, check artifacts**:
   - spec.md
   - plan.md
   - tasks.md
   - checklists/
   - tests/test-specs.md

5. **Report**:
   ```
   ╭─────────────────────────────────────────────╮
   │  SPEC-KIT STATUS                            │
   ├─────────────────────────────────────────────┤
   │  Project:        [project name]             │
   │  Constitution:   [exists/missing]      [✓/✗]│
   │  Features:       X total                    │
   │                                             │
   │  Current Feature: [NNN-feature-name]        │
   │  ─────────────────────────────────────────  │
   │  spec.md:        [exists/missing]      [✓/✗]│
   │  plan.md:        [exists/missing]      [✓/✗]│
   │  tasks.md:       [exists/missing]      [✓/✗]│
   │  checklists/:    [X files]                  │
   │  test-specs.md:  [exists/missing]      [✓/✗]│
   ├─────────────────────────────────────────────┤
   │  Next Step: [recommended command]           │
   ╰─────────────────────────────────────────────╯
   ```

### Next Step Logic

Determine the recommended next step based on what's missing:

1. No constitution → `/speckit-00-constitution`
2. No feature → `/speckit-01-specify <description>`
3. Has spec, no plan → `/speckit-03-plan`
4. Has plan, no tasks → `/speckit-06-tasks`
5. Has tasks → `/speckit-08-implement`

## Subcommand: help

Display the complete workflow reference.

### Output

```
╭─────────────────────────────────────────────────────────────────────╮
│  SPEC-KIT WORKFLOW                                                  │
├─────────────────────────────────────────────────────────────────────┤
│                                                                     │
│  Phase 0: Foundation                                                │
│  ─────────────────────                                              │
│  /speckit-core init      Initialize spec-kit in a project          │
│  /speckit-00-constitution Define project governance principles      │
│                                                                     │
│  Phase 1: Specification                                             │
│  ──────────────────────                                             │
│  /speckit-01-specify     Create feature spec from description       │
│  /speckit-02-clarify     Resolve ambiguities (max 5 questions)      │
│                                                                     │
│  Phase 2: Planning                                                  │
│  ────────────────                                                   │
│  /speckit-03-plan        Create technical implementation plan       │
│  /speckit-04-checklist   Generate quality checklists                │
│                                                                     │
│  Phase 3: Testing (Optional unless constitutionally required)       │
│  ───────────────────────────────────────────────────────────        │
│  /speckit-05-testify     Generate test specifications (TDD)         │
│                                                                     │
│  Phase 4: Task Breakdown                                            │
│  ───────────────────────                                            │
│  /speckit-06-tasks       Generate task breakdown                    │
│  /speckit-07-analyze     Validate cross-artifact consistency        │
│                                                                     │
│  Phase 5: Implementation                                            │
│  ───────────────────────                                            │
│  /speckit-08-implement   Execute implementation                     │
│  /speckit-09-taskstoissues Export tasks to GitHub Issues            │
│                                                                     │
│  Utility Commands                                                   │
│  ────────────────                                                   │
│  /speckit-core status    Show project/feature status                │
│  /speckit-core help      Display this help                          │
│                                                                     │
├─────────────────────────────────────────────────────────────────────┤
│  TIP: Each command validates its prerequisites automatically.       │
│       Run /speckit-core status to see your current progress.        │
╰─────────────────────────────────────────────────────────────────────╯
```

## Default (No Subcommand)

If user runs `/speckit-core` without arguments, show the help output.

## Error Handling

| Condition | Response |
|-----------|----------|
| Unknown subcommand | Show help with error message |
| Not in a project directory | Suggest running `init` |
| Git not available | Warning but continue (scripts handle this) |
