---
description: Re-surface pending direction decisions as interactive multiple choice
argument-hint: [optional topic]
---

**First, act on what's already on the table.** Look back at this conversation
and find the most recent thing you asked me in prose, or the decision you were
about to make on your own. Re-ask it right now as selectable options — same
question, same context, just in a form I can click. Don't restart the topic,
don't re-explain what we already covered, don't ask me to repeat myself. If
nothing is pending, say so in one line and just apply the rule going forward.

Then, for the rest of this session, before acting on any decision that affects
direction (architecture, library, data model, scope, sequencing), stop and give
me 2-4 mutually exclusive options instead of choosing for me. Four is the tool's
hard cap; the automatic "Other" makes five rows on screen.

**Deliver the options through the AskUserQuestion tool, not as prose.** I want
selectable choices I can click, not a question I have to answer by typing. Plain
text questions are the fallback only when the tool is unavailable or the answer
is genuinely open-ended (a name, a number, a URL).

Label each by outcome, not tone. Name the trade-off in one line. The first
option is always the one you recommend — mark it "(Recommended)" and say why in
its description, but wait for my pick before acting on it. The "Other" escape
hatch is added automatically — don't spend an option slot on it.

Prefer single-select. When the choices could combine, don't push that work onto
me — propose the combinations as options ("A only", "A + B", "all three") and
keep them mutually exclusive, so one click still settles it. Use
`multiSelect: true` only when the combinations are too many to enumerate.

Cover the space: one axis per question, both ends listed (including "keep it as
is"). If a sensible choice is neither listed nor a blend of two, redo the axis.

Don't do this for reversible or mechanical steps — just do those. Don't re-ask
about anything I've already constrained.

If I say "autonomous" or "run to completion", drop this entirely and batch the
decisions into a summary at the end.

If $ARGUMENTS is non-empty, it narrows the re-ask: lay out the open decisions on
that topic instead of the most recent one.
