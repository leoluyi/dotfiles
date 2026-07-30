# `/autopilot` — 自主跑完整個 plan

Claude Code 的自訂 slash command。原始碼在
[`common_dotfiles/.claude/commands/autopilot.md`](../common_dotfiles/.claude/commands/autopilot.md)，
由 Stow 連結到 `~/.claude/commands/autopilot.md`。

本文記錄「按下去會發生什麼」，用來取代直接閱讀 345 行的 command 原始碼。
其中 `EnterWorktree` 的行為是實測結果（Claude Code `2.1.220`，2026-07-30）。

## 一句話

把整個 plan 交給 agent 跑到底：自己規劃、自己派工、自己修錯、自己驗證，
過關才 commit、push、開一個 ready PR，中途不回來問你。

## 何時用 / 何時不用

| 情況 | 建議 |
|---|---|
| plan 已經談定，你要離開電腦 | 用 |
| 工作有清楚的驗收標準（build / test / lint 會說話） | 用 |
| 方向還沒定、你想邊做邊看 | 不用，先談 |
| 需要動到 production 設定、credentials、已跑過的 migration | 不用，它會 hard stop |
| 你要它只做第一步 | 不用，它會做完整份清單 |

呼叫方式有兩種，差別會一路影響隔離決策：

```bash
/autopilot 把 X 改成 Y        # 有參數：這就是工作內容
/autopilot                     # 無參數：接續本對話已經談定的 plan
```

## 它暫時關掉的標準規則

`~/.claude/CLAUDE.md` 的這幾條在這次 run 期間失效：

- Plan First / 先討論再實作 / 確認對齊
- 詢問偏好、明列假設請你確認、遇到複雜度先問、發現架構問題先停下討論
- `/options` 那條「每個方向決定都先給你 2-4 個選項」
- Git History Protection 的 commit 前必問（CLAUDE.md 自己的 autonomous 例外條款）

**沒有**失效的：不留 TODO / FIXME、不把半成品報成完成、不用 emoji、
不寫死 secrets、immutable pattern、單檔 800 行以內、完整錯誤處理。

## 執行序列

1. **Scope** — 有參數就是工作內容；沒參數就接續本對話的 plan
2. **Recon** — 派搜尋 agent 去掃碼庫，回報結論而非檔案內容
3. **Plan** — 寫進 TodoWrite，每一項帶自己的檔案範圍
4. **Isolate** — 決定 branch / worktree（見下方決策樹）
5. **Build** — 依清單派工，每個 agent 回來都親自讀 diff
6. **Review & verify** — 見驗證 gate
7. **Ship** — commit、push、開 ready PR

## 委派模型

Orchestrator 模式：預設派 subagent，自己動手是要說服自己的例外。

| 留在主迴圈 | 派給 subagent |
|---|---|
| 任務拆解與 TodoWrite | 掃碼庫的 recon |
| 小型或跨檔案的修改（rename、簽名變動） | 單一 todo 項目的實作 |
| 整合、讀每個回傳的 diff | 修 build / test / type 錯誤 |
| 跑驗證 gate | 不可逆決策（用 opus） |
| **所有** git 與 `gh` 操作 | shipping 前的 review（用 opus） |

Subagent 永遠不 commit、不 push、不開 PR，這句要寫進每份 brief。

平行化的判準是**檔案範圍是否互斥**，不是急不急：範圍不重疊的 todo 在同一個訊息裡
一次發出去，重疊的排隊。講不出某個 todo 的檔案範圍，代表它還沒拆到可以派工。

`Agent` 呼叫上的 `isolation: "worktree"` 在這個 command 裡是**禁止**的——
worktree 從遠端預設分支切出去，看不到主迴圈尚未 commit 的編輯，
subagent 會對著過期的簽名和慣例寫程式，而且要到合併才會發現。

## 隔離決策樹

依序判斷，**第一個命中就停**：

| # | 條件 | 結果 |
|---|---|---|
| 1 | HEAD 在非預設 branch **且**無參數 | 留在原地繼續 commit |
| 2 | 已經在 worktree 裡 | 就地開 branch |
| 3 | 你說了 solo 或明示跳過隔離 | 就地開 branch |
| 4 | working tree 髒 | 就地開 branch |
| 5 | 工作依賴不在 `origin/<default>` 上的 commits | 就地開 branch |
| 6 | 以上皆非 | `EnterWorktree` |

規則 2 的偵測訊號有兩個：`git rev-parse --show-toplevel` 落在 `.claude/worktrees/`
底下，或 HEAD 在 `worktree-*` 上。規則 5 用
`git rev-list --count origin/<default-branch>..HEAD` 檢查。

### 為什麼規則 6 是預設

風險不對稱。兩個 session 同時 checkout 在同一個目錄，不是 merge conflict，
是同一個 HEAD、同一個 index 被無聲蓋寫，雙方都偵測不到。
白開一次 worktree 只賠一次裝依賴。

**併發與否由你決定，不是 agent 判斷**——它無法從 run 內部觀察你接下來會不會另開
session，所以不准從工作大小或檔案數量去推。你要它別隔離就在下指令時講。

### 規則 5 的陷阱

base ref 預設是 `fresh`，從 `origin/<default-branch>` 切。
最容易踩到的是**已經 push 的 feature branch**：它的 commits 不是 local-only，
但仍然不在 base ref 上。在那個狀態切 worktree，會在缺了前置工作的樹上開工，
而且不會有任何錯誤訊息，要到合併才發現。

### 不得為了湊條件而動手

不准 stash、不准把無關的工作 commit 掉來清乾淨 working tree、
不准為了讓 base ref 看得到而 push local commits。條件不成立就走 branch in place。

## 命名規則

兩條路徑共用 `<type>` 和 `<slug>`，但組裝方式不同：

| 路徑 | 傳入 / 指令 | 實際 branch |
|---|---|---|
| worktree | `EnterWorktree(name: "feat-token-refresh")` | `worktree-feat-token-refresh` |
| branch in place | `git switch -c feat/token-refresh` | `feat/token-refresh` |

- `<type>`：conventional commit 那組（feat, fix, refactor, docs, test, chore, perf, ci），
  讓 branch 名和之後落在它上面的 commits 對得起來
- `<slug>`：2-4 個 kebab-case 字，描述**結果**而非即將採取的動作
- worktree 路徑**不得含斜線**（原因見下節），長度控制在 40 字以內
- 不要自己加 provenance 前綴，`worktree-` 是自動加的，
  `git branch --list 'worktree-*'` 就是現成的清理把手
- 建立前先查碰撞（`git branch --list`，worktree 路徑再加 `git worktree list`），
  撞到就補 `-2`、`-3`
- **不准用時間戳解碰撞**——`date` 不在這個 command 的 `allowed-tools` 裡，
  會卡在權限提示上讓自主執行停擺

## `EnterWorktree` 實測行為

以下是實際跑出來的結果，不是推測：

**傳入的 name 不等於 branch 名。** 工具會自動加 `worktree-` 前綴，並把 `/` 換成 `+`：

```
EnterWorktree(name: "probe/naming-check")
  → 目錄: .claude/worktrees/probe+naming-check
  → branch: worktree-probe+naming-check
```

所以斜線階層式命名（`feat/xxx`）在 worktree 路徑上是拿不到的。

**同一個 session 不能開第二個。** 已經在 worktree session 裡再呼叫一次會被硬拒：

```
Already in a worktree session. Pass `path` to switch into another existing
worktree, or use ExitWorktree to leave this one before creating a new worktree.
```

**worktree 裡的 `--show-toplevel` 不是主 repo。** 這是規則 2 存在的原因——
從 worktree 目錄啟動的新 session 沒有 active worktree session，
工具不會拒絕，而路徑會解析到 worktree 自己：

```
git rev-parse --show-toplevel   → /Users/leoluyi/.dotfiles/.claude/worktrees/<name>
git rev-parse --git-common-dir  → /Users/leoluyi/.dotfiles/.git
```

`--git-common-dir` 指回主 repo，所以 refs 是共用的，
`git rev-list --count origin/main..HEAD` 在 worktree 裡也量得準。

**worktree 不會污染 `git status`。** 本 repo 的 `.gitignore` 第一行就是 `.claude/`。

base ref 由 `worktree.baseRef` 設定控制，預設 `fresh`（從 `origin/<default-branch>` 切），
另一個值是 `head`（從目前 local HEAD 切）。

## 驗證 gate

commit 之前有兩關，兩關都得過：

**Review** — 對完整 diff 平行派 review agent，至少一個正確性；
只要碰到輸入處理、auth、credentials、網路呼叫或持久化資料就再加一個 security。
這些用 `model: "opus"`。可以否決 review 的意見，但要在最終報告寫明否決了哪些、為什麼。

**Checks** — 專案自己的檢查必須綠燈，而且**主迴圈親自跑**。
去 `package.json` scripts、`Makefile`、`justfile`、`pyproject.toml`、CI workflow 找，
不要憑空假設。subagent 可以修，但它回報「修好了」不算過關，
你得親眼看到綠燈輸出——你無法稽核的 hard stop 不是 hard stop。

紅燈就不准 commit。不准帶著 caveat commit、
不准「先存起來免得工作丟了」、不准開了 PR 再在 body 裡提失敗。

## 自我修復的上限

**每個 blocker 三次嘗試**，且每次要建立在**不同假設**上。
計數是以 blocker 為單位而非 agent：subagent 回來說試過兩個假設，就只剩一次。
同一個修法換個寫法重跑不算一次嘗試，那叫迴圈，要立刻切掉。
subagent 掛掉或空手而回算用掉一次。第三個假設失敗，那個 blocker 就是 hard stop。

**不准繞過擋住你的東西**：不准刪或跳過失敗的測試、不准放寬型別、
不准擴大 exception handler、不准把 assertion 註解掉。
測試如果真的寫錯，就修測試並在摘要裡明講。

## Hard stops

只有這四種情況可以打破「不中斷」的前提。碰到就停，把樹留在一致狀態，
不 push、不開 PR：

1. 一個 blocker 撐過三次不同假設的修復
2. 驗證 gate 持續紅燈
3. 需要破壞性或不可逆操作——force-push、刪 branch、改寫歷史、
   動已經跑過真實資料的 migration、`rm -rf`、碰 production 設定或 credentials、
   任何伸出這個 repo 之外的動作
4. 發現安全問題或外洩的 secret——停下來回報，不准默默修掉包進 PR，
   沒有人 review 過的安全修補不算修補

清單以外的一切——模糊、非預期的複雜度、你不喜歡的設計、缺少的依賴、
不穩的測試、空手而回的 subagent——它自己處理，最後一併回報。

## 常見情境對照表

| 你的狀態 | 命中規則 | 會發生什麼 |
|---|---|---|
| 在 main，tree 乾淨，與 origin 同步 | 6 | 進 worktree |
| 在 main，有其他 branch，tree 乾淨 | 6 | 進 worktree（其他 branch 不是判斷輸入） |
| 在 main，tree 髒 | 4 | 就地開 branch，髒的變更跟著走 |
| 在 `feat/xxx`，無參數 | 1 | 留在 `feat/xxx` 繼續 commit |
| 在 `feat/xxx`（已 push），有參數，工作依賴它的 commits | 5 | 就地開 branch |
| 在 `feat/xxx`，有參數，工作不依賴它的 commits | 6 | 進 worktree |
| 在 `worktree-xxx` 裡，無參數 | 1 | 留在 `worktree-xxx` 繼續 commit |
| 在 `worktree-xxx` 裡，有參數 | 2 | 就地開 branch，不嵌套 |
| 你宣告 solo，tree 乾淨 | 3 | 就地開 branch |

## 最終報告會給你什麼

- 交付了什麼、PR 連結
- 送去 opus 的每個決策，含理由與被淘汰的方案
- 它單方面做的每個假設
- review 的發現，以及它否決了哪些
- 驗證結果
- 刻意排除在範圍外的東西
- 用了 worktree 的話，worktree 路徑
- 委派軌跡：哪些 agent 跑了什麼、回傳了什麼，讓這次 run 事後可稽核
