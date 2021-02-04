+++
title = "GitHub and GitLab commands cheatsheet"
published = "16 December 2020"
tags = ["shortcut", "git"]
rss = "A cheatsheet for commands like 'Fix #2334'."
+++

Both GitHub and GitLab provide shortcuts for interacting with the layers they have built on top of Git.
These shortcuts are a convenient and clean way to interact with things like issues and PRs.
For instance, using `Fixes #2334` in a commit message will close issue #2334 automatically when the commit is applied to the main branch.
However, the layers on top of Git differ between the two, and therefore the commands will differ as well.
This document is a cheatsheet for issue closing commands; I plan to add more of these commands over time.

*If this page contains outdated information, suggest a fix via [GitHub](https://github.com/rikhuijzer/huijzer.xyz).*

\toc 

## Close an issue via a pull request title or commit message

### GitHub
On GitHub use
([docs](https://docs.github.com/en/free-pro-team@latest/github/managing-your-work-on-github/linking-a-pull-request-to-an-issue#linking-a-pull-request-to-an-issue-using-a-keyword)):

- close
- closes
- closed
- fix
- fixes
- fixed
- resolve
- resolves
- resolved

**Examples**

```c
Fix #2334
Fix octo-org/octo-repo#2334
Fix #2334, fix octo-org/octo-repo#2334
```

\
### GitLab
On GitLab use 
([docs](https://docs.gitlab.com/ee/user/project/issues/managing_issues.html#closing-issues)):

- Close, Closes, Closed, Closing, close, closes, closed, closing 
- Fix, Fixes, Fixed, Fixing, fix, fixes, fixed, fixing 
- Resolve, Resolves, Resolved, Resolving, resolve, resolves, resolved, resolving 
- Implement, Implements, Implemented, Implementing, implement, implements, implemented, implementing 

**Examples**

```c
Fixes #2334
Closes #2334
Closes #4, #6
Closes group/project#123
```
