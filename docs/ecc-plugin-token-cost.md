# ecc plugin 的 token 成本與 hook 精簡

調查 `ecc@everything-claude-code` 開著的代價，以及有哪些旋鈕真的存在。

調查日期 2026-07-28。環境：Claude Code `2.1.220`、`model: opus`、
`ENABLE_TOOL_SEARCH=true`、plugin 版本 `ecc 2.0.0`
（`/Users/leoluyi/.claude/plugins/cache/everything-claude-code/ecc/2.0.0`，以下簡稱 `$P`）。

本文所有數字都是在本機量到的，不是估算轉述。全程唯讀，沒有改動任何設定。

## 一句話結論

harness 自己算出來 ecc 每個 session 的 always-on 成本是 **~23,030 tokens**，
是其他九個 plugin 加總（~2,709）的 8.5 倍；而使用者到目前為止只用過其中兩個 skill。
更麻煩的不是這 23k，是 ecc 的 363 個 skill 名稱把 **skill listing 的字元預算吃光**，
導致使用者自己寫的 skill 在 listing 裡只剩名字、沒有 description。

## 權威數字

Claude Code 內建 `claude plugin details` 會用 `count_tokens` API 實算
（[plugins-reference](https://code.claude.com/docs/en/plugins-reference)，`plugin details` 段）。
本機實跑結果：

| plugin | Skills | Agents | Hooks | MCP | always-on |
|---|---:|---:|---:|---:|---:|
| **ecc** | **363** | **67** | **7 events** | **1** | **~23,030 tok** |
| caveman | 12 | 3 | 2 | 0 | ~955 |
| engineering | 10 | 0 | 0 | 10 | ~695 |
| superpowers | 14 | 0 | 1 | 0 | ~584 |
| dev-workflow | 1 | 0 | 0 | 0 | ~179 |
| dx | 6 | 0 | 0 | 0 | ~171 |
| andrej-karpathy-skills | 1 | 0 | 0 | 0 | ~66 |
| frontend-design | 1 | 0 | 0 | 0 | ~59 |
| security-guidance | 0 | 0 | 4 | 0 | ~0 |
| claude-hud | 0 | 0 | 0 | 0 | ~0 |

ecc 佔全部 plugin always-on 成本的 **89.5%**。

輸出裡兩行註記值得記下來：

```
Hooks (7)  PreToolUse, PreCompact, SessionStart, PostToolUse, PostToolUseFailure, Stop, SessionEnd  (harness-only — no model context cost)
MCP servers (1)  chrome-devtools  (tool schemas resolved at runtime; not counted)
```

- hook **註冊**確實不佔 context，但 hook **輸出**佔（見下方「會注入 context 的 hook」）。
- MCP schema 沒被計入，是因為 `ENABLE_TOOL_SEARCH=true` 把 schema 延後載入了。

## 這 23k 是怎麼組成的

拆帳（實測 frontmatter 字元數，`$P/skills/*/SKILL.md`、`$P/commands/**/*.md`、`$P/agents/**/*.md`）：

| 來源 | 數量 | name 字元 | description 字元 | 備註 |
|---|---:|---:|---:|---|
| skills | 271 | 4,671 | 59,914 | 全部都有 description，平均 221 字元 |
| commands | 92 | 996 | 9,767 | 平均 106 字元 |
| agents | 67 | 1,057 | 13,847 | 平均 207 字元 |

合計約 90,000 字元，除以 ~3.9 字元/token 正好落在 23k —— 也就是說
`claude plugin details` 報的是**全文未裁切**的數字。實際送進 model 的比這少，原因見下節。

### skill listing 有預算，agent listing 沒有

這是本次調查最重要的發現。官方文件
[skills — Skill descriptions are cut short](https://code.claude.com/docs/en/skills) 寫得很直接：

> The listing always contains every skill name, but if you have many skills, Claude Code
> shortens descriptions to fit the listing's character budget, which can strip the keywords
> Claude needs to match your request. The budget scales at 1% of the model's context window.
> When the listing overflows, Claude Code drops descriptions starting with the skills you
> invoke least, so the skills you use most keep their full text.

對照本機這個 session 收到的 skill listing，行為完全吻合：

- ecc 的 363 個 entry 裡，**只有 `ecc:strategic-compact` 和 `ecc:skill-create` 保留了
  description**，其餘全部只剩名字。這兩個正好是使用者唯一各用過一次的。
- 反過來，使用者自己 `~/.claude/skills/` 底下的 `review`、`tdd`、`setup-pre-commit`、
  `autopilot` 等，description 也被砍掉了。
- superpowers 的 `dispatching-parallel-agents`、`systematic-debugging`、
  `test-driven-development` 同樣掉了 description，儘管
  `/Users/leoluyi/.claude/plugins/cache/claude-plugins-official/superpowers/6.2.0/skills/*/SKILL.md`
  裡都寫得好好的。

**這才是真正的傷害。** 200k context 的 1% 約 2,000 tokens；而光是 ecc 的 363 個名字
（`- ecc:<name>` 形式）就是 8,298 字元、約 2,100–2,600 tokens。名字是**無條件**進 listing 的
（"always contains every skill name"），所以 ecc 一個 plugin 就把整個預算佔滿，
其他所有 skill 只能拿到名字。description 沒了，Claude 就沒有關鍵字可以比對，
自動觸發 skill 的能力等於被廢掉。

agent listing 則**沒有**這個預算機制：本 session 的 67 個 ecc agent 全部帶完整
description 和 `(Tools: ...)`。約 15,000 字元、**~4,000–5,000 tokens**，
而且只要 plugin 開著就無法迴避。

> 未驗證：官方文件沒有明說 agent listing 是否也有預算。此處結論來自本 session 的實際觀察
> （67 個全帶完整 description），不是文件陳述。

### MCP：chrome-devtools

`$P/.claude-plugin/plugin.json` 的 `mcpServers` 是空物件 `{}`，但 `$P/.mcp.json` 有內容：

```json
{ "mcpServers": { "chrome-devtools": { "command": "npx", "args": ["-y", "chrome-devtools-mcp@latest"] } } }
```

[plugins-reference](https://code.claude.com/docs/en/plugins-reference) 明載
"**Location**: `.mcp.json` in plugin root, or inline in plugin.json"，所以這個 server 會被載入。
本機 `ps aux` 確認它現在正在跑，三個 process：

```
npm exec chrome-devtools-mcp@latest
chrome-devtools-mcp
node .../chrome-devtools-mcp/build/src/telemetry/watchdog/main.js --parent-pid=... --os-type=2
```

29 個 tool。因為 `ENABLE_TOOL_SEARCH=true`，context 裡只有工具名稱：
1,360 字元、**~425 tokens**。若關掉 tool search，這裡會變成 29 份完整 JSONSchema。

代價不只 token：每次開 session 都會 `npx -y ...@latest`（含網路解析），
常駐約 380MB RSS，還附一支 telemetry watchdog。

## 顆粒度控制：能做什麼、不能做什麼

| 想做的事 | 可行？ | 依據 |
|---|---|---|
| 只啟用 plugin 裡的部分 skill | **不行** | [skills](https://code.claude.com/docs/en/skills)：「Plugin skills are not affected by `skillOverrides`. Manage those through `/plugin` instead.」 |
| 只啟用部分 agent / command | **不行** | `plugin.json` 無此欄位；`/plugin` detail view 只「顯示」component 清單，不提供逐項開關（[discover-plugins](https://code.claude.com/docs/en/discover-plugins)） |
| 只停用部分 hook | **可以，但只到 hook 內部** | ecc 自己的 `ECC_HOOK_PROFILE` / `ECC_DISABLED_HOOKS`，見下節 |
| 停用 plugin 帶的 MCP server 但保留 plugin | **可以** | [mcp](https://code.claude.com/docs/en/mcp)：「You can still toggle an installed plugin server off in `/mcp`」，選擇寫入 `~/.claude.json` 的 `disabledMcpServers`（per project） |
| 整個 plugin 開關 | 可以 | `claude plugin disable ecc@everything-claude-code`，或改 `enabledPlugins` |
| `settings.json` 有 `disabledSkills` / `enabledSkills` | **沒有這種 key** | 完整 settings 清單裡不存在；能用的是 `skillOverrides`（四態：`on` / `name-only` / `user-invocable-only` / `off`），但它**對 plugin skill 無效** |

其他相關但常被誤會的 key：

- `disableAllHooks: true` —— 關掉**所有** hook，也會關掉 statusline
  （使用者現在有 `statusLine` 設定，所以這招會有副作用）。
- `disabledMcpjsonServers` —— 只管 `.mcp.json`（專案層），不是 plugin 層。
- `disableBundledSkills` —— 只管 Claude Code 內建 skill，文件明言
  「Skills from plugins, `.claude/skills/`, and `.claude/commands/` are unaffected」。
- `skillListingBudgetFraction` / `skillListingMaxDescChars` —— 可以把 listing 預算調大，
  但那是花更多 token 去容納 ecc，方向相反。

至於 `$P/.claude/ecc-tools.json` 裡的 `profile: "full"` / `selectedComponents`：那是
`install.sh` 選擇性安裝流程的產物（見 `$P/docs/SELECTIVE-INSTALL-ARCHITECTURE.md`），
**走 plugin 路線時完全不起作用**。plugin 是全有全無。

## Hooks 全清單

`$P/hooks/hooks.json`（354 行）註冊 7 個事件、**28 個 hook entry**。
沒有 `UserPromptSubmit`。

每個 entry 的 command 都是一段壓縮過的 `node -e` bootstrap，最後轉呼叫
`scripts/hooks/plugin-hook-bootstrap.js` → `scripts/hooks/run-with-flags.js <hookId> <script> <profilesCsv>`。

| # | Event | Matcher | sync | timeout | hookId | script | profiles |
|---:|---|---|---|---|---|---|---|
| 1 | PreToolUse | `Bash` | sync | – | （dispatcher） | `pre-bash-dispatcher.js` | 見下 |
| 2 | PreToolUse | `Write` | sync | – | `pre:write:doc-file-warning` | `doc-file-warning.js` | standard,strict |
| 3 | PreToolUse | `Edit\|Write` | sync | – | `pre:edit-write:suggest-compact` | `suggest-compact.js` | standard,strict |
| 4 | PreToolUse | `*` | async | 10 | `pre:observe` | `observe-runner.js` | standard,strict |
| 5 | PreToolUse | `Bash\|Write\|Edit\|MultiEdit` | sync | 10 | `pre:governance-capture` | `governance-capture.js` | standard,strict |
| 6 | PreToolUse | `Write\|Edit\|MultiEdit` | sync | 5 | `pre:config-protection` | `config-protection.js` | standard,strict |
| 7 | PreToolUse | `*` | sync | **無** | `pre:mcp-health-check` | `mcp-health-check.js` | standard,strict |
| 8 | PreToolUse | `Edit\|Write\|MultiEdit` | sync | 5 | `pre:edit-write:gateguard-fact-force` | `gateguard-fact-force.js` | standard,strict |
| 9 | PreCompact | `*` | sync | – | `pre:compact` | `pre-compact.js` | standard,strict |
| 10 | SessionStart | `*` | sync | – | `session:start` | `session-start.js` | **minimal**,standard,strict |
| 11 | PostToolUse | `Bash` | async | 30 | （dispatcher） | `post-bash-dispatcher.js` | 見下 |
| 12 | PostToolUse | `Edit\|Write\|MultiEdit` | async | 30 | `post:quality-gate` | `quality-gate.js` | standard,strict |
| 13 | PostToolUse | `Edit\|Write\|MultiEdit` | sync | 10 | `post:edit:design-quality-check` | `design-quality-check.js` | standard,strict |
| 14 | PostToolUse | `Edit\|Write\|MultiEdit` | sync | – | `post:edit:accumulate` | `post-edit-accumulator.js` | standard,strict |
| 15 | PostToolUse | `Edit` | sync | – | `post:edit:console-warn` | `post-edit-console-warn.js` | standard,strict |
| 16 | PostToolUse | `Bash\|Write\|Edit\|MultiEdit` | sync | 10 | `post:governance-capture` | `governance-capture.js` | standard,strict |
| 17 | PostToolUse | `*` | sync | 10 | `post:session-activity-tracker` | `session-activity-tracker.js` | standard,strict |
| 18 | PostToolUse | `*` | async | 10 | `post:observe` | `observe-runner.js` | standard,strict |
| 19 | PostToolUse | `*` | sync | 10 | `post:ecc-metrics-bridge` | `ecc-metrics-bridge.js` | **minimal**,standard,strict |
| 20 | PostToolUse | `*` | sync | 10 | `post:ecc-context-monitor` | `ecc-context-monitor.js` | standard,strict |
| 21 | PostToolUseFailure | `*` | sync | – | `post:mcp-health-check` | `mcp-health-check.js` | standard,strict |
| 22 | Stop | `*` | sync | **300** | `stop:format-typecheck` | `stop-format-typecheck.js` | standard,strict |
| 23 | Stop | `*` | sync | – | `stop:check-console-log` | `check-console-log.js` | standard,strict |
| 24 | Stop | `*` | async | 10 | `stop:session-end` | `session-end.js` | **minimal**,standard,strict |
| 25 | Stop | `*` | async | 10 | `stop:evaluate-session` | `evaluate-session.js` | **minimal**,standard,strict |
| 26 | Stop | `*` | async | 10 | `stop:cost-tracker` | `cost-tracker.js` | **minimal**,standard,strict |
| 27 | Stop | `*` | async | 10 | `stop:desktop-notify` | `desktop-notify.js` | standard,strict |
| 28 | SessionEnd | `*` | async | 10 | `session:end:marker` | `session-end-marker.js` | **minimal**,standard,strict |

`pre-bash-dispatcher.js` / `post-bash-dispatcher.js` 進入
`$P/scripts/hooks/bash-hook-dispatcher.js`，裡面再跑 10 個子 hook
（`bash-hook-dispatcher.js:22-73`），各自帶 profile：

| 子 hook id | profiles | 作用 |
|---|---|---|
| `pre:bash:block-no-verify` | minimal,standard,strict | 擋 `--no-verify` |
| `pre:bash:auto-tmux-dev` | （預設 standard,strict） | dev server 導向 tmux |
| `pre:bash:tmux-reminder` | strict | 長指令建議 tmux |
| `pre:bash:git-push-reminder` | strict | push 前提醒 |
| `pre:bash:commit-quality` | strict | commit 前 lint / secret 掃描 |
| `pre:bash:gateguard-fact-force` | standard,strict | GateGuard |
| `post:bash:command-log-audit` | （預設 standard,strict） | 指令稽核紀錄 |
| `post:bash:command-log-cost` | （預設 standard,strict） | 成本紀錄 |
| `post:bash:pr-created` | standard,strict | `gh pr create` 後記 URL |
| `post:bash:build-complete` | standard,strict | build 後背景分析 |

沒帶 `profiles` 的，fallback 是 `['standard','strict']`（`$P/scripts/lib/hook-flags.js:35`）。

### profile 機制到底怎麼運作

`run-with-flags.js` 第三個參數那串 `standard,strict` 不是「旗標」，是**這個 hook 在哪些
profile 下啟用**的白名單。判斷邏輯全在 `$P/scripts/lib/hook-flags.js`：

```js
// hook-flags.js:6-8
// - ECC_HOOK_PROFILE=minimal|standard|strict (default: standard)
// - ECC_DISABLED_HOOKS=comma,separated,hook,ids
```

```js
// hook-flags.js:57-69
function isHookEnabled(hookId, options = {}) {
  const disabled = getDisabledHookIds();
  if (disabled.has(id)) return false;
  const profile = getHookProfile();
  const allowedProfiles = parseProfiles(options.profiles);
  return allowedProfiles.includes(profile);
}
```

所以 `ECC_HOOK_PROFILE=minimal` 會關掉 28 個裡的絕大多數，只留下 profiles 含 `minimal` 的六個：
`session:start`、`post:ecc-metrics-bridge`、`stop:session-end`、`stop:evaluate-session`、
`stop:cost-tracker`、`session:end:marker`，加上 `pre:bash:block-no-verify`。

**但這裡有個關鍵陷阱：** 這個判斷發生在 `run-with-flags.js:164`，也就是
**process 已經起來之後**。`hooks.json` 裡的 entry 數量不變，Claude Code 該 spawn 的還是照 spawn。
而且 `plugin-hook-bootstrap.js:93` 是用 `spawnSync(process.execPath, ...)` 再開一支 node，
所以**每個 hook entry = 兩支 node process**（legacy hook 如 `mcp-health-check.js` 沒有
`module.exports.run` 的，再多一支，共三支）。

本機實測（macOS、node 25.6.0），把 hook 設成 disabled 之後跑完整 bootstrap 鏈：

| 情境 | 5 次總耗時 | 每次 |
|---|---:|---:|
| `node -e ''` 基準 | 0.220s | 44ms |
| `run-with-flags.js`（hook disabled） | 0.406s | 81ms |
| 完整 bootstrap 鏈（hook disabled） | **0.619s** | **124ms** |

124ms 是**地板價**，hook 本體根本沒執行。乘上每次 tool call 的 entry 數：

| tool | pre | post | 合計 entry | 其中 sync | 地板延遲（sync 部分，序列化） |
|---|---:|---:|---:|---:|---:|
| Read / Grep | 2 | 4 | 6 | 4 | ~0.5s |
| Bash | 4 | 6 | 10 | 7 | ~0.9s |
| Edit / Write | 6–7 | 8–9 | 15 | 12 | ~1.5s |

也就是說：**`ECC_HOOK_PROFILE=minimal` 省的是 hook 的工作量和輸出，不是 process 啟動成本。**
要省掉 spawn，只能整個停用 plugin 或用 `disableAllHooks`。

### 會注入 context 的 hook

hook 註冊不佔 context，但這幾支會透過 `hookSpecificOutput.additionalContext` 把文字塞進對話：

| hook | 何時 | 內容 |
|---|---|---|
| `session:start` | 每次開 session | 上一段 session summary、instincts、learned skills、project type JSON。**預設上限 8,000 字元 ≈ 2,000 tokens**（`session-start.js:34`, `:146-158`） |
| `post:ecc-context-monitor` | 每次 tool call | context / cost / scope / loop 警告，取前兩則（`ecc-context-monitor.js:234-266`） |
| `pre:edit-write:suggest-compact` | Edit/Write | 建議 `/compact`（`suggest-compact.js:250-260`） |
| `pre:edit-write:gateguard-fact-force` | Edit/Write | GateGuard denial 訊息，前 3 次完整（`gateguard-fact-force.js:858`） |
| Bash dispatcher 的子 hook | Bash | 經 `pretooluse-visible-output.js` 合併後注入 |

本次調查過程中就真的被注入了一則：

```
PostToolUse:Bash hook additional context: COST WARNING: session total ~$10.18 (over $10). Informational only.
```

這是 `post:ecc-context-monitor` 的產物。`$P/docs/token-optimization.md` 自己也建議訂閱制使用者
把它關掉（`ECC_CONTEXT_MONITOR_COST_WARNINGS=off`）。

`PreCompact` 相對無害：`$P/scripts/hooks/pre-compact.js` 只 append 兩個檔案
（`compaction-log.txt` 和 active session 檔），**不注入任何 context**。它的成本純粹是
每次 compaction 多兩支 node process。

## 建議（依 CP 值排序）

### 1. 停用整個 plugin，把用到的兩個 skill 複製出來

省最多，功能損失最小。使用者只用過 `/ecc:strategic-compact` 和 `/ecc:skill-create` 各一次，
而這兩個都是**單一 markdown 檔、零外部相依**：

- `$P/skills/strategic-compact/SKILL.md`（6,394 bytes，目錄下只有這一個檔）
- `$P/commands/skill-create.md`（174 行 / 4,529 bytes，內容只有一段 `git log`，沒有引用
  `CLAUDE_PLUGIN_ROOT` 或任何 `scripts/`）

```sh
P="$HOME/.claude/plugins/cache/everything-claude-code/ecc/2.0.0"
mkdir -p ~/.claude/skills/strategic-compact ~/.claude/commands
cp "$P/skills/strategic-compact/SKILL.md" ~/.claude/skills/strategic-compact/SKILL.md
cp "$P/commands/skill-create.md"          ~/.claude/commands/skill-create.md

claude plugin disable ecc@everything-claude-code
```

或直接把 `~/.claude/settings.json` 的 `enabledPlugins` 裡那一行改成 `false`：

```json
"ecc@everything-claude-code": false
```

換來的：

- always-on 名目 −23,030 tok；其中**確定省下**的是 agent listing 的 ~4,000–5,000 tok
  和 MCP 名稱的 ~425 tok。
- skill listing 預算釋出約 2,100–2,600 tokens 的名字空間 —— 使用者自己的 skill
  和 superpowers 會**拿回 description**，自動觸發才會正常運作。這比省 token 更重要。
- 每次 tool call 少 6–15 支 node process，Edit 少約 1.5 秒。
- 少三支常駐 process（chrome-devtools-mcp，~380MB）。
- 複製出來的兩個 skill 只花約 70 tokens。

之後要換版本，`/plugin` 的 Installed 分頁還會把它列在 **Not used recently**
（Claude Code v2.1.187+，[discover-plugins](https://code.claude.com/docs/en/discover-plugins)）。

註：`/plugin disable` 之後跑 `/reload-plugins` 會使 prompt cache 失效並重讀整段對話
（因為 ecc 有 MCP server）。乾脆等下次重開 session。

### 2. 若一定要保留 plugin：先關 MCP

單獨關掉 chrome-devtools 不需要動 plugin：

```
/mcp
```

在面板裡把 `chrome-devtools` toggle off。Claude Code 會寫進 `~/.claude.json` 的
`disabledMcpServers`（per project）。本機這個列表已經在用了
（目前是 `["claude.ai Gmail", "claude.ai Google Calendar"]`）。

省 ~425 tok + 三支常駐 process + 每次開 session 的 `npx -y ...@latest` 網路解析。

> 未驗證：plugin server 寫進 `disabledMcpServers` 時用的確切 display name 字串，文件只說是
> 「display name」。建議用 `/mcp` UI 讓它自己寫，不要手動猜 JSON 值。

### 3. 若一定要保留 plugin：降 hook profile 並關掉注入

加到 `~/.claude/settings.json` 的 `env` 區塊：

```json
{
  "env": {
    "ENABLE_TOOL_SEARCH": "true",
    "ECC_HOOK_PROFILE": "minimal",
    "ECC_SESSION_START_CONTEXT": "off",
    "ECC_CONTEXT_MONITOR_COST_WARNINGS": "off"
  }
}
```

效果：

- `ECC_HOOK_PROFILE=minimal` —— 28 個 entry 裡只剩 6 個真的做事，
  包含所有會 block 的（`config-protection`、`mcp-health-check`、GateGuard）都關掉。
  **但 process spawn 不會減少**，延遲照舊。
- `ECC_SESSION_START_CONTEXT=off` —— 每個 session 省最多 8,000 字元 ≈ 2,000 tokens。
  折衷做法是 `"ECC_SESSION_START_MAX_CHARS": "2000"`。
- `ECC_CONTEXT_MONITOR_COST_WARNINGS=off` —— 不再注入 API 費率估算警告
  （訂閱制使用者本來就對不上帳）。

若只想關特定幾支而不動 profile，用 hook id：

```json
"ECC_DISABLED_HOOKS": "pre:mcp-health-check,post:mcp-health-check,pre:edit-write:gateguard-fact-force,post:ecc-context-monitor,stop:desktop-notify,stop:format-typecheck"
```

id 就是上面表格裡的那一欄，逐字對應（`hook-flags.js:14-16` 會 trim + lowercase）。

### 4. 不建議的做法

- `"disableAllHooks": true` —— 會連 statusline 一起關掉，而使用者有自訂 statusline。
- 調大 `skillListingBudgetFraction` —— 是花更多 token 去容納 ecc，方向反了。
- 手動編輯 `$P/hooks/hooks.json` —— plugin cache 目錄會被 auto-update 覆蓋。

## 與 README 不符 / 意外之處

### hooks/README.md 的表格是舊的

`$P/hooks/README.md` 的 PreToolUse / PostToolUse 表列了三個**根本沒有註冊**的 hook：

| README 宣稱 | 對應檔案 | 實際狀態 |
|---|---|---|
| Dev server blocker（`Bash`，exit 2 會擋） | `pre-bash-dev-server-block.js` | 不在 `hooks.json`，也不在 `bash-hook-dispatcher.js` 的 `PRE_BASH_HOOKS` |
| Prettier format（`Edit`） | `post-edit-format.js` | 不在 `hooks.json` |
| TypeScript check（`Edit`） | `post-edit-typecheck.js` | 不在 `hooks.json` |

format / typecheck 的功能實際上被搬到 Stop 事件的 `stop-format-typecheck.js`（entry #22，
timeout 300 秒）。dev-server blocker 則是純孤兒。另有幾支孤兒檔：
`pre-write-doc-warn.js`、`insaits-security-monitor.py`、`insaits-security-wrapper.js`、
`cursor-session-env.js`、`ecc-statusline.js`、`run-with-flags-shell.sh`。

反過來，**實際會跑但 README 完全沒提**的有：`mcp-health-check`（PreToolUse `*`）、
`governance-capture`、`observe-runner`、`session-activity-tracker`、`ecc-metrics-bridge`、
`ecc-context-monitor`、`config-protection`、`design-quality-check`、`post-edit-accumulator`，
以及 Edit/Write 路徑上的 `gateguard-fact-force`。

也就是說：README 描述的 hook 集合，和 `hooks.json` 實際註冊的集合，兩邊都不完整、也不一致。

### `pre:mcp-health-check` 是最可疑的一支

它 match `*`（每一次 tool call）、**sync**、**沒有 timeout**，而且沒有
`module.exports.run`（`mcp-health-check.js` 尾端是 `main().catch(...)`），
所以走 `run-with-flags.js:231` 的 legacy 路徑再 spawn 一支 —— **每次 tool call 三支 node process**。

它對非 MCP 工具會早退（`mcp-health-check.js:154`：`if (!toolName.startsWith('mcp__')) return null`），
所以不會做無謂的網路探測，但那三支 process 每次都照開。

另外兩點：

- fail-open 預設是**關**的（`mcp-health-check.js:558`，需要 `ECC_MCP_HEALTH_FAIL_OPEN=1`）。
  探測失敗時它 `exit(2)`，也就是**擋掉該次 MCP tool call**。
- 它從 tool name 取 server 名的方式是 `toolName.slice(5).split('__')[0]`
  （`mcp-health-check.js:158-165`）。對 plugin 提供的工具，實際名稱是
  `mcp__plugin_ecc_chrome-devtools__click`，取出來會是 `plugin_ecc_chrome-devtools`，
  對不上 `.mcp.json` 的 key `chrome-devtools`，於是走「No MCP config found; skipping preflight probe」
  分支。換句話說，**這支 hook 對 ecc 自己的 MCP server 是無效的**，純粹是常駐開銷。

> 這一點是讀 code 推得的，沒有實際觸發 MCP tool 去驗證。

### plugin.json 的 mcpServers 是空的

`$P/.claude-plugin/plugin.json` 寫 `"mcpServers": {}`，看起來像沒有 MCP server，
實際上 `$P/.mcp.json` 才是生效來源。只看 `plugin.json` 會漏掉這 29 個工具和三支 process。

### ecc 自己的文件其實講對了一半

`$P/docs/token-optimization.md` 和 `$P/docs/capability-surface-selection.md` 對 token 成本的
論述是正確且務實的（「prefer the lower token overhead」、「keep under 10 MCP servers」、
SessionStart 上限、cost warning 開關都有寫）。問題在於 plugin 本身出貨 271 skills + 92 commands
+ 67 agents + 1 個 MCP server，恰恰違反自己文件的原則。README 第 1194 行還提醒
「Too many MCP servers eat your context」。

## 量測方式（之後要複查用）

```sh
P="$HOME/.claude/plugins/cache/everything-claude-code/ecc/2.0.0"

# plugin 層級的 always-on token 成本（harness 用 count_tokens 實算）
claude plugin details ecc

# 每個事件註冊了幾個 hook entry
python3 -c "
import json
d = json.load(open('$P/hooks/hooks.json'))['hooks']
print({k: sum(len(m['hooks']) for m in v) for k, v in d.items()})
"

# hook bootstrap 的地板延遲：故意把 hook 停用，量純粹的 process 啟動成本
export CLAUDE_PLUGIN_ROOT="$P"
export ECC_DISABLED_HOOKS=post:session-activity-tracker
time (for i in 1 2 3 4 5; do
  echo '{"tool_name":"Read","tool_input":{}}' \
    | node "$P/scripts/hooks/run-with-flags.js" \
        post:session-activity-tracker \
        scripts/hooks/session-activity-tracker.js standard,strict >/dev/null
done)

# MCP process
ps aux | rg chrome-devtools-mcp
```

session 內則用 `/context`（Skills 那一列已經是套過預算後的實際值）和 `/doctor`
（會列出 listing 的最大貢獻者）。

## 未驗證項目

- agent listing 是否也有字元預算。本文結論來自本 session 的觀察，官方文件未著墨。
- `skillListingBudgetFraction` 的預設值。skills 文件只說「The budget scales at 1% of the
  model's context window」，settings 頁的該列在抓取時被截斷，沒拿到明確 default。
- plugin MCP server 寫入 `disabledMcpServers` 時的確切字串。
- `mcp-health-check` 對 plugin-scoped MCP tool 名稱解析失敗，是讀 code 推論，未實測觸發。

## 參考

- [Claude Code — Extend Claude with skills](https://code.claude.com/docs/en/skills)（progressive disclosure、skill listing budget、`skillOverrides`、1,536 字元上限）
- [Claude Code — Plugins reference](https://code.claude.com/docs/en/plugins-reference)（`.mcp.json` 與 `hooks/hooks.json` 的載入位置、`claude plugin details`）
- [Claude Code — Discover and install plugins](https://code.claude.com/docs/en/discover-plugins)（`/plugin` 只管整個 plugin、Not used recently、`/reload-plugins` 的 cache 成本）
- [Claude Code — MCP](https://code.claude.com/docs/en/mcp)（Plugin-provided MCP servers、`disabledMcpServers`）
- [Claude Code — Settings](https://code.claude.com/docs/en/settings)（`disableAllHooks`、`disableBundledSkills`、`disabledMcpjsonServers`）
- `$P/hooks/README.md`、`$P/docs/token-optimization.md`、`$P/scripts/lib/hook-flags.js`、`$P/scripts/hooks/run-with-flags.js`
- [affaan-m/everything-claude-code](https://github.com/affaan-m/everything-claude-code)
