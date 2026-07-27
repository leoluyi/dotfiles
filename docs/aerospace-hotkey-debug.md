# AeroSpace 快捷鍵失效調查

追蹤一個間歇性故障：AeroSpace 全域快捷鍵整組沒反應，重啟 AeroSpace 後恢復。

狀態：**等待故障重現以取得證據**（2026-07-27 起）。
升級後尚未重現。目前實際執行版本為 `0.21.2-Beta`（CLI 與 app 一致）。
已有兩次採證（07-27 18:38、07-28 00:04），皆屬誤報，真正原因都是 floating 視窗。

**先分流症狀**：目前兩次採證都不是本案，先排掉常見的那個再說。

1. 視窗排版怪、併不起來、看起來像兩組 —— 先查 `window-layout`，多半是 floating。
   `aerodiag` 現在會印這欄，直接看報告即可；命中就用下方的 `layout tiling` 修，
   不必重啟 AeroSpace。
2. 快捷鍵整組沒反應（按 `alt-z` 測，且 `alt-f` 也沒反應）—— 這才是本案。

## 症狀

`alt-h/j/k/l`、`alt-1..9` 等綁定全部沒反應。視窗停在原本排好的位置，其他一切正常。
重啟 AeroSpace 後恢復。

關鍵區分：這是 **global hotkey 子系統**的問題，不是 window tracking。
新視窗仍會被 tile、排版沒亂、`aerospace` CLI 仍可用 —— 只有按鍵進不去。

## 已排除

| 假設 | 排除依據 |
|---|---|
| Ghostty macOS native tabs 造成幽靈視窗 | 故障時是兩個獨立視窗，非同一視窗的兩個 tab |
| `macos-titlebar-style = hidden` 影響追蹤 | 症狀是按鍵失效，與視窗幾何無關 |
| TCC Accessibility 授權在升級後失效 | 授權正常，`list-windows` 一直有回應 |
| config 誤綁 `aerospace enable off` | config 內無任何 `enable` 綁定 |
| floating 視窗沒被列出 = 追蹤壞掉 | 誤判，但當初的排除理由也是錯的。詳見下方「floating 視窗的正確行為」 |

## floating 視窗的正確行為

先前這份文件寫「floating 視窗本來就不出現在 `list-windows`」——**這是錯的**。
floating 視窗會照常列出，`%{window-layout}` 欄位顯示 `floating`：

```sh
aerospace list-windows --all --format '%{window-id} | %{window-layout} | %{app-name} | %{window-title}'
```

`window-layout` 的實際取值包含 `floating`、`h_accordion`、`h_tiles`、
`macos_native_window_of_hidden_app`（app 被 cmd-h 隱藏）。
判斷一個視窗在不在 tiling tree 裡，要看這個欄位，不能看它有沒有被列出來。

## 待驗證的假設

依可信度排序。`aerodiag` 一次採集全部四項。

### 1. macOS Secure Input

某個 app 開啟 Secure Input 後未釋放，macOS 即禁止任何程式攔截 global hotkey。
本機跑著 1Password —— 已知會開啟 Secure Input 且偶爾不釋放。

**缺口**：Secure Input 是系統層狀態，重啟 AeroSpace 不會清除它，因此無法解釋
「重啟就好」。若報告顯示 Secure Input 為 ON，需進一步解釋這個矛盾
（例如重啟時其實伴隨了切換 app 的動作，而那才是真正解除的原因）。

### 2. sleep/wake 後 hotkey registration 掉失

本機長期不關機、頻繁進出 sleep。上游有 discussion 回報睡醒後 option 綁定失效。
`aerodiag` 會輸出最近的 sleep/wake 事件供對時間。

### 3. AeroSpace server main thread 卡死

`aerodiag` 用 5 秒 timeout 測 `list-windows`。若 timeout 即命中。

註：config 中 `alt-h/j/k/l` 使用 `exec-and-forget bash -c` 包裝，每次按鍵會
fork bash 並對 server 發兩次 CLI request。連按時有堆積可能。目前**刻意不動**，
以維持單一變因；若此假設命中再處理。

### 4. window management 被關掉

`aerodiag` 會用 `aerospace enable on --fail-if-noop` 當場測試並修復。
若報告顯示 "WAS DISABLED"，即為此因。

## 採證紀錄

### 2026-07-27 18:38 — 誤報，非本案

報告：`~/.local/state/aerodiag/20260727-183815.txt`

當下回報的症狀是「兩個 Ghostty 視窗認不得彼此、無法併成同一組」，不是快捷鍵失效。
`alt-z` 當場正常，四個假設全部落空：

| 假設 | 報告數值 |
|---|---|
| 1 Secure Input | `STATUS: OFF` |
| 2 sleep/wake | 16:29 啟動，17:22 / 17:27 / 17:33 三次睡醒 |
| 3 server 卡死 | `responsive` |
| 4 management 被關 | `already enabled (normal)` |

順帶排除輸入法佈局因素：`KeyboardLayout Name = ABC`。

真正原因是視窗 30412 處於 `floating`、32588 處於 `h_accordion`。floating 視窗不在
tiling tree 內，`join-with` 與 `move` 都併不進去，看起來就像兩個獨立的 manage group。
在各自視窗開的新視窗會走 `on-window-detected` 拿到 `layout tiling`，因此能與同組併起來。

修復（不需重啟 AeroSpace）：

```sh
aerospace layout tiling --window-id <window-id>
```

視窗如何變成 floating 未確認，兩個候選：

1. 誤按 `alt-f`（`aerospace.toml` 綁 `layout floating tiling`，純 toggle、無視覺回饋、
   位置緊鄰 `alt-h/j/k/l`）。
2. AeroSpace 16:29 重啟時 `on-window-detected` 的 race：catch-all 的 `layout floating`
   先跑，Ghostty 專屬的 `layout tiling` 後跑，若後者未生效即停在 floating。

無法從事後狀態區分這兩者。下次遇到，先記下是否剛重啟過 AeroSpace。

**原本的 hotkey 故障至今未重現。**

### 2026-07-28 00:04 — 同樣是 floating，非本案

報告：`~/.local/state/aerodiag/20260728-000459.txt`

回報「window management 又出問題」。四個假設同樣全部落空：Secure Input `OFF`、
server `responsive`、`already enabled (normal)`、`KeyboardLayout Name = ABC`。

真正狀態要另外查才看得到（當時的 `aerodiag` 沒印 `window-layout`，見下方變更）：

```
7065 | floating | Ghostty | ✳ Claude Code
7280 | floating | Ghostty | ✳ Hide Finder from Terminal workspace
7632 | h_tiles  | Ghostty | ⠐ Debug aerospace hotkeys failure
```

與 07-27 18:38 完全相同的失效模式：兩個 Ghostty 視窗掉出 tiling tree。

報告中 AeroSpace `etime` 為 `01:48:43`，即約 22:16 啟動，並且撐過了 23:25 睡、
23:33 醒的完整 sleep/wake 週期 —— 故障發生前沒有重啟過。

> **更正（同日 00:20）**：本段原本寫「因此排除候選 2（`on-window-detected` race），
> 只剩候選 1：誤按 `alt-f`」。**這個推論是錯的。**
> `on-window-detected` 是**每偵測到一個視窗就跑一次**，不是只在 AeroSpace 啟動時跑。
> 23:50 開的視窗照樣會跑一輪 callback chain，完全不需要重啟。
> 用「沒重啟」去排除一個不依賴重啟的機制是無效推論 —— 候選 2 從未被排除。

### 2026-07-28 00:20 — 症狀重新定性，候選 2 成為主嫌

使用者補充兩項關鍵資訊：00:04 那次的修復是**刻意**對所有視窗按一輪 `alt-f`，讓它們
float 再回到 managed；而且**「常常有些視窗自己就不受管理」**。

這否掉了誤按 `alt-f` 作為主因：誤觸解釋不了反覆發生、無人操作、且一次影響多個視窗的
漂移。`alt-f` 降為次要問題，鍵位暫不更動。

`layout` 的語意已向官方文件確認：

> If several `<target-layout>` are supplied, then the first one that doesn't
> describe the currently active layout is applied.

即 `layout floating tiling` 是嚴格兩態 toggle，按偶數次等於沒按 —— 所以「對所有視窗
按一輪」在數學上不可能把混亂狀態收斂到一致，必須逐一看狀態決定按幾次。

**真正的結構性成因在 config 的 callback 順序。** 原本的寫法（上游文件自己的範例）
讓每個終端機視窗的正確結果押在**兩個 callback 都成功**上：catch-all 先 float，
專屬規則再救回 tiling。第二步沒生效，視窗就停在 floating。兩次採證命中的都是
Ghostty，完全吻合。

已改為專屬規則在前（命中即停）、catch-all 在後，每個視窗只吃一條 callback，
沒有第二步可以失敗，行為等價。詳見 `aerospace.toml` 內的註解。

註：catch-all 必須寫 `if = 'true'`，不能省略 `if`——省略會被 AeroSpace 判為
error-prone 而拒絕載入設定。

**但這不保證修掉問題。** 若漂移其實發生在事後（unhide、sleep/wake 觸發重新偵測，
或某個機制把已 tiled 的視窗重設回 floating），改順序不會有幫助。官方文件**沒有**說明
重新偵測時會不會重跑 `on-window-detected`，而此機器 cmd-h 用得很兇 ——
00:04 的報告裡 7 個視窗有 4 個處於 `macos_native_window_of_hidden_app`。

要分辨「一出生就是 floating」與「本來好好的後來變了」，已加上 `aerospace-drift-log`，
見下方。這兩個答案指向完全不同的修法。

### 採證能力的已知盲點

`aerodiag` 現在會印 `window-layout`，但那只擋得住第一種失效模式。第二種 ——
視窗都是 `h_tiles` 卻分屬**不同 container**，即 07-27 描述的「兩個視窗併不起來」——
在報告裡看起來與健康狀態完全相同。

CLI 沒有暴露 tiling tree 結構，以下 placeholder 全部被拒絕：

```
tree / parent / container / node / window-container / parent-id
ERROR: Failed to parse <output-format>. Can't parse '...'
```

這是採證能力的硬上限。遇到「layout 都正常但就是併不起來」時，修法仍是對相關視窗
按一輪 `alt-f` 強制重新掛回 tree，或用 `join-with`。

版本註記：報告顯示 CLI 與 app 皆為 `0.21.2-Beta`，與本文件先前寫的 `0.21.3-Beta`
不符。已更正下方「已做的變更」。

## 漂移記錄器

`macos/.local/bin/aerospace-drift-log`，由 launchd 每 60 秒取樣一次。
只在**狀態改變**時寫入，所以日誌空白代表沒有漂移。

| 事件 | 意義 |
|---|---|
| `BORN_FLOATING` | 視窗第一次被觀察到就是 floating → callback race |
| `DRIFTED_TO_FLOATING` | 本來 tiled、後來變 floating → 事後被重設，附視窗存活秒數 |
| `RECOVERED_TO_TILED` | 變回 tiled（通常是手動修的） |
| `AEROSPACE_DOWN` / `QUERY_FAILED` | 取樣失敗，避免日誌空白被誤讀成「沒漂移」 |

只追蹤 config 歸類為 tiling 的三個終端機 app；其他 app 是 floating 屬設計如此，
不是異常。app 被 cmd-h 隱藏時 layout 讀到 `macos_native_window_of_hidden_app`，
會遮蔽真實狀態，因此視為**沒有觀測到**而非狀態轉換，以免產生假的 transition。

- 安裝：`scripts/macos/setup-aerospace-drift-log.sh`
- 日誌：`~/.local/state/aerospace-drift/drift.log`

判讀：收一兩天。若清一色 `BORN_FLOATING`，callback 順序的修改就是解答；
若出現 `DRIFTED_TO_FLOATING`，拿時間戳去對 `pmset -g log` 的 sleep/wake，
以及當下是否剛 cmd-h 過某個 app。

**這是臨時的調查用儀器，不是常駐服務。** 結論出來後照 setup 腳本開頭的說明移除。

## 故障時怎麼做

**先不要重啟 AeroSpace**，重啟會銷毀證據。在終端機執行：

```sh
aerodiag
```

報告存到 `~/.local/state/aerodiag/<時間戳>.txt`。

腳本位於 `macos/.local/bin/aerodiag`。

## 已做的變更

- 2026-07-27：AeroSpace `0.20.3-Beta` → `0.21.2-Beta`（跨一個 minor，該期間上游修過
  數個 AX 與 hotkey 相關問題）。若升級後不再重現，即無需再往下追。
  （本文件原記為 `0.21.3-Beta`，2026-07-28 對照 `aerospace --version` 後更正。）
- 2026-07-27：新增 `macos/.local/bin/aerodiag`。
- 2026-07-28：`aerodiag` 的 `list-windows` 加上 `--format`，輸出
  `window-id | workspace | window-layout | app-name | window-title`。
  兩次採證都因為報告沒有 `window-layout` 而看不出真正原因，必須事後另外查。
- 2026-07-28：`aerodiag` 結尾的提示語改為「aerospace window management issue shows
  again」——原本寫「hotkeys died again」，會讓實際上是 floating 的案例一開始就被
  導向錯誤的假設。
- 2026-07-28：`aerospace.toml` 的 `on-window-detected` 順序反轉 —— 專屬 tiling 規則
  移到前面（命中即停），catch-all `layout floating` 移到最後並補上 `if = 'true'`。
  這是本案第一次真正更動 `aerospace.toml`。
- 2026-07-28：新增 `macos/.local/bin/aerospace-drift-log` 與
  `scripts/macos/setup-aerospace-drift-log.sh`，已載入 launchd。
- 2026-07-28：`aerospace.toml` 遷移到 `config-version = 2`，消除載入時的警告。
  v2 唯一的破壞性變更是 `persistent-workspaces` 不再從 key binding 推導、改為
  fallback 空陣列；本 config 沒有任何 workspace 綁定（space 由 FlashSpace 管），
  推導值本來就是空的，所以此遷移不改變行為，也**不應**補上
  `persistent-workspaces`。與 floating 漂移無關，純粹清警告。
- `common_dotfiles/.config/aerospace/aerospace.toml` 未改動。

## 參考

- [AeroSpace #1486 — Add an indication when secure input is on](https://github.com/nikitabobko/AeroSpace/issues/1486)
- [AeroSpace Discussion #1205 — Alt key bindings stop working randomly](https://github.com/nikitabobko/AeroSpace/discussions/1205)
- [AeroSpace #732 — not registering key presses on letter keys](https://github.com/nikitabobko/AeroSpace/issues/732)
- [Ghostty: macOS Tiling Window Managers](https://ghostty.org/docs/help/macos-tiling-wms)
