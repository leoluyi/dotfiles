## Skill routing

A request matching an available skill → invoke it via the Skill tool as the first action,
before answering and before any other tool.

Two skill names collide here; pick this one:

- Report bugs conversationally, file them as issues, "QA session" → `qa`
  (`diagnose` is for root-causing a bug already reported)
- Review a diff, branch, or PR → `review`
  (`code-review` is a near-duplicate copy of it)
