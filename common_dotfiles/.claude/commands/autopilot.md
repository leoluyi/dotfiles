---
description: Run the whole plan to completion autonomously, then commit, push and open a PR
argument-hint: [what to build, or blank to continue current plan]
model: sonnet
effort: high
allowed-tools: Read, Edit, Write, Glob, Grep, Agent, TodoWrite, Bash(git status:*), Bash(git diff:*), Bash(git log:*), Bash(git add:*), Bash(git commit:*), Bash(git switch:*), Bash(git checkout:*), Bash(git branch:*), Bash(git push:*), Bash(gh pr create:*), Bash(gh pr view:*)
---

This is **autonomous mode**. Run to completion. Do not come back to me between
steps, do not ask which option I prefer, do not stop to confirm before
committing. I am handing you the whole job, not the first step of it.

## What this overrides

For the duration of this run, these standing rules are suspended:

- The "Plan First / discuss the approach / confirm alignment before implementing"
  process in CLAUDE.md. Plan internally, then execute the plan yourself.
- "Ask about preferences", "surface assumptions and get confirmation", "when
  facing implementation complexity ASK for guidance", "when discovering
  architectural flaws STOP and discuss". You decide. See *Escalation* below for
  how.
- The `/options` rule about surfacing 2-4 choices before every direction
  decision. Batch every decision you made into the final summary instead.
- Git History Protection's ask-before-commit requirement. Its autonomous-mode
  exception applies here by name: commit and push without confirmation.

Everything else in CLAUDE.md still binds you, in particular: no TODO/FIXME or
placeholder comments, no partial work reported as finished, no emojis, no
hardcoded secrets, immutable patterns, files under 800 lines, comprehensive
error handling.

## Sequence

1. **Scope it.** If $ARGUMENTS is non-empty, that is the job. If it is empty,
   the job is the plan already established in this conversation — continue it
   from wherever it stands.
2. **Plan it.** Write the full task breakdown to TodoWrite before touching code,
   with real granularity. This list is your contract; you are done when every
   item is checked, not when the first thing works.
3. **Branch.** Never work on the default branch. If you are on it, create a
   descriptive branch first.
4. **Build it.** Work the list top to bottom. Fix what breaks. Keep going.
5. **Verify.** See *Verification gate*.
6. **Ship.** Commit, push, open a ready PR.

## Escalation: high-tier model for decisions, mid-tier for the work

This command pins the main loop to a mid-tier model at high reasoning effort,
deliberately. Implementation runs here, and it runs with room to think — so
"this is hard" is not by itself a reason to escalate. Judgement calls are.

When you hit a decision that is expensive to reverse — architecture, data model,
public interface shape, library selection, migration strategy, scope cuts, or
any fork where two credible approaches would produce materially different
codebases — do not pick it yourself and do not ask me. Spawn a decision agent:

    Agent(
      subagent_type: "general-purpose",
      model: "opus",
      run_in_background: false,
      prompt: <the full option space, the constraints, the relevant code, and
               "return one decision plus the reasoning and the discarded
               alternatives">
    )

Wait for it, take its decision as settled, and implement it. Do not re-litigate
it, do not blend it with your own preference, do not escalate the same question
twice. Record the decision and its rationale for the final summary.

Do **not** escalate reversible or mechanical choices — naming, file placement,
which helper to extract, formatting, obvious bug fixes. Those are yours. A run
that escalates everything is as broken as one that escalates nothing.

## Self-repair, bounded

When something breaks, fix it yourself. Read the actual error, form a hypothesis,
change one thing, re-run.

The bound is **three attempts per distinct blocker**, and each attempt must rest
on a *different* hypothesis. Re-running the same fix with cosmetic variation
does not count as an attempt, it counts as a loop — cut it immediately. If the
third hypothesis fails, that blocker is a hard stop.

Never route around a blocker by weakening the thing that caught it. Do not
delete or skip a failing test, loosen a type, widen an exception handler, or
comment out the assertion. If the test is genuinely wrong, fix the test and say
so explicitly in the summary.

## Verification gate

Before you may commit, the repo's own checks must be green. Discover them rather
than assuming — look at `package.json` scripts, `Makefile`, `justfile`,
`pyproject.toml`, CI workflow files — and run whatever the project actually
defines for build, test, lint and typecheck.

Red light means you may not commit. Fix it within the three-attempt bound, or
hard stop. Do not commit with a caveat, do not commit "so the work isn't lost",
do not open the PR and mention the failure in the body.

If the repo defines no checks at all, say so in the summary and fall back to
whatever smoke check proves the change actually runs.

## Shipping

Conventional commits, per CLAUDE.md's format. Split into logical commits if the
work has distinct phases; one commit is fine if it does not.

Push with `-u`. Then `gh pr create` as a **ready** PR (not draft) whose body
contains:

- what changed and why
- every decision that went to the high-tier model, with its rationale and the
  alternatives that lost
- every assumption you made that I have not confirmed
- the verification you ran and its result
- a test plan

## Hard stops

These four are the only reasons to break the no-interruption rule. When you hit
one, stop immediately, leave the tree in a coherent state, and report what you
found and what you need. Do not push, do not open a PR.

1. **A blocker survives three distinct fix attempts.** Report the three
   hypotheses and why each failed. Do not keep going.
2. **The verification gate stays red.** Never ship a red build.
3. **The task requires a destructive or irreversible operation** — force-push,
   deleting a branch or history rewrite, altering a migration that has already
   run against real data, `rm -rf`, touching production configuration or
   credentials, anything that reaches outside this repo.
4. **You find a security problem or leaked secret** — hardcoded credentials, an
   auth bypass, an injection hole. Stop and report it. Do not quietly fix it and
   fold it into the PR; a silent security fix is a security fix nobody reviewed.

Anything not on this list — ambiguity, unexpected complexity, a design you
dislike, a missing dependency, a flaky test, an unclear requirement — you handle
yourself and report at the end.

## Final report

One summary at the end covering: what shipped, the PR link, the decisions the
high-tier model made, the assumptions you made unilaterally, the verification
results, and anything you deliberately left out of scope.
