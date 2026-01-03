---
description: Standard feature development workflow from ticket to PR
---

# Feature Development Cycle

This workflow outlines the standard process for developing a feature, using MCP tools for GitHub interactions.

## 0. Verify GitHub Connectivity
- **Action**: Ensure the GitHub MCP server is active and authenticated before determining the issue context.
- **Tool**: `mcp_github_list_issues`
- **Logic**:
  - Call `mcp_github_list_issues` (limit 1).
  - **Success**: Proceed to Step 1.
  - **Failure**: Notify the user immediately: "GitHub Authentication failed. Please authenticate the GitHub MCP server."

## 1. Branch Creation & Assignment
- **Action 1**: Create a new branch for the current changes.
- **Naming Convention**: `feat/[ISSUE_ID]-description-of-feature`
- **Action 2**: Assign the GitHub issue to the active developer (yourself or specific user).
- **Tool**: `mcp_github_update_issue` (assignees)`

## 2. Context Switch
- **Action**: Ensure you are on the newly created branch.

## 2.1. Planning Phase (MANDATORY)
- **Constraint**: You MUST read and adhere to `.agent/rules/clean-architecture.md` (Clean Architecture & Feature-First Structure).
- **Artifacts**:
  - `implementation_plan.md`: Detailed technical plan (Proposed Changes, Verification Plan).
    - **Requirement**: The structure of changes MUST follow `lib/features/<feature>/` with `domain`, `data`, `presentation`.
  - `task.md`: Granular checklist of steps.
- **Action**:
  - Create/Update these artifacts.
  - **Tool**: `notify_user`
  - **Message**: "Plan and Task List created. Please review `implementation_plan.md` and `task.md` based on Clean Architecture rules."
  - **Constraint**: **DO NOT** proceed to Step 3 (Code) until the user explicitly approves the plan.
  - If user requests changes: Update artifacts and request review again.

## 3. Code Quality Pipeline
- **Step 3.1: Linting**
  - **Action**: Run project linters (\`flutter analyze\`).
  - **Action**: Run custom linters if applicable.

- **Step 3.2: Testing**
  - **Action**: Run unit and widget tests (\`flutter test\`).

- **Step 3.3: Atomic Commit & Push**
  - **Prerequisite**: All checks in 3.1 and 3.2 must pass.
  - **Action**: detailed in \`atomic-commit.md\`.
  - **Trigger**: Run the atomic commit workflow.
  - **Push**: Push the branch to origin.

## 4. Pull Request (PR)
- **Action**: Open a Pull Request targeting \`develop\`.
- **Tool**: `mcp_github_create_pull_request`
- **Parameters**:
  - `owner`: [Repository Owner]
  - `repo`: [Repository Name]
  - `title`: "feat: [description] (#[ISSUE_ID])"
  - `body`: "Closes #[ISSUE_ID]. Implementation details..."
  - `head`: "feat/[ISSUE_ID]-[description]"
  - `base`: "develop"

## 5. Self-Review
- **Action**: The agent (you) must review the PR.
- **Steps**:
  - Read the files changed in the PR.
  - **Tool**: `mcp_github_create_pull_request_review`
  - **Parameters**:
    - `pull_number`: [PR Number from Step 4]
    - `event`: "COMMENT"
    - `body`: "Self-review: [observations...]"

## 6. Feedback Loop (MANDATORY)
- **Action**: Check for comments and status.
- **Tools**:
  - `mcp_github_get_pull_request_comments` (Fetch comments)
  - `mcp_github_get_pull_request_reviews` (Check human reviews)
  - `mcp_github_get_pull_request_status` (Check CI status)
- **Resolution**:
  - **CRITICAL**: If *any* comments exist (from humans or bots), you MUST read them.
  - If comments request changes:
    1. Implement fixes.
    2. Recurse to **Step 3** (Lint -> Test -> Commit -> Push).
    3. Reply to comments confirming fix.
    4. **Resolve conversation** (Mark as resolved in GitHub).
    5. Recurse to **Step 6** (Re-verify).
  - If no comments or all resolved: Proceed to Step 7.

## 7. Merge (BLOCKED ON USER)
- **Condition**:
  - No outstanding negative comments.
  - **All comment threads are RESOLVED**.
  - Tests pass.
  - **MANDATORY**: User has given EXPLICIT permission to merge in the current turn.
- **Action**:
  - If user has NOT explicitly said "merge" in the current turn:
    - **STOP**.
    - **Tool**: `notify_user`
    - **Message**: "PR is ready. Checks passed. Reviews addressed. Permission to merge?"
  - If user GIVES permission:
    - **Tool**: `mcp_github_merge_pull_request`
    - **Parameters**:
      - `pull_number`: [PR Number]
      - `merge_method`: "merge"

## 8. Cleanup & Verification
- **Action 1**: Switch back to the integration branch and pull latest changes.
- **Command**:
  ```bash
  git checkout develop && git pull
  ```
- **Action 2**: Verify the Issue is **CLOSED** and has correct **ASSIGNEES**.
- **Tool**: `mcp_github_get_issue`
- **Logic**:
  - If state is `open`: Close it manually and comment with the merge commit hash.
  - If assignee is missing: Assign the correct user.