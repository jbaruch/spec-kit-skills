---
name: speckit-specify
description: Create feature specification from natural language description
---

# Spec-Kit Specify

Create or update a feature specification from a natural language feature description.

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
   WARNING: Project constitution not found at .specify/memory/constitution.md

   Proceeding without constitution. Consider running /speckit-constitution first.
   ```

3. If exists, parse all principles, constraints, and governance rules.

## Execution Flow

The text the user typed after `/speckit-specify` **is** the feature description.

### 1. Generate Branch Name

Analyze the feature description and create a 2-4 word short name:
- Use action-noun format when possible (e.g., "user-auth", "fix-payment-timeout")
- Preserve technical terms and acronyms (OAuth2, API, JWT, etc.)
- Keep it concise but descriptive

Examples:
- "I want to add user authentication" -> "user-auth"
- "Implement OAuth2 integration for the API" -> "oauth2-api-integration"
- "Create a dashboard for analytics" -> "analytics-dashboard"

### 2. Create Feature Branch and Directory

Run the feature creation script:
```bash
.specify/scripts/bash/create-new-feature.sh --json "$ARGUMENTS" --short-name "your-short-name"
```

Parse the JSON output for `BRANCH_NAME`, `SPEC_FILE`, and `FEATURE_NUM`.

**IMPORTANT**: Only run this script ONCE per feature. The JSON output contains the paths you need.

### 3. Load Spec Template

Read `.specify/templates/spec-template.md` to understand required sections.

### 4. Generate Specification

Follow this execution flow:

1. Parse user description from Input
   - If empty: ERROR "No feature description provided"

2. Extract key concepts from description
   - Identify: actors, actions, data, constraints

3. For unclear aspects:
   - Make informed guesses based on context and industry standards
   - Only mark with `[NEEDS CLARIFICATION: specific question]` if:
     - The choice significantly impacts feature scope or user experience
     - Multiple reasonable interpretations exist with different implications
     - No reasonable default exists
   - **LIMIT: Maximum 3 [NEEDS CLARIFICATION] markers total**
   - Prioritize clarifications by impact: scope > security/privacy > user experience > technical details

4. Fill User Scenarios & Testing section
   - Each user story must be INDEPENDENTLY TESTABLE
   - Assign priorities (P1, P2, P3) to each story

5. Generate Functional Requirements
   - Each requirement must be testable
   - Use reasonable defaults for unspecified details

6. Define Success Criteria
   - Create measurable, technology-agnostic outcomes
   - Include quantitative and qualitative measures

7. Identify Key Entities (if data involved)

### 5. Write Specification

Write to `SPEC_FILE` using the template structure.

### 6. Create Spec Quality Checklist

Generate a checklist file at `FEATURE_DIR/checklists/requirements.md`:

```markdown
# Specification Quality Checklist: [FEATURE NAME]

**Purpose**: Validate specification completeness and quality before planning
**Created**: [DATE]
**Feature**: [Link to spec.md]

## Content Quality

- [ ] No implementation details (languages, frameworks, APIs)
- [ ] Focused on user value and business needs
- [ ] Written for non-technical stakeholders
- [ ] All mandatory sections completed

## Requirement Completeness

- [ ] No [NEEDS CLARIFICATION] markers remain
- [ ] Requirements are testable and unambiguous
- [ ] Success criteria are measurable
- [ ] Success criteria are technology-agnostic
- [ ] All acceptance scenarios are defined
- [ ] Edge cases are identified
- [ ] Scope is clearly bounded
- [ ] Dependencies and assumptions identified

## Feature Readiness

- [ ] All functional requirements have clear acceptance criteria
- [ ] User scenarios cover primary flows
- [ ] Feature meets measurable outcomes defined in Success Criteria
- [ ] No implementation details leak into specification

## Notes

- Items marked incomplete require spec updates before `/speckit-clarify` or `/speckit-plan`
```

### 7. Handle Clarifications

If `[NEEDS CLARIFICATION]` markers remain (max 3):

Present each question in this format:

```markdown
## Question [N]: [Topic]

**Context**: [Quote relevant spec section]

**What we need to know**: [Specific question]

**Suggested Answers**:

| Option | Answer | Implications |
|--------|--------|--------------|
| A      | [First answer] | [Impact] |
| B      | [Second answer] | [Impact] |
| C      | [Third answer] | [Impact] |
| Custom | Provide your own | [Instructions] |

**Your choice**: _[Wait for user response]_
```

### 8. Report Completion

Output:
- Branch name
- Spec file path
- Checklist results
- Readiness for next phase (`/speckit-clarify` or `/speckit-plan`)

## Guidelines

### Quick Guidelines

- Focus on **WHAT** users need and **WHY**
- Avoid HOW to implement (no tech stack, APIs, code structure)
- Written for business stakeholders, not developers

### Success Criteria Guidelines

Success criteria must be:
1. **Measurable**: Include specific metrics
2. **Technology-agnostic**: No frameworks, languages, databases
3. **User-focused**: Describe outcomes from user/business perspective
4. **Verifiable**: Can be tested without knowing implementation

**Good examples**:
- "Users can complete checkout in under 3 minutes"
- "System supports 10,000 concurrent users"
- "95% of searches return results in under 1 second"

**Bad examples**:
- "API response time is under 200ms" (too technical)
- "Database can handle 1000 TPS" (implementation detail)

## Next Steps

After completing the specification:

1. **Recommended**: Run `/speckit-clarify` to resolve ambiguities
   - Identifies underspecified areas you may have missed
   - Asks targeted questions (max 5) to improve spec quality
   - Especially valuable for complex features

2. **Required**: Run `/speckit-plan` to create the technical implementation plan

Suggest to user:
```
Specification complete! Next steps:
- /speckit-clarify - (Recommended) Resolve any ambiguities and improve spec quality
- /speckit-plan - Create technical implementation plan
```
