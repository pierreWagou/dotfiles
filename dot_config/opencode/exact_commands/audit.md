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

- **AGENTS.md** (if present): Verify the project rules, conventions, and architecture description all match reality. Update any stale references.
- **Skills** (`.opencode/skills/` in the project, or `~/.config/opencode/skills/` globally, `~/.config/opencode/wagou/skills/` for the wagou profile, `~/.config/opencode/alan/skills/` for the alan profile): For each skill, verify that the instructions, file paths, run commands, and conventions described still match the actual code. Update or remove anything outdated.
- **README and other docs**: Cross-check documentation pages against the implementation. Flag any sections that describe features differently from how they are actually built.

## 5. Project Artifacts

Review and fix artifacts that revolve around the codebase to ensure they stay in sync:

- **API collections** (Bruno, Postman, etc.): Check all request files match current endpoints — correct URLs, HTTP methods, field names, query params, and body structure. Identify endpoints missing from the collection and create them.
- **Docker / deployment configs**: Verify Dockerfile, docker-compose.yml, and deployment manifests reference correct files, ports, env vars, and commands.
- **CI/CD workflows**: Ensure all workflow steps use commands and scripts that still exist.
- **Database migrations**: Verify the migration journal matches the SQL files on disk, and that the latest migration reflects the current schema.

## Output

For each issue found:
1. State the file and line
2. Explain the problem
3. Fix it directly -- do not just report, actually make the change

After all fixes, run the project's lint/check command to validate nothing is broken.
