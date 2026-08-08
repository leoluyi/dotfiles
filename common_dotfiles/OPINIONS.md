# OPINIONS.md

This file is a compact working map of Leo's viewpoints, tastes, values, recurring judgments, and expectations.
It is context for agents, not a set of binding project instructions.
This first version is an adaptation of the example described in [Everyone Should Have an OPINIONS.md](https://blog.kunchenguid.com/p/everyone-should-have-an-opinionsmd), and Leo should revise or remove anything that does not hold.

The file should capture durable beliefs rather than every passing reaction.
Technical details are evidence for broader opinions, not a replacement for them.

## AI agents, orchestration, and developer tools

### Agents should be judged by useful work, not demos

Leo judges coding agents by whether they complete valuable work in real codebases, not by toy demos, polished screenshots, or confident explanations.
He prefers agents that gather evidence through search, inspection, tests, and tools instead of relying on unsupported reasoning.
He accepts extra tool calls and latency when they produce more trustworthy results, because incorrect changes and rework cost more than waiting.

### Agentic engineering changes the work rather than eliminating engineering

Leo sees AI shifting software work toward steering, specification, review, orchestration, system design, and product judgment.
He expects engineers to learn agentic workflows while retaining enough technical depth to control and evaluate what agents produce.
He believes AI amplifies competence and judgment, so weak requirements and weak taste can produce bad work faster.

### Requirements, tests, and review are often the real bottlenecks

Leo believes that in much product software, writing code is not the deepest bottleneck.
The harder questions are what is worth building, what users need, and how to verify that the result works.
He treats tests as a way to encode intent and give agents a reliable feedback loop.
He expects humans to review generated tests carefully because a bad test can bless the wrong behavior.

### Human accountability must remain explicit

Leo treats AI as a tool, not a co-owner of decisions.
Humans remain accountable for AI-assisted changes because they choose the goals, approve the outputs, and own the consequences.
He does not want agents to claim authorship or add themselves as commit co-authors.

### Good agent systems need orchestration, isolation, and fresh context

Leo prefers directing agents with goals, principles, measurable objectives, and review loops instead of micromanaging every step.
He favors deterministic harnesses for repeated long-running work.
He sees fresh context, isolated worktrees, explicit review phases, and fix phases as useful ways to reduce context rot.

### Agent-facing interfaces deserve first-class design

Leo believes agent tools should be designed deliberately for token efficiency, speed, composability, compact output, reliability, and easy chaining.
He values purpose-built CLIs and shell-oriented interfaces when they make agent workflows easier to inspect and compose.
He is cautious about broad automatic tool discovery when it adds search failures, extra turns, or lower success rates.

### CLI agents and IDE agents will coexist

Leo expects CLI and IDE agents to coexist because they serve different workflows.
CLI agents are portable, scriptable, and composable, while IDEs provide richer interactive context and more opinionated experiences.

### Model choice should follow task shape, not fandom

Leo is pragmatic about models and harnesses.
He chooses tools based on the task, the required interaction style, the verification loop, and the quality of the result.
He is willing to use more reasoning or a slower workflow when it reduces correction turns and rework.
He is cautious about large context windows and automatic memory when they add stale information or unnecessary process.

## AI labs, markets, and openness

### Model labs create the most ecosystem value as infrastructure providers

Leo prefers model labs to compete by making frontier models cleaner, cheaper, faster, and more reliable.
He is skeptical when labs use model power, bundling, or platform control to disadvantage independent tools and downstream products.

### AI products need a moat beyond a wrapper

Leo is skeptical of products whose only advantage is a prompt over a commodity model.
He expects durable AI businesses to own distribution, workflow, proprietary context, customer trust, operational depth, or a superior ability to build and iterate.

### Open AI requires more than open weights

Leo does not equate open weights with fully open AI.
He considers training data, the training stack, inference stack, hardware assumptions, and reproducibility part of the openness question.
He believes open weights alone are not enough to reproduce a model or establish full open-source equivalence.

### AI evaluation needs systematic evidence

Leo distrusts screenshots, isolated anecdotes, and selective demos as proof of model quality, bias, truthfulness, or coding ability.
He prefers canonical datasets, careful benchmark design, production evidence, and explicit attention to contamination and selection bias.

## Software engineering, craft, and process

### Great engineers create valuable outcomes

Leo defines engineering excellence by the ability to get valuable things built under real constraints.
That requires technical depth, breadth, strategy, delivery, communication, and judgment about organizational context.

### Senior engineers and managers must create leverage

Leo expects senior people to improve the conditions in which others work.
That can mean technical direction, removing bottlenecks, growing people, aligning stakeholders, repairing processes, or helping other teams succeed.
He does not believe every strong individual contributor should be pushed into management.

### Code quality decays without active stewardship

Leo believes codebases drift toward entropy unless people actively maintain the quality bar.
He prefers review cultures where authors explain how changes were tested and where reviewers focus attention on risk rather than rediscovering every detail.
He values clear ownership boundaries and dislikes processes that make small changes require excessive meetings or approvals.

### Pull requests will evolve under agentic workflows

Leo expects pull requests to become less central as agents write more code and humans steer and verify the work.
He still sees pull requests as useful for CI gates, release automation, metadata, and team coordination.
He does not think humans need to read every generated line when requirements, tests, evidence, summaries, risks, and targeted diffs are strong enough.

### Tools should make good choices easy

Leo values ergonomics because a sound architecture that is hard to use correctly still creates maintenance problems.
He likes opinionated defaults when they can be centrally improved while preserving escape hatches for advanced users.
He prefers terminal-centered workflows, low visual clutter, reproducible environments, and clear boundaries between tools.
He expects abstractions and frameworks to earn their complexity by matching the actual problem.

## Product, startups, and organizations

### As building gets easier, judgment matters more

Leo believes AI makes building software easier and therefore increases the importance of knowing what to build.
He prefers starting from real users and named problems rather than abstract brainstorming or technology-first excitement.
He favors narrow prototypes and existing building blocks when the goal is learning quickly.

### Idea quality depends on the builder

Leo believes the quality of an idea depends on the builder's context, resources, understanding, and motivation.
He prefers exploring multiple ideas before committing when the goal is discovery.

### AI enables smaller serious companies

Leo expects AI to increase individual leverage enough to make one-person and small-team companies more viable.
He does not believe every company should rebuild a large SaaS product internally just because agents can write code.
He expects future work systems to need better shared context, work tracking, memory, cost control, and collaboration models for people working with many agents.

### Enterprise AI adoption requires behavior change

Leo believes providing AI tools is not enough to create meaningful adoption.
Real adoption requires education, value discovery, workflow redesign, changed incentives, and processes built around measurable outcomes.

### Incentives shape product quality

Leo believes many product-quality problems come from incentives that reward shipping impressive things over improving customer outcomes.
He prefers teams to optimize around users, business results, and maturity rather than activity metrics alone.

## Career, learning, and work

### Curiosity and compounding learning are durable advantages

Leo treats curiosity, motivation, and repeated building as durable advantages.
He uses the question "What can I do this month that I could not do last month?" as a useful check on growth.
He believes people should build things they find meaningful or fun because enjoyment sustains long-term effort.

### Education should include agents and real products

Leo values fundamentals, but does not think most learning time should be spent writing code for its own sake.
He prefers learning through real products, system design, agentic engineering, communication, and feedback from actual users.

### Career moves are context-dependent

Leo does not believe people should blindly copy another person's career move.
Runway, family context, opportunity cost, learning goals, timing, and personal preference all matter.
He believes focus often requires dropping work that does not serve the most important goals.

### Being effective matters more than being right

Leo believes technical correctness is not the only measure of good work.
Political and organizational constraints are real parts of engineering, and effectiveness means creating value within the system while improving the system where possible.

## Platforms, discourse, and trust

### Social platforms reward shallow signals

Leo believes algorithmic feeds make hype, clickbait, and overbroad claims easier to distribute than nuance.
He prefers explanations that teach one concept at a time and respect the reader's background.
He expects authenticity and clear provenance to matter more as generated content becomes common.

### Platforms should compete without suppressing alternatives

Leo does not think platform fees are inherently wrong.
He objects when a platform uses control of distribution to suppress viable alternatives or lock users in unfairly.

### Trust requires plain accountability

Leo expects customer-impacting incidents to be addressed with accountability, explanation, prevention steps, and appropriate remediation.
He dislikes defensive minimization when users were harmed.
He values transparency when companies commercialize or significantly build on open-source work.

## Society and institutions

### Institutions matter because coordination creates value

Leo sees organizations as ways for people to create value together that they could not create alone.
He expects multi-agent systems to inherit human collaboration problems such as bottlenecks, duplicated work, diffusion of responsibility, information loss, and red tape.
He believes organizational topology and communication design can matter as much as raw intelligence.
He prefers turning intuitions about organization design into simulations or comparable evidence instead of relying only on slogans.

## Maintenance rules

- Keep durable opinions, principles, tastes, values, critiques, predictions, tradeoffs, and recurring judgments.
- Treat technical details as evidence for an underlying opinion rather than copying recipes, commands, or implementation steps.
- Ignore jokes, dunks, one-off reactions, and ambiguous statements without context.
- Periodically reorganize the structure when a clearer grouping emerges.
- Flag contradictions, meaningful refinements, stale beliefs, and claims that may be factually wrong instead of silently collapsing them.
- Preserve uncertainty when a statement is an expectation, preference, or hypothesis rather than a fact.
