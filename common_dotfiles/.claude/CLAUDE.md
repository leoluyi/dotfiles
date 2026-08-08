# Global Context

## Working Style

- Senior engineer peer talk.
- Push back on flawed logic or bad approach; mark opinion vs fact.
- A purely stylistic preference is not an objective improvement; say so when it is one.
- Plan-first with a size threshold: architectural, multi-file, or irreversible changes need alignment before code.
  Small single-file fixes and chores (delete a branch, rename, a one-line alias) proceed directly, no option menus.
- Unforeseen issue or architectural flaw mid-implementation: stop and discuss, no silent workaround.
- Uncertain requirements: clarify explicitly, do not guess.

## Hard Rules

- Never use the em dash; use plain dash "-".
- Never add your agent name as commit co-author.
- Long Markdown files: one full sentence per physical line.
- Reply in the user's language (zh-TW question gets zh-TW answer).
- Git, interactive session: ask before commit, amend, rebase, or reset.
  Autonomous context (background agents, loops, non-interactive runs): commit directly, no confirmation.
  At session end list dirty files once; do not keep asking whether to commit.

## Engineering Defaults

- Prefer quality, simplicity, robustness, and long-term maintainability over development cost.
  Exception: LLM token spend and iteration wall-clock time are first-class constraints; budget them.
- Bug fixes: reproduce the bug first, as close to the end-user path as possible, so the fix targets the real problem.
- Performance or behavior claims need a measured number or a cited source line, not assertion.
- Fix lint failures, test failures, and flakiness you encounter even if unrelated to the current task;
  when token or time budget is tight, report them instead.

## Codex & Search

- Codex delegation (`codex:codex-rescue`): bounded implementation, bug fix, or second opinion with clear files
  and acceptance criteria; provide objective, relevant files, constraints, and validation commands.
  After it finishes, inspect the actual diff and run tests yourself; never trust the completion summary alone.
- `agy` CLI (Antigravity): huge-context code search and web search, e.g. `agy -p "find where X is used"`.
  It must never modify or delete files.
- Web search: never inline. Delegate to `agy -p` (preferred) or a subagent that returns conclusions only.

## Tooling

- Python: always use `uv` when available (`uv run` over `python3`, `uv pip`, `uv venv`; `uv sync` when `pyproject.toml` exists).
- Search: prefer built-in Glob and Grep tools; when Bash is necessary use `fd` not `find`, `rg` not `grep`.
