# Upstream: Vanilla Spec-Kit Relationship

This directory documents the relationship between Spec-Kit Skills and the upstream [GitHub Spec-Kit](https://github.com/github/spec-kit) project.

## Contents

| File | Purpose |
|------|---------|
| `MIGRATION-ANALYSIS.md` | Analysis of vanilla spec-kit structure and migration strategy |
| `TEST-REPORT.md` | Comparison test results (happy path + adversarial) |
| `TEST-GUIDE.md` | How to run your own comparison tests |

## Upstream Version Tracking

| Spec-Kit Skills Version | Based on Spec-Kit Version | Date |
|------------------------|---------------------------|------|
| 1.0.0 | v0.0.90 | 2026-01-27 |

## Migration Strategy

When a new version of vanilla spec-kit is released:

1. **Diff analysis**: Compare new version against `MIGRATION-ANALYSIS.md`
2. **Identify changes**: New commands, modified templates, changed behavior
3. **Update skills**: Apply changes to `.claude/skills/speckit-*/`
4. **Update scripts**: Apply changes to `.specify/scripts/bash/`
5. **Test**: Run comparison tests per `TEST-GUIDE.md`
6. **Document**: Update `TEST-REPORT.md` with new results

## Future: Automatic Migration

This directory will house tooling for automatic migration when new spec-kit versions are released:

```
upstream/
  MIGRATION-ANALYSIS.md    # Current analysis
  TEST-REPORT.md           # Test results
  TEST-GUIDE.md            # Testing instructions
  README.md                # This file

  # Future additions:
  migrate.sh               # Auto-migration script
  version-history/         # Historical version analyses
  diff-reports/            # Version-to-version diffs
```

## Links

- **Upstream**: https://github.com/github/spec-kit
- **Spec-Kit CLI**: `uv tool install specify-cli`
- **Template Version**: Spec Kit Template v0.0.90
