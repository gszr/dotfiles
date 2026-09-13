# Global Coding Rules

## Code Style

- Follow DRY, KISS, and YAGNI principles
- Write simple single-purpose functions - no multi-mode behavior, no flag parameters that switch logic. If the user needs multiple modes, they will ask explicitly

## Libraries and Dependencies

- Use modern stable, project-compatible package management, libraries, and language standards; prefer vendor-recommended patterns such as ESM when supported
- Install dependencies in project environments, not globally
- Add or update dependencies in project config files, not as one-off manual installs
- If a dependency is installed locally, read its source code when needed instead of guessing, even if it is gitignored

## Testing

- Respect the repository test strategy and add only the minimum useful tests for the requested change
- Prefer smoke, integration, and end-to-end tests over narrow unit or regression tests; do not test static text, prompts, or config unless behavior depends on them
- Do not create fake/mock-based tests by default; use real integrations when practical, even if they cost a little money
- UI tests and automations must use stable IDs, test IDs, or accessibility IDs instead of visible text, and fail fast without fallback clicks

## Workflow

- Keep changes minimal and tightly scoped to the current request: make the
  smallest useful diff, change only the lines needed to solve the problem, and
  avoid unrelated improvements unless the user asks for them
- Match the existing style of the repository even if it differs
  from my personal preference; new code must look like it was
  written by the same author
- Keep files small and cohesive; split by feature or responsibility 
  when the project has no established structure
- Do not revert unrelated changes
- If you are unsure, inspect the codebase instead of inventing
  patterns
- When project instructions include test or lint commands, run
  them before finishing if the task changed code

## Documentation

- Code is documentation - use clear naming, types, and docstrings

## Git operations

- Only commit when asked
- Use Conventional Commits
- Always add yourself as coauthor
- When asked to commit and open a PR, use PR template

## Testing

- Do not add tests that only prove a dependency works, such as inserting a row
  and immediately selecting it back, or checking that a SQL scan maps columns
  when no behavior or failure mode is being protected.
- Every new test must protect a specific behavior, bug, contract, or regression.
  If the test would still pass after deleting the production logic it claims to
  cover, it is not useful.
- Prefer tests at the boundary where behavior can break: handler lifecycle,
  writer persistence, parser normalization, authorization, accounting math, and
  user-visible API responses.
- Before adding a test, state the regression it would catch. If that sentence is
  vague, do not add the test.
