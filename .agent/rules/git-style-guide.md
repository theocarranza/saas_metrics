---
trigger: always_on
---

# GIT STYLE GUIDE

## Branches

1. **NEVER** commit directly to `main` or `develop`.
2. **ALWAYS** create feature/fix branches from `develop` (e.g., `feat/my-feature`, `fix/issue-123`).
3. **ALWAYS** use Pull Requests to merge changes into `develop` or `main`.

## Commits

1. **DO** follow The Conventional Commits specification.
2. **DO** use one of "feat", "fix", "chore", "refactor" for the commit type.
3. **DO** use scope when necessary: `<type>[optional scope]: <description>`.
4. **DO** write longer descriptive text in the optional body for complex changes.
5. **DO** write atomic commits (one logical change per commit).
6. **DO** write short, efficient commit messages (under 50 chars for subject).

## Documentation Requirements

1. **ALWAYS** update `CHANGELOG.md` with every commit (under `[Unreleased]` section).
2. **ALWAYS** update `README.md` if the commit changes usage, features, or architecture.
