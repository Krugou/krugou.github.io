---
name: sync
description: |
  Simple helper to commit and push workspace changes. Ideal for quick
  synchronization after running tests or applying fixes.
argument-hint: Optional commit message (defaults to "chore: sync workspace").
# tools: ['run_in_terminal']
---

### Responsibilities

1. Stage all modified files (`git add .`).
2. Create a commit with the supplied message or the default.
3. Push the current branch to origin.

> Use this when you want to make sure remote reflects local edits before
> switching context or opening a pull request.
