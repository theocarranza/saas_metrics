---
description: Enforce Conventional Commits and Atomicity on Staged Changes
---

# Atomic Commit Workflow

Triggers: `/commit`, `/ship it`

## Prerequisites

Follow the @.agent/rules/git-style-guide.md
Ensure you have staged changes before running this workflow:

```bash
git add <files>
```

## Steps

### 1. Analyze Staged Changes

Run `git diff --cached` and evaluate:

1. **Documentation Check**:
   - 🛑 **STOP** if `CHANGELOG.md` is not modified. (Mandatory for ALL commits).
   - ⚠️ **Check** if `README.md` needs updates (for feature/arch changes).
2. **Atomicity Check**: Are we touching unrelated concerns (UI + DB + Logic) in one commit?
   - ⚠️ If YES → split into multiple commits.
3. **Determine Type**: `feat`, `fix`, `chore`, `refactor`, `style`, `test`, `docs`, `perf`, `ci`, `build`.
4. **Determine Scope**: e.g., `(auth)`, `(ui)`, `(router)`, `(guards)`.
5. **Draft Message** in Conventional Commit format:

   ```
   <type>(<scope>): <subject in imperative mood>

   - Why bullet point 1
   - Why bullet point 2
   ```

### 2. Present Draft for Confirmation

Prompt the user:
> "I have drafted the following commit message. Approve, edit, or cancel:"

Display the formatted commit message and await user input.

### 3. Execute Commit

Run the commit with the approved message:

```bash
// turbo
git commit -m "<type>(<scope>): <subject>" -m "<body>"
```

### 4. Inform the user of the task completion

```
