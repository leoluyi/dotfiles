# 不停用 plugin，怎麼把自己的 skill 救回 auto-trigger

接續 [ecc-plugin-token-cost.md](./ecc-plugin-token-cost.md)。那份文件的結論是「停用 ecc」，
這份反過來問：**ecc 繼續開著**的前提下，還有哪些旋鈕真的能讓自己的 skill 被自動觸發。

調查日期 2026-07-28。環境：Claude Code `2.1.220`（build `4073f59`）、`model: opus`
（實際解析為 `claude-opus-5`）、`ENABLE_TOOL_SEARCH=true`。

方法：直接讀 `/opt/homebrew/Caskroom/claude-code@latest/2.1.220/claude`（native binary，
沒有 `cli.js`，用 `rg -a -o` 抓內嵌的 minified JS），再對照官方文件。
全程唯讀，沒有改動任何設定、skill 或 git 狀態。

本文所有數字都是本機量到的。演算法部分我用實測資料反推驗證過一次，**預測與本 session
實際收到的 skill listing 完全吻合**（見「驗證」一節）。

## 一句話結論

前一份文件說「使用者自己的 skill 全部只剩名字」——這個描述**偏悲觀**。實際上 28 個
listed 的 user skill 裡有 24 個保住了完整 description，只有 `review`、`tdd`、
`setup-pre-commit`、`autopilot` 四個掉了，而且**只差 41–80 個字元**。

原因是預算比前一份文件估的大 5 倍（1M context window，不是 200k），
所以問題不是「ecc 把預算吃光」，是「預算剛好在使用者清單的尾巴用完」。
最便宜的解法是把 char budget 加 2,000–4,000（約 +670–1,330 tok/turn），
或把那四個 skill 各叫用一次。

## 先修正前一份文件的兩個數字

| 前一份的說法 | 實際 | 依據 |
|---|---|---|
| 預算 ≈ 2,000 tok（200k × 1%） | **10,000 tok / 30,000 字元** | `claude-opus-5` 的 `context.window` 是 `1e6`、`native_1m: true` |
| 字元/token 用 4 換算 | **3** | `kC()`：只有 `isg` 白名單裡的舊 model 回 4，其餘回 3；`claude-opus-5` 不在名單內 |

model registry 那一行原文（binary）：

```js
"claude-opus-5",context:{window:1e6,native_1m:!0,supports_1m_beta:!0}
```

```sh
rg -a -o '"claude-opus-5",context:\{[^}]*' \
  /opt/homebrew/Caskroom/claude-code@latest/2.1.220/claude
```

這個修正很重要，因為它同時說明了一件事：**目前這套設定能運作，完全是靠 1M window。**
換回 200k model，預算掉到 6,000 字元，而光是所有 entry 的名字加保護區就要 15,792 字元
——**所有人的 description 會一起歸零**，包含 ecc 自己的。

## 真正的演算法

以下全部出自 binary，符號名是 minifier 產生的，但邏輯可逐行對照。

### 預算公式

```js
// 常數
var Wh_ = 0.01,    // skillListingBudgetFraction 預設
    sju = 4,       // bytesPerToken 的 fallback（只在沒帶 model 時用）
    Gh_ = 200000,  // context window 的 fallback
    Vh_ = 1536;    // skillListingMaxDescChars 預設

function ILt(){ return eo().skillListingMaxDescChars ?? Vh_ }
function zh_(){ return eo().skillListingBudgetFraction ?? Wh_ }

function DLt(e, t = sju){                                   // e = context window
  let r = fW(process.env.SLASH_COMMAND_TOOL_CHAR_BUDGET);
  if (r) return r;                                          // env var 直接覆蓋，不看 fraction
  let n = zh_();
  let o = (e ?? Gh_) * t * n;
  return Math.max(1, Math.floor(o));
}
```

```sh
rg -a -o 'function DLt\(e,t=sju\)\{.{300}' \
  /opt/homebrew/Caskroom/claude-code@latest/2.1.220/claude
```

也就是 **budget（字元）= contextWindow × bytesPerToken × fraction**。
本機：`1,000,000 × 3 × 0.01 = 30,000 字元`。

### 每筆 entry 的成本

格式在 `Jh_()`：完整是 `- ${name}: ${desc}`，被砍掉 description 後是 `- ${name}`。

| 狀態 | 字元成本 |
|---|---|
| 完整 | `len(name) + 4 + min(len(desc [- whenToUse]), skillListingMaxDescChars)` |
| 只剩名字 | `len(name) + 2` |
| 分隔 | 每兩筆之間 1 個 `\n` |

`OLt()` 決定 description 文字：有 `whenToUse` 時是 `${description} - ${whenToUse}`，
否則就是 `description`。1,536 字元的上限套在**合併後**的字串上，超過就截斷加 `…`（`Yh_()`）。

### 核心：`sbs()`（實際送給 model 的那份 listing）

```js
function sbs(e, t, r, n){          // e=skills, t=scoreFn, r=contextWindow, n=bytesPerToken
  if (e.length === 0) return "";
  let o = DLt(r, n);               // budget
  let i = new Set(), s = e.map((g,_) => {
    if (qFe(g) === "name-only") { i.add(_); return {cmd:g, full:`- ${g.name}`} }
    return {cmd:g, full: Jh_(g)}
  });
  let a = s.reduce((g,_) => g + Bt(_.full), 0) + (s.length - 1);
  if (a <= o) return s.map(g => g.full).join("\n");          // 塞得下就全給

  w(`Skill listing over budget: ${e.length} skills, ${a} chars > ${o} budget — descriptions
     will be truncated. Run /skills to disable some, or raise skillListingBudgetFraction in
     settings.`, {level:"warn"});

  let l = new Set(i);
  for (let g = 0; g < e.length; g++)
    if (e[g].type === "prompt" && e[g].source === "bundled") l.add(g);   // ← 保護名單

  let c = e.map((g,_) => _).filter(g => !l.has(g));          // 可被砍的
  let u = g => Bt(e[g].name) + 2;                            // 只剩名字的成本
  let d = g => Bt(s[g].full);                                // 完整成本
  let p = e.reduce((g,_,y) => g + (l.has(y) ? d(y) : u(y)), 0) + (e.length - 1);  // 地板
  let f = o - p;                                             // 可分配給 description 的餘額
  let m = new Set();
  c.sort((g,_) => t(e[_]) - t(e[g]));                        // 分數由高到低
  for (let g of c){
    let _ = d(g) - u(g);                                     // 這筆 description 的增量成本
    if (_ <= f) m.add(g), f -= _;                            // 塞得下就留，塞不下 → 跳過，繼續
  }
  return e.map((g,_) => l.has(_) || m.has(_) ? s[_].full : `- ${g.name}`).join("\n");
}
```

四個關鍵行為，官方文件都沒寫：

1. **`source === "bundled"` 的 skill 被完全保護。** Claude Code 內建的那批
   （`dataviz`、`claude-api`、`update-config`、`simplify`、`run`、`claude-in-chrome`…）
   不但不會被砍，還**優先佔掉地板成本**。本機這批是 6,054 字元，佔了 20% 的預算。
2. **greedy 迴圈不會 break。** 某筆 description 太大塞不下時，它被跳過，
   迴圈**繼續**看下一筆。所以到了預算尾聲，**短的 description 會贏過長的**，
   即使長的排在前面。這是本機四個 skill 掉描述的直接原因。
3. **輸出順序 = 原始載入順序**，不是分數順序。分數只影響「誰保得住 description」。
4. **每筆的 `- name` 是無條件成本**，`p` 這一行把它算進地板。名字不可能省掉，
   除非整筆從 listing 移除。

### 排序分數

```js
function uNt(e){
  let r = Rt().skillUsage?.[e];
  if (!r) return 0;
  let n = (Date.now() - r.lastUsedAt) / 86400000;   // 距上次使用的天數
  let o = Math.pow(0.5, n / 7);                     // 7 天半衰期
  return r.usageCount * Math.max(o, 0.1);           // 衰減下限 0.1
}
```

呼叫端把它綁在 `name` 上（不是 `unqualifiedName`）：

```js
content: sbs(a, (d) => uNt(d.name), c, kC(e.options.mainLoopModel))
```

```sh
rg -a -o 'function uNt\(e\)\{.{200}' \
  /opt/homebrew/Caskroom/claude-code@latest/2.1.220/claude
rg -a -o '.{160}sbs\(a,\(d\)=>uNt.{160}' \
  /opt/homebrew/Caskroom/claude-code@latest/2.1.220/claude
```

**score = usageCount × max(0.5^(days/7), 0.1)**。衰減有地板，所以
`usageCount ≥ 1` 的 skill 分數**永遠 > 0**，永遠排在從沒叫用過的 skill 前面。
23.25 天後（`0.5^(n/7) = 0.1`）衰減觸底，之後分數就固定在 `usageCount × 0.1`。

## 本機實際帳目

以 `~/.claude/settings.json` 的 `enabledPlugins` 為準，扣掉
`disable-model-invocation: true` 的項目：

| | entries | 名字（地板） | description |
|---|---:|---:|---:|
| ecc | 353 | 7,646 | 68,900 |
| **使用者自己** | **28** | **471** | **12,459** |
| superpowers | 14 | 487 | 1,889 |
| engineering | 10 | 259 | 2,552 |
| caveman | 8 | 176 | 2,497 |
| dx | 6 | 82 | 621 |
| 其他 plugin | 5 | 157 | 1,268 |
| user commands | 2 | 20 | 151 |
| bundled（受保護，全額計入地板） | 15 | — | 6,054 |
| **合計** | **441** | **9,298** | **96,391** |

ecc 這裡是 353 不是前一份文件的 363：差額來自 skill 與 command 同名的去重
（`sFt()` / `OT(...,"name")`）以及帶 `disable-model-invocation` 的項目。
未去重的原始數字是 363 entries、7,928 字元名字。

| 項目 | 字元 | tokens |
|---|---:|---:|
| budget（1e6 × 3 × 0.01） | 30,000 | 10,000 |
| 完全不截斷的 listing | 106,129 | ~35,376 |
| 地板（所有名字 + bundled 全文 + 分隔） | 15,792 | ~5,264 |
| **可分配給 description 的餘額** | **14,208** | **~4,736** |

使用者自己的 28 個 skill 需要 12,459 字元，餘額有 14,208 ——**光看使用者這邊是夠的**。
但 `superpowers`（5 個）、`engineering`（2 個）、`ecc`（2 個）、`frontend-design`、
`options` 這些 `score > 0` 的項目會**先**分掉約 2,600 字元，於是最後短了約 850。

### 為什麼掉的正好是那四個

greedy 走到 score 0 的區段時，順序是載入順序（user skill 字母序在最前面）。
餘額耗盡在字母序的 `r`–`t` 附近：

| skill | description | 增量成本 | 結果 |
|---|---:|---:|---|
| `research` | 238 | — | 留（score 0.997，早就處理過） |
| `resolving-merge-conflicts` | 中等 | — | 留 |
| `review` | 417 | **419** | **掉** |
| `rfp-writing` | — | — | 留（score 0.200） |
| `scaffold-exercises` | 204 | 206 | 留 |
| `setup-pre-commit` | 238 | **240** | **掉** |
| `tdd` | 149 | **151** | **掉** |
| `autopilot`（`~/.claude/commands/`） | 78 | **80** | **掉** |
| `claude-hud:setup` | 39 | 41 | **留** |

`claude-hud:setup` 排在 `autopilot` **後面**卻活下來，而 `autopilot` 只要 80 字元卻沒過
——這把最後餘額夾在 **[41, 80) 之間**。四個加起來只差 890 字元。

這也順帶證實了「greedy 不 break」和「短的贏」這兩個行為。

### 驗證

我把上面的演算法用 Python 重跑一遍，餵進本機真實的 `skillUsage` 和 frontmatter。
**所有 `score > 0` 的 17 個項目，預測結果與本 session 實際收到的 listing 逐一吻合**：

```
9.918 avoid-ai-writing-zh   3.998 options                1.894 superpowers:subagent-driven-development
1.887 frontend-design       1.618 superpowers:writing-plans
1.385 superpowers:brainstorming                          0.997 research
0.848 plain-speak           0.700 superpowers:using-superpowers
0.341 ecc:skill-create      0.286 ecc:strategic-compact  0.279 obsidian-vault
0.230 grilling              0.200 engineering:architecture
0.200 rfp-writing           0.100 superpowers:executing-plans
0.100 engineering:documentation
```

對照 `ecc:skill-create` 和 `ecc:strategic-compact` ——前一份文件觀察到「只有這兩個 ecc skill
保住 description」，這裡拿到了原因：它們是 ecc 裡唯二 `usageCount ≥ 1` 的。

## 兩個 budget 旋鈕（已驗證存在）

前一份文件提到但沒驗證的兩個 key，**都真的存在**，而且是有 schema 的正式 settings：

```js
skillListingMaxDescChars: E.number().int().positive().optional()
  .describe("Per-skill description character cap in the skill listing sent to Claude
             (default: 1536). Descriptions longer than this are truncated.
             Raise to opt in to higher per-turn context cost."),

skillListingBudgetFraction: E.number().gt(0).lte(1).optional()
  .describe("Fraction of the context window (in characters) reserved for the skill listing
             sent to Claude (default: 0.01 = 1%). When the listing exceeds this,
             descriptions are shortened to fit. Raise to opt in to higher per-turn
             context cost.")
```

```sh
rg -a -o 'skillListingMaxDescChars:E\.number.{400}' \
  /opt/homebrew/Caskroom/claude-code@latest/2.1.220/claude
```

官方 settings 文件也列了同樣的預設值
（[settings](https://code.claude.com/docs/en/settings)：`skillListingBudgetFraction`
**Default `0.01`**、`skillListingMaxDescChars` **Default `1536`**）。

第三個旋鈕是環境變數 **`SLASH_COMMAND_TOOL_CHAR_BUDGET`**，在 `DLt()` 的第一行，
**直接指定字元數並完全繞過 fraction 與 context window**。名字有誤導性，但它管的就是
skill listing 這份預算（[skills](https://code.claude.com/docs/en/skills)
也是這樣講的：「set the `skillListingBudgetFraction` setting … or the
`SLASH_COMMAND_TOOL_CHAR_BUDGET` environment variable to a fixed character count」）。

它比 fraction 好用的地方：fraction 會**跟著 context window 放大**，
在 1M model 上 `0.02` 就是 60,000 字元（20,000 tok），一次跳太多。
固定字元數可以精準加一點點。

代價換算（本機，3 字元 = 1 token）：

| 設定 | budget 字元 | 相對現況 | 效果 |
|---|---:|---:|---|
| 現況（`0.01`） | 30,000 | — | 四個 skill 掉描述 |
| `SLASH_COMMAND_TOOL_CHAR_BUDGET=32000` | 32,000 | +667 tok/turn | 剛好夠救回四個（差 890） |
| `SLASH_COMMAND_TOOL_CHAR_BUDGET=34000` | 34,000 | +1,333 tok/turn | 救回四個 + 3,000 字元緩衝 |
| `skillListingBudgetFraction: 0.02` | 60,000 | +10,000 tok/turn | 大量 ecc description 被灌進來 |
| 全部不截斷 | 106,129 | +25,376 tok/turn | ecc 的 68,900 字元全進 context |

**`0.02` 以上是反效果**：多出來的 30,000 字元有 90% 會被 ecc 的 353 個 score-0
description 吃掉（greedy 只看分數，不看來源），等於花 10,000 tok 買一堆用不到的
`ecc:kotlin-exposed-patterns`。要加就加剛好夠的量。

listing 是 system prompt 的一部分，第一輪之後會進 prompt cache，
所以 per-turn 成本是 cached input 而不是全價；但它照樣佔 context window。

## invocation count：最便宜、但零和的槓桿

### 存在哪裡

**`~/.claude.json` 頂層的 `skillUsage`**，全域、跨專案共用，沒有時間窗（永久累加）。
本機目前 43 筆：

```json
{
  "skillUsage": {
    "writing-great-skills": { "usageCount": 18, "lastUsedAt": 1785203392733 },
    "avoid-ai-writing-zh":  { "usageCount": 10, "lastUsedAt": 1785203852595 },
    "ecc:strategic-compact":{ "usageCount": 1,  "lastUsedAt": 1784118375150 }
  }
}
```

key 是 skill 的**完整 name**：plugin skill 用 `plugin:skill`，
使用者自己的用裸名。`lastUsedAt` 是 epoch millis。

### 怎麼被寫進去

```js
var RN_ = 60000;            // 60 秒
let sdd = new Map();

function Non(e){
  uIs.emit(e);
  let t = Date.now(), r = sdd.get(e);
  if (r !== void 0 && t - r < RN_) return;      // 同名 skill 60 秒內只記一次
  sdd.set(e, t);
  hr((n) => {
    let o = n.skillUsage?.[e];
    return {...n, skillUsage: {...n.skillUsage,
      [e]: { usageCount: (o?.usageCount ?? 0) + 1, lastUsedAt: t }}}
  })
}
```

`Non()` 在三條路徑上被呼叫：使用者打 `/name`、Skill tool 叫用、以及 skill 展開流程。
所以**打一次 slash command 就會記一次**。有 60 秒 debounce，不能靠迴圈灌。

```sh
rg -a -o 'function Non\(e\)\{.{300}' \
  /opt/homebrew/Caskroom/claude-code@latest/2.1.220/claude
```

### 一次叫用有多持久

因為 `Math.max(o, 0.1)` 這個地板，**叫用過一次的 skill 分數永遠 ≥ 0.1，永遠 > 0**。
而 ecc 的 353 個 skill 全部是 0。所以：

> 叫用一次，就永久排在所有沒叫用過的 skill 前面。不會過期。

分數隨時間的實際值（`usageCount = 1`）：

| 距上次使用 | 分數 |
|---|---:|
| 當天 | 1.00 |
| 7 天 | 0.50 |
| 14 天 | 0.25 |
| 21 天 | 0.125 |
| ≥ 23.25 天 | 0.10（觸底，不再下降） |

要拉高長期地板就得拉高 `usageCount`：叫用 5 次 → 長期分數 0.5。

### 可以手動 seed 嗎

可以。`~/.claude.json` 是純 JSON，`skillUsage` 就是上面那個結構，
補一筆 `{"usageCount": 5, "lastUsedAt": <now_ms>}` 效果等同叫用五次。

但這個檔案是 Claude Code 的 live state（85 個頂層 key），
執行中的 session 會整份覆寫回去。要改就在**沒有 session 在跑的時候**改，並先備份。
這條路不是官方介面，未來版本改結構就會失效。

> 我沒有實際寫入驗證（本次調查唯讀）。結構與讀取路徑是從 binary 確認的，
> 寫入行為是推論。

### 但它是零和的

這是最重要的但書。`skillUsage` 只重排優先序，**不會多出一個字元的預算**。
把 `review`、`tdd`、`setup-pre-commit`、`autopilot` 各叫用一次（+890 字元的需求提前），
就會有另外約 890 字元的 description 被擠掉——而被擠掉的是排在使用者清單尾巴的
其他自有 skill，不是 ecc（ecc 全在 score 0 且載入順序在後面）。

所以：**單用這招是在自己的 skill 之間搬椅子。** 要真的多救幾個，得配合下一節。

## 排序與 tie-break（原本的問題 3）

- **listing 的輸出順序 = 載入順序**，不排序。`sbs()` 最後一行是
  `e.map((g,_) => ...)`，原地映射。
- **分數只用在「誰保得住 description」的挑選**，用 `Array.prototype.sort`
  （ES2019 起保證 stable），所以**同分時維持載入順序**。
- 本 session 觀察到的載入順序是：
  **user skills（字母序）→ user commands → plugin skills（依 plugin 分組）→ bundled**。
- 因此在 score = 0 的大群裡，**使用者自己的 skill 確實排在所有 plugin skill 前面**，
  這是好消息：ecc 的 353 個 score-0 skill 搶不走使用者的 description，
  它們只吃掉名字的地板成本。
- 「使用者優先」不是程式碼裡的顯式規則，是載入順序 + stable sort 的**副作用**。
  這點要記住：它沒有被明文保證，未來版本調整載入順序就可能改變。

## 其他 surface 的誠實評估

### Slash commands（`~/.claude/commands/*.md`）——**不是出路**

它們**共用同一份 listing、同一份預算**，不是獨立通道。

證據有二。程式碼面，`a7e()` 這個「算不算 skill」的判定明確包含
`e.loadedFrom === "commands_DEPRECATED"`：

```js
function a7e(e){
  return e.type === "prompt" && !e.disableModelInvocation && !MTe(e) &&
    (e.source === "builtin" || e.loadedFrom === "bundled" ||
     e.loadedFrom === "skills" || e.loadedFrom === "commands_DEPRECATED" ||
     e.hasUserSpecifiedDescription || !!e.whenToUse)
}
```

實測面，使用者的兩個 command 都出現在本 session 的 skill listing 裡：
`options`（`usageCount: 3`，score 3.998）保住了 description，
`autopilot`（沒叫用過，score 0）掉了。同一套規則。

command 的 description 一樣會被 1,536 字元上限截斷，一樣會被整段砍掉。

### CLAUDE.md routing rules——**有效，而且不受預算管**

使用者的 `/Users/leoluyi/.dotfiles/CLAUDE.md` 已經有一段 `## Skill routing`。
這條路**確實可行**，理由是 CLAUDE.md 走 memory 通道進 system prompt
（[memory](https://code.claude.com/docs/en/memory)），**完全不經過 `sbs()`**，
沒有預算、沒有截斷、沒有分數排序。

它和 skill description 的差別：

| | skill description | CLAUDE.md routing |
|---|---|---|
| 進 context 的機制 | listing，有預算 | memory，無預算 |
| 會不會被砍 | 會 | 不會 |
| 觸發方式 | 語意比對 description 關鍵字 | 明文指令「看到 X 就叫 Y」 |
| 作用範圍 | 全域 | 寫在哪個 CLAUDE.md 就管哪裡 |
| token 成本 | 算在 30,000 預算裡 | 額外，但是固定且可控 |

現有那段約 700 字元 ≈ 233 tok，換掉四個掉描述的 skill（890 字元 ≈ 297 tok），
**比調 budget 划算**——因為它只付你列出來的那幾個的錢，不會順便替 ecc 買單。

務實的建議是：對「有明確觸發語」的 skill 用 CLAUDE.md 路由，
對「靠語意模糊比對」的 skill 留在 listing。前者本來就不需要完整 description。

代價：要手動維護，skill 改名或改用途時 CLAUDE.md 會失同步，而且沒有任何機制會提醒你。

### Subagents（`~/.claude/agents/*.md`）——**agent listing 確實沒有預算**

前一份文件的觀察是對的，這次在 binary 裡確認了。agent listing 的產生路徑：

```js
function fvd(e, t){
  let r = WW_(e);                                   // tools 字串
  let n = (t && e.whenToUseLean) || e.whenToUse;
  return `- ${e.agentType}: ${n} (Tools: ${r})`
}
// ...
return [{ type: "agent_listing_delta",
          addedTypes: c.map(p => p.agentType),
          addedLines: c.map(p => fvd(p, d)),  ... }]
```

**沒有任何 budget 呼叫、沒有截斷、沒有排序、沒有分數。** 每個 agent 的
`whenToUse` 全文照進 context。唯一的節制機制是 `/doctor` 的一則警告，
門檻 15,000 tokens，而且只是提醒、不會動手：

```js
var nPa = 15000;
function oPa(e){
  return e.activeAgents.filter(t => t.source !== "built-in")
    .reduce((t,r) => t + B_(`${r.agentType}: ${r.whenToUse}`), 0)
}
// { id:"large-agent-descriptions", tier:"warning",
//   isActive: e => oPa(e.agentDefinitions) > nPa,
//   render: ... "Agent descriptions are over the 15,000-token limit" ... }
```

```sh
rg -a -o 'function fvd\(e,t\)\{.{200}' \
  /opt/homebrew/Caskroom/claude-code@latest/2.1.220/claude
rg -a -o 'large-agent-descriptions.{300}' \
  /opt/homebrew/Caskroom/claude-code@latest/2.1.220/claude
```

所以「把 skill 改寫成 agent」**確實能保住完整 description**。但代價不小：

| | skill | subagent |
|---|---|---|
| 執行環境 | 主 context，直接照著做 | **獨立 context**，跑完只回傳摘要 |
| 能否延續對話 | 可以，內容留在 context | 不行，除非用 `SendMessage` 續談 |
| 叫用方式 | `/name` 或 Skill tool | Agent tool，`subagent_type` |
| 適合的內容 | 流程指引、寫作規範、review checklist | 可獨立完成並回報結果的任務 |
| 副作用 | 無 | 額外的 model 呼叫與 token |

判準很簡單：**skill 是「你照著做」，agent 是「他替你做完再回報」。**
`avoid-ai-writing-zh`、`plain-speak`、`tdd` 這類要在主 context 裡持續生效的，
改成 agent 會壞掉。`research`、`qa`、`code-review` 這種本來就是「丟出去做完回來」的，
改成 agent 反而更自然——事實上本機的 `research` skill 內容已經是「開一個 background agent」。

還有一個折衷：agent frontmatter 的 `skills:` 欄位可以把 skill **全文**預載進 subagent
（[sub-agents](https://code.claude.com/docs/en/sub-agents#preload-skills-into-subagents)：
「The full skill content is injected, not only the description」）。
這樣 skill 本體不動，只用 agent 的 `description` 佔一個不受預算管的觸發位。
注意：`disable-model-invocation: true` 的 skill **不能**被 preload。

### `SessionStart` / `UserPromptSubmit` hook 注入 skill index

技術上可行，兩個事件都支援 `hookSpecificOutput.additionalContext`
（[hooks](https://code.claude.com/docs/en/hooks)），binary 的 schema 也確認了：

```js
E.object({ hookEventName: E.literal("UserPromptSubmit"),
           additionalContext: E.string().optional(), ... }),
E.object({ hookEventName: E.literal("SessionStart"),
           additionalContext: E.string().optional(),
           initialUserMessage: E.string().optional(), ... })
```

上限 10,000 字元，超過會被寫到檔案只留 preview（hooks 文件明載）。

但**這是繞遠路**。官方文件自己就這樣講：

> For instructions that never change, prefer CLAUDE.md. It loads without running a script
> and is the standard place for static project conventions.
> — [hooks](https://code.claude.com/docs/en/hooks)

skill 索引正是「never change」的靜態內容。用 hook 注入的唯一好處是可以動態產生
（例如掃描 `~/.claude/skills/` 自動列出來，不用手動同步 CLAUDE.md），
代價是每個 session 多一次 process spawn，而且除錯困難。

`UserPromptSubmit` 比 `SessionStart` 更糟：它**每一輪**都注入，而且是接在 user message
後面而不是 system prompt，所以**吃不到 prompt cache**，每輪都付全價。
除非索引內容真的每輪都會變，否則沒有理由選它。

結論：**如果你已經願意手寫 CLAUDE.md routing，hook 只在你想自動產生索引時才有價值。**

### 縮短 skill 名字——**算過了，沒用**

名字是無條件成本，理論上縮短就能省。實際算一下：

| | entries | 名字成本 | 佔預算 |
|---|---:|---:|---:|
| ecc | 353 | 7,646 字元 | 25.5% |
| 使用者自己 | 30 | 491 字元 | 1.6% |

**ecc 佔了名字成本的 82%，而 plugin 的名字改不動。** 使用者這邊就算把 30 個名字
全部縮到 5 個字元，也只省 341 字元 ≈ 114 tok ——連四個掉描述的 skill 的一半都補不上，
還要付出「名字本身是 Claude 的匹配訊號」這個代價（`plain-speak` 比 `ps` 好認太多）。

**這條路不值得走。** 前一份文件把它列為可能方向，這裡正式否掉。

### `disableBundledSkills`——**能釋出 6,054 字元，但代價高**

bundled skill 在 `sbs()` 裡是受保護的，**全額計入地板**。本機這 15 個吃掉
6,054 字元 ≈ 2,018 tok，佔預算 20%，而且完全無法被砍。

`disableBundledSkills: true`（或 `CLAUDE_CODE_DISABLE_BUNDLED_SKILLS=1`）會把它們
整批從 registry 移除：

```js
function wG(e){
  return Z.CLAUDE_CODE_DISABLE_BUNDLED_SKILLS || (e ?? eo()).disableBundledSkills === !0
}
function LNs(){
  if (wG()) return HNs.filter(e => Ixd.has(e));   // 只留 survivesBundledKillSwitch 的
  return [...HNs]
}
```

binary 裡的 schema 說明：

> Disable the skills and workflows that ship with Claude Code: bundled skills and workflows
> are **removed entirely**; built-in slash commands stay typable but are hidden from the model.
> Plugins, `.claude/skills/`, and `.claude/commands/` are unaffected.

「removed entirely」是字面意思——`/simplify`、`/security-review`、`/run`、`dataviz`、
`claude-api`、`update-config`、`artifact-design`、`loop`、`schedule` 全部消失，
連手動叫用都不行。而使用者的 `skillUsage` 顯示 `simplify` 用過 **14 次**、
`update-config`、`security-review`、`dataviz`、`claude-api` 各用過 1 次。

**不建議。** 為了 2,000 tok 砍掉一個用了 14 次的 skill，划不來。列在這裡是為了完整。

### `skillOverrides` / `disable-model-invocation`——**對自己的 skill 有效，對 plugin 無效**

`qFe()` 第二行就把 plugin 擋掉了：

```js
function qFe(e){
  if ((e.type === "local-jsx" || e.type === "local") && uH_.has(e.name))
    return eo().skillOverrides?.[e.name] === "off" ? "off" : "on";
  if (e.type !== "prompt" || e.source === "plugin") return "on";   // ← plugin 一律 "on"
  let t = eo(), r = t.skillOverrides,
      n = r?.[e.name] ?? (e.unqualifiedName != null ? r?.[e.unqualifiedName] : void 0) ?? "on";
  if (Loo(e, t)) return n === "off" ? "off" : "user-invocable-only";
  return n
}
```

證實了官方文件那句「Plugin skills are not affected by `skillOverrides`」，
也就是 **ecc 的 353 個名字，7,646 字元的地板成本，完全無法迴避**。

對自己的 skill，四個狀態的實際效果：

| 值 | listing 裡的樣子 | 預算成本 | 還能 `/name` 嗎 |
|---|---|---:|---|
| `on`（預設） | `- name: desc` | 全額，且參與競爭 | 可以 |
| `name-only` | `- name` | 只有 `name + 2`，**不參與競爭** | 可以 |
| `user-invocable-only` | **完全不出現** | **0** | 可以 |
| `off` | 完全不出現 | 0 | 不行 |

`disable-model-invocation: true` 寫在 frontmatter，效果等同 `user-invocable-only`。
使用者已經在約 27 個 skill 上用了這招（抽查確認的有 `wizard`、`teach`、`handoff`、
`writing-great-skills`、`learn-loop`、`triage`），這也是為什麼 55 個 user skill
只有 28 個進 listing。**這一步做得很好，已經沒什麼可再擠的。**

注意 `name-only` 和 `user-invocable-only` 的差別比想像中小：前者還是要付
`name + 2` 的地板。想省最多就用 `user-invocable-only`。

## 排名建議

按「效果 ÷（token 成本 × 維護負擔）」排序。

### 1. 加一點點 char budget（首選）

```jsonc
// ~/.claude/settings.json
{
  "env": {
    "ENABLE_TOOL_SEARCH": "true",
    "SLASH_COMMAND_TOOL_CHAR_BUDGET": "34000"
  }
}
```

+4,000 字元 ≈ **+1,333 tok/turn**（第一輪後進 prompt cache），救回全部四個 skill
並留 3,000 字元緩衝。這是唯一**非零和**又不改任何 skill 內容的解法。

刻意不用 `skillListingBudgetFraction`：那個會跟 context window 放大，
在 1M model 上最小可用的調整（`0.011`）就是 +3,000 字元，而且換 model 時行為會跳動。
固定字元數比較好推理。

> 未驗證：`settings.json` 的 `env` 區塊寫入 `process.env` 的時機，是否早於第一次
> 建 system prompt。理論上是（env 在 session 啟動時套用），但我沒有實測。
> 驗證方式：`claude --debug` 後看有沒有那行
> `Skill listing over budget: ... > 34000 budget`。

### 2. 把該路由的 skill 寫進 CLAUDE.md（次選，可疊加）

零 listing 成本，不受預算管。使用者的 `/Users/leoluyi/.dotfiles/CLAUDE.md`
已經有 `## Skill routing` 區塊，補上掉描述的那幾個即可：

```markdown
- 要跑測試優先 / red-green-refactor / 寫測試再寫程式 → invoke tdd
- 設定 pre-commit hook / Husky / lint-staged → invoke setup-pre-commit
- 端到端自主執行一個任務 → invoke autopilot
```

（`review` 已經在原本的清單裡了。）

約 +150 字元 ≈ 50 tok，而且**只付你列出來的那幾個的錢**。
缺點是手動同步，skill 改名時不會有人提醒你。

### 3. 對掉描述的 skill 各叫用一次（免費，但零和）

```
/review
/tdd
/setup-pre-commit
/autopilot
```

每個之間隔 60 秒以上（`RN_` debounce）。四個各叫一次後分數各為 1.0，
會排到 greedy 的前段，**永久**（衰減地板 0.1）勝過所有沒叫用過的 skill。

但如果**只做這一步**，會有另外約 890 字元的自有 skill description 被擠掉。
搭配第 1 或第 2 項才有淨效益。

適合的用法是：**當作優先序的微調工具**，決定當預算真的不夠時要保住哪幾個。

### 4. 把「做完回報」型的 skill 改寫成 subagent（長期）

agent listing 沒有預算，完整 description 保證進 context。
但只適合本來就該在獨立 context 跑完再回報的工作。
本機的候選：`research`（內容已經是「開 background agent」）、`qa`、`code-review`。

或用折衷版：保留 skill 本體，另寫一個薄的 agent，frontmatter 用
`skills: [<skill-name>]` 把全文預載進去。

注意 `/doctor` 的 15,000 tok 警告門檻——ecc 已經帶了 67 個 agent，
本機大概已經很接近了。

### 5. 手動 seed `~/.claude.json` 的 `skillUsage`（不建議常規使用）

效果同第 3 項但可以一次設定多筆、也可以直接給高 `usageCount` 拉高長期地板。
代價是動 live state 檔、非官方介面、版本升級可能失效。
只有在「要一次校正十幾個 skill 的優先序」時才值得。

## 不會有用的做法（明確否決）

| 做法 | 為什麼不行 |
|---|---|
| 用 `skillOverrides` 把 ecc 的 skill 設成 `name-only` / `off` | `qFe()` 第二行 `if (e.source === "plugin") return "on"`，plugin 一律忽略 overrides |
| 縮短自己的 skill 名字 | 最多省 341 字元（1.1% 預算），還犧牲匹配訊號。名字成本 82% 在 ecc，改不動 |
| 把 skill 搬到 `~/.claude/commands/` | 同一份 listing、同一份預算、同一套截斷規則。實測 `autopilot` 就掉了 |
| `skillListingBudgetFraction: 0.02` 以上 | 多出的 30,000 字元約九成餵給 ecc 的 score-0 description |
| `disableBundledSkills: true` | 只釋出 6,054 字元，代價是失去用過 14 次的 `simplify` 等 |
| `disabledSkills` / `enabledSkills` settings key | **不存在**。settings schema 裡沒有這兩個 key |
| 靠拉長 description 塞更多關鍵字 | 反效果。greedy 在預算尾聲**偏好短的**，長 description 更容易被整段砍掉 |

最後一列值得展開：`review` 的 description 是 417 字元，是本機最長的自有 skill 之一，
**它掉描述的直接原因就是太長**。同區段的 `scaffold-exercises`（204 字元）活了下來。
如果把 `review` 的 description 壓到 200 字元以內，它很可能不用動任何設定就會自己回來。

這給出一條沒被列進上面排名、但成本最低的做法：**把長 description 修短**。
1,536 的上限不是目標值，是天花板。

## 未驗證項目

- `settings.json` 的 `env` 是否在建 system prompt 之前就套進 `process.env`。
  推論是，未實測。
- 手動編輯 `~/.claude.json` 的 `skillUsage` 是否會被 live session 覆寫。
  讀取路徑已從 binary 確認，寫入時序未測。
- bundled skill 那 15 筆的 6,054 字元，是把本 session 收到的 listing 逐行量出來的，
  不是從 binary 抽的。`dataviz` 和 `claude-api` 兩筆較長的用估值（1,178 / 1,300）。
  誤差應在 ±300 字元內，不影響任何結論。
- 「使用者 skill 的載入順序在 plugin 之前」是本 session 的觀察 + stable sort 的推論，
  binary 裡的 `nw()` / `YO()` 載入路徑沒有逐行追完。
- `source === "bundled"`（預算保護）與 `source === "builtin"`（`disableBundledSkills`
  在 `Loo()` 裡檢查的值）是兩個不同字串。兩者指涉的集合是否完全相同，未確認。

## 量測方式（之後複查用）

```sh
B=/opt/homebrew/Caskroom/claude-code@latest/2.1.220/claude

# 兩個 budget setting 的 schema 與預設值
rg -a -o 'skillListingMaxDescChars:E\.number.{450}' "$B"

# 預算公式
rg -a -o 'function DLt\(e,t=sju\)\{.{260}' "$B"
rg -a -o 'Wh_=0\.01,sju=4,Gh_=200000,Vh_=1536' "$B"

# 截斷演算法本體（含 bundled 保護、greedy 迴圈）
off=$(rg -a -b -o 'function sbs\(e,t,r,n\)' "$B" | head -1 | cut -d: -f1)
dd if="$B" bs=1 skip=$off count=1200 2>/dev/null

# 排序分數
rg -a -o 'function uNt\(e\)\{.{200}' "$B"

# usage counter 的寫入與 debounce
rg -a -o 'function Non\(e\)\{.{300}' "$B"

# skillOverrides 對 plugin 無效
rg -a -o 'function qFe\(e\)\{.{420}' "$B"

# agent listing 沒有預算，只有 /doctor 警告
rg -a -o 'function fvd\(e,t\)\{.{200}' "$B"
rg -a -o 'nPa=15000' "$B"

# 本機目前的 usage 排行
python3 -c "
import json, os, time
d = json.load(open(os.path.expanduser('~/.claude.json')))['skillUsage']
now = time.time() * 1000
def score(v):
    days = (now - v['lastUsedAt']) / 86400000
    return v['usageCount'] * max(0.5 ** (days / 7), 0.1)
for k, v in sorted(d.items(), key=lambda kv: -score(kv[1])):
    print(f'{score(v):8.3f}  {v[\"usageCount\"]:3d}x  {k}')
"
```

session 內用 `/context`（Skills 那一列是套過預算之後的實際值，v2.1.196 起才正確）
和 `/doctor`（會列出 listing 的最大貢獻者，以及 agent description 超過 15,000 tok 的警告）。
`claude --debug` 會在 listing 超支時印出那行 warning，含實際字元數與 budget，
是驗證任何調整最直接的方式。

## 參考

- [Claude Code — Extend Claude with skills](https://code.claude.com/docs/en/skills)
  （skill listing budget、`skillOverrides` 四態、1,536 字元上限、`SLASH_COMMAND_TOOL_CHAR_BUDGET`、
  `disable-model-invocation` 與 `user-invocable` 的差別）
- [Claude Code — Settings](https://code.claude.com/docs/en/settings)
  （`skillListingBudgetFraction` default `0.01`、`skillListingMaxDescChars` default `1536`、
  `disableBundledSkills`）
- [Claude Code — Subagents](https://code.claude.com/docs/en/sub-agents)
  （frontmatter 欄位表、`skills:` preload 語義與限制）
- [Claude Code — Hooks reference](https://code.claude.com/docs/en/hooks)
  （`hookSpecificOutput.additionalContext`、10,000 字元上限、
  「For instructions that never change, prefer CLAUDE.md」）
- [Claude Code — Memory](https://code.claude.com/docs/en/memory)
- `/opt/homebrew/Caskroom/claude-code@latest/2.1.220/claude`
  （symbols：`DLt` `sbs` `aju` `uNt` `Non` `qFe` `fvd` `oPa` `wG` `LNs` `a7e` `kC` `JE` `SZc`）
- `~/.claude.json` 的 `skillUsage`、`~/.claude/settings.json`
- [ecc-plugin-token-cost.md](./ecc-plugin-token-cost.md)（前一份調查）
