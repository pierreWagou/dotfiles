---
description: Review codebase for dead code, inconsistencies, bad patterns, and stale docs
agent: plan
---

Perform a thorough review of the entire codebase. Work methodically through each area below.

## 1. Dead Code & Unused Artifacts

- Find unused imports, variables, functions, classes, and modules across the project
- Identify models or components that are defined but never referenced downstream
- Look for orphaned test files, config entries, or scripts that no longer serve a purpose
- Check for commented-out code blocks that should be removed
- Flag any dependencies that are declared but no longer imported anywhere

## 2. Inconsistencies

- Naming conventions: check for mixed styles (snake_case vs camelCase, singular vs plural, prefix mismatches)
- Code style: verify consistent formatting across the project
- Configuration drift: compare what is declared in config files vs what actually exists on disk
- Schema or type definitions: ensure they match the actual data structures in use

## 3. Bad Patterns & Anti-Patterns

- Hardcoded values that should be configurable (paths, thresholds, magic numbers)
- Repeated logic that should be extracted into shared utilities or functions
- Overly broad exception handling or missing error handling
- Test coverage gaps: logic paths without corresponding tests

## 4. Documentation Freshness

Review and fix these documentation artifacts to ensure they accurately reflect the current codebase:

- **AGENTS.md**: Verify the project structure, tech stack, and instructions all match reality. Update any stale references.
- **Skills** (`dot_config/opencode/skills/` in source, `~/.config/opencode/skills/` on target): For each skill, verify that the instructions, file paths, run commands, and conventions described still match the actual code. Update or remove anything outdated.
- **Other docs**: Cross-check documentation pages against the implementation. Flag any sections that describe features differently from how they are actually built.

## Output

For each issue found:
1. State the file and line
2. Explain the problem
3. Fix it directly -- do not just report, actually make the change

After all fixes, run the project's lint/check command to validate nothing is broken.
