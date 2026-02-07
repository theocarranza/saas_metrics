---
description: rigorous flow for fixing bugs with reproduction tests
---

name: TDD Bug Fix
description: rigorous flow for fixing bugs with reproduction tests
triggers:
  - manual: "fix bug"
  - manual: "resolve issue"

steps:
  - id: analyze_context
    name: "Analyze & Plan"
    action:
      type: "llm"
      instruction: "Review the current file context and the error report. Identify the root cause. Do NOT write the fix yet."

  - id: create_repro_test
    name: "Create Reproduction Test"
    action:
      type: "llm"
      instruction: "Create a new test file in `test/` that reproduces the bug. The test MUST fail initially."
    validation:
      command: "flutter test"
      expect_failure: true  # We expect this to fail (Red phase)

  - id: implement_fix
    name: "Implement Fix"
    action:
      type: "llm"
      instruction: "Modify the `lib/` code to handle the edge case/null pointer."

  - id: verify_fix
    name: "Verify Fix"
    action:
      type: "terminal"
      command: "flutter test"
    validation:
      expect_success: true # Now it must pass (Green phase)

  - id: lint_check
    name: "Final Polish"
    action:
      type: "terminal"
      command: "dart analyze ."