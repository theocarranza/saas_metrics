---
trigger: model_decision
---

# Rules to follow when writing code

## The functional paradigm

1. Always write functional code
2. All functions must be pure, indepondent
3. Functions must return, exceptions must be well justified and documented with a comment
4. Avoid declaring variables when a function can be used instead
5. When a function is doing more than one thing, consider refactoring
6. If a function can fail, handling the failure is mandatory
7. If it can be done with less code, do with less code
8. Do use functions as arguments
9. Do use pattern matching to handle branching
10. Don't use if/else blocks unless the evaluation is resolved with a single block
11. Don't use else/elseif
12. DO use switch expressions and prefer it over statements

## General rules
1. Code must be efficient first, readable next, and orthodox last
2. Code must be it's own documentation
3. Code should be short, objective, and rigorous
4. Code that is not testable is not deployable
5. Code must be as clear as algebra

## Dart, Flutter
1. Read and memoryze the Effective Dart: <https://dart.dev/effective-dart>
2. Widgets are pure containers, they present
3. Logic goes into controllers, helper classes, or functions
4. If the widget is past 100 lines, refactor it. 
5. Avoid Stateful Widgets, Value notifiers, Change notifiers, and the like
