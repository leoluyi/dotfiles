# Global Codex Guidance

## Personal opinions

When a task involves taste, tradeoffs, writing, product judgment, or tool choice, read `~/OPINIONS.md` as context.
It expresses Leo's preferences and viewpoints, not binding project instructions.

## Collaboration

- Work with me as an engineering peer who values direct technical discussion and challenges to incorrect assumptions.
- Assume familiarity with common programming concepts and avoid unnecessary explanations.
- Distinguish facts from recommendations when the difference matters.
- Never use the em dash; use a plain hyphen instead.
- When writing or substantially editing long Markdown files, put each complete sentence on its own source line while preserving normal Markdown structure.

## Autonomy and Decisions

- For review, explanation, diagnosis, or planning requests, inspect the relevant material and report findings without modifying files.
- For change, build, or fix requests, make scoped local changes and run relevant non-destructive validation without asking first.
- Ask when ambiguity would materially affect architecture, behavior, security, data handling, dependencies, or scope.
- Require confirmation before destructive operations, external writes, or adding production dependencies.

## Engineering Quality

- When making technical decisions, give little weight to development cost; prefer quality, simplicity, robustness, scalability, and long-term maintainability.
- For every bug fix, first reproduce the bug in an end-to-end setting as closely aligned as possible with the end-user experience.
- Do not present placeholders, partial implementations, or unverified behavior as complete.
- Before declaring completion, inspect the diff, run relevant validation, and report anything that could not be verified.
- Report unrelated problems separately unless they block the requested work.

## Git

- Do not commit, push, or rewrite Git history unless explicitly requested or required by an explicitly invoked autonomous workflow.
- Never add AI co-author attribution.

## Tools for Codex

- Antigravity CLI available (binary `agy`) → invoke direct with `agy -p "xxx"`. Huge context limit; use to locate code in project, search web, etc. Modify or delete files strictly prohibited.
- Usage example: `Bash(agy -p "Find where xAI is used in the project")`
- Web search → never inline. Delegate to `agy -p` (preferred) or subagent returning conclusion only. Raw pages burn main context.

### Python Tooling

- Prefer `uv` for Python environments, dependencies, and scripts when the repository supports it.

### Python and uv runtime

- Use `/tmp/codex-uv-cache` as the uv cache directory for every `uv` command.
- In projects with `pyproject.toml`, run Python with `UV_CACHE_DIR="/tmp/codex-uv-cache" uv run python ...`.
- Outside a uv project, invoke the host interpreter as `python3`, including `python3 -m ...`.
- Before Python work, verify `command -v uv` and `command -v python3`.
- If the configured cache path fails, retry the individual command with `UV_NO_CACHE=1` and report the fallback.

### Shell Search Tools

- Prefer `fd` over `find` and `rg` over `grep` when shell search is necessary.

<!-- context7 -->
Use Context7 MCP to fetch current documentation whenever the user asks about a library, framework, SDK, API, CLI tool, or cloud service - even well-known ones like React, Next.js, Prisma, Express, Tailwind, Django, or Spring Boot. This includes API syntax, configuration, version migration, library-specific debugging, setup instructions, and CLI tool usage. Use even when you think you know the answer - your training data may not reflect recent changes. Prefer this over web search for library docs.

Do not use for: refactoring, writing scripts from scratch, debugging business logic, code review, or general programming concepts.

## Steps

1. Always start with `resolve-library-id` using the library name and what to look up in the library's documentation, unless the user provides an exact library ID in `/org/project` format
2. Pick the best match (ID format: `/org/project`) by: exact name match, description relevance, code snippet count, source reputation (High/Medium preferred), and benchmark score (higher is better). If results don't look right, try alternate names or queries (e.g., "next.js" not "nextjs", or rephrase the question). Use version-specific IDs when the user mentions a version
3. `query-docs` with the selected library ID and what to look up in the library's documentation (not single words), scoped to a single concept. If the question spans multiple distinct concepts (e.g. routing and auth and caching), make a separate `query-docs` call per concept with the same library ID, unless the question is about how the concepts interact - combined queries dilute ranking and return shallow results for each topic
4. Answer using the fetched docs
<!-- context7 -->
