# AeroSpace 快捷鍵失效調查

追蹤一個間歇性故障：AeroSpace 全域快捷鍵整組沒反應，重啟 AeroSpace 後恢復。

狀態：**等待故障重現以取得證據**（2026-07-27 起）。
升級後尚未重現。目前實際執行版本為 `0.21.2-Beta`（CLI 與 app 一致）。
已有四次採證（07-27 18:38、07-28 00:04、07-28 07:27、07-30 11:53），皆屬誤報，
真正原因都是 floating 視窗。

**floating 漂移已升格為獨立的主線問題**，而且它不是本文件原本追的 hotkey 案。
目前確定的是：視窗**先 tiled、後來才變 floating**（漂移記錄器 31:0 壓倒性，
新 callback 順序上線後又累積 6 筆，仍是 `BORN_FLOATING` 掛零）。
已被實測排除的機制：出生時的 callback race、FlashSpace 的 hide/show、sleep/wake、
`enable off`、標題變動觸發 re-detection、`alt-f` 誤按、`alt-z`（fullscreen）。
唯一還活著的假設是負載 —— 但形狀已在 07-30 修正過一次：不是「Ghostty 忙到 AX 逾時」，
而是**整台機器飽和把 AeroSpace 餓死**（漂移當下 Ghostty 與 AeroSpace 都是閒的）。
07-30 11:41 首次抓到 loadavg **82.72**；07-28 那場實驗只推到 8.28，且施力點打在 Ghostty，
現在知道那是打錯地方。

**負載假設仍有一個反例**：07-29 23:18:14 的漂移 loadavg 只有 2.91。所以要嘛不只一個機制，
要嘛負載只是加速因子。回溯日誌已榨乾（unified log 不記 CPU 歸屬也不記 AeroSpace 內部狀態），
下一步只能靠 07-30 上線的取樣序列做相關性統計，見下方「漂移記錄器」。

**先分流症狀**：四次採證全都不是本案，先排掉常見的那些再說。

1. **前景有系統驗證對話框**（密碼框、`SecurityAgent`）—— 它獨占鍵盤，所有 hotkey 全死，
   與 AeroSpace 無關。`aerodiag` 會示警。關掉對話框重測，不要往下追。
2. 視窗排版怪、併不起來、看起來像兩組 —— 先查 `window-layout`，多半是 floating。
   `aerodiag` 現在會印這欄，直接看報告即可；命中就用下方的 `layout tiling` 修，
   不必重啟 AeroSpace。**四次採證都是這一類。**
3. 快捷鍵整組沒反應（按 `alt-z` 測，且 `alt-f` 也沒反應），且前景沒有對話框 —— 這才是本案。

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

**缺口已於 2026-07-30 補上，答案是括號裡那個。** 真正的 hotkey 殺手不必是 Secure Input，
一個**系統模態驗證框**就夠了：`SecurityAgent` 在前景時獨占鍵盤，所有 global hotkey 全死，
而 Secure Input 可以完全是 `OFF`。它同時解釋了「重啟 AeroSpace 就好」—— 你為了重啟
必然先點了別的視窗，那個動作才是解除的原因，重啟只是附帶發生。

`aerodiag` 現在會在前景是 `com.apple.SecurityAgent` / `loginwindow` / `ScreenSaver` 時明確示警。
**看到示警就先關掉對話框重測，不要當成 AeroSpace 的錯。**

註：`kCGSSessionSecureInputPID` 這個 key 在 Secure Input 關閉時**根本不存在**於 `ioreg` 輸出，
所以歷次報告的 `OFF` 是可信的陰性，不是取樣缺陷。

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

### 2026-07-28 07:27 — 第三次採證，同樣是 floating

報告：`~/.local/state/aerodiag/20260728-072701.txt`

四個假設第四度全部落空：Secure Input `OFF`、server `responsive`、
`already enabled (normal)`、`KeyboardLayout Name = ABC`。這次報告已含 `window-layout`，
一眼就看得到真正狀態：

```
9536 | 1 | floating     | Ghostty | ⠂ Merge PR and delete feature branch
9902 | 1 | h_accordion  | Ghostty | ~/.skills
9912 | 1 | h_accordion  | Ghostty | aerodiag
```

9536 自 03:47:54 起 floating，撐到 07:27 仍是 floating —— 這是唯一一筆「單一視窗、
沒有回復、長時間停留」的漂移。CotEditor 與 Chrome 的 floating 屬設計如此，不是異常。

### 2026-07-28 21:30 — 全面複查，三個機制被實測排除

#### 最重要的一件事：00:24 的修正從來沒有生效過

**AeroSpace 不會自動重載 config**。實測方式：在 `~/.config/aerospace/aerospace.toml`
加一個 `alt-ctrl-shift-f12` 綁定，16 秒後查詢執行中的 server：

```sh
aerospace config --get mode.main.binding --json   # 看不到新綁定
```

而 AeroSpace 進程自 **2026-07-27 22:16:16** 起未曾重啟（`ps -o lstart=`），config 檔是
00:24 才改的。所以 **01:21 之後蒐集到的所有漂移證據，都是舊 config（catch-all float 在前
+ 專屬規則 rescue）產生的**，`on-window-detected` 反轉順序這個修正等於還沒上場。
2026-07-28 21:28 已執行 `aerospace reload-config`，新順序自此才真正生效。

註：`aerospace config --get` 只讀得到 `mode` 子樹（`config --major-keys` 的輸出只有
`.`、`mode`、`mode.*.binding`）。所有 scalar key 與 `on-window-detected` 都回
`No value at key token '...'`，**這不代表該設定不存在**，別拿它當「config 沒載入」的證據。
判斷是否重載過，只能靠 `mode.*.binding` 的內容差異。

#### 漂移記錄器的判決：31 筆全是 DRIFTED，0 筆 BORN_FLOATING

```
31 DRIFTED_TO_FLOATING / 30 RECOVERED_TO_TILED / 0 BORN_FLOATING
 0 QUERY_FAILED        /  0 AEROSPACE_DOWN
```

視窗一律先 tiled、後來才變 floating。**候選 2（出生時的 callback race）在舊 config 下
就已經不是觀察到的失效模式**——順序反轉即使是對的寫法，修的也不是這件事。

時間分布：全部集中在 01:21–03:47，之後到 21:29 為止 17.5 小時一筆都沒有（期間機器多半
在睡，且 9902/9912 全程維持 tiled）。

#### 被實測排除的三個機制

| 假設 | 實驗 | 結果 |
|---|---|---|
| FlashSpace 的 hide/show 觸發重新偵測，重跑 callback chain 時掉進 race | 手動 `layout floating --window-id 9912` → 隱藏 Ghostty → 取消隱藏 | 仍是 `floating`。**unhide 不會重跑 `on-window-detected`**；舊 config 若重跑，rescue 那步會把它拉回 tiling。這條路斷了 |
| `aerospace enable off` 讓視窗被回報成 floating | 當場 `enable off` 再查 list-windows | server 直接拒絕回應（`AeroSpace server is disabled and doesn't accept commands`），**不是**回報 floating。漂移期間日誌沒有任何 `QUERY_FAILED`，所以當時管理沒被關掉 |
| sleep/wake 掉失 | 對 `pmset -g log` | 01:21–03:47 全部漂移期間**沒有任何 sleep 事件**，第一次 sleep 是 03:57。時間對不上 |

順帶確認：隱藏中的視窗確實回報 `macos_native_window_of_hidden_app`，漂移記錄器把它當
「沒有觀測到」的處理是對的。

#### 開放問題

一度懷疑這 31 筆其實是使用者自己按 alt-f 的修復動作被記下來（60 秒取樣分不出「同時發生的
事件」與「5 秒內對三個視窗各按一次」，而 `layout floating tiling` 是嚴格 toggle，對已 tiled
的視窗按一輪就是全部變 floating）。**使用者已確認可以排除 alt-f**，所以漂移是自發的。

那麼剩下的問題是：成對出現的 `RECOVERED_TO_TILED`（多數在 1–2 分鐘後）是人工修的，
還是它自己回去的？若也是自發，代表這不是單向漂移而是**來回震盪**，那就要往
「AeroSpace 在某些過渡狀態下短暫回報 floating」這個方向查，而不是「有東西把視窗 float 掉」。

### 2026-07-28 22:05 — detection 探針：假設 B 出局，而且出現矛盾

在 `on-window-detected` 最前面插一個純記錄的 callback（`check-further-callbacks = true`，
行為不變），量測 detection 實際觸發頻率。**`exec-and-forget` 在 0.21.2 的
`on-window-detected` 裡是合法的**，`reload-config` 接受。

```toml
[[on-window-detected]]
if.app-id = 'com.mitchellh.ghostty'
check-further-callbacks = true
run = ['''exec-and-forget bash -c 'printf "%s\t%s\n" "$(date +%T)" "${AEROSPACE_WINDOW_ID:-unknown}" >> ~/.local/state/aerospace-drift/detect.log' ''']
```

| 條件 | 結果 |
|---|---|
| 60 秒正常運作（兩個 Ghostty 視窗跑著 Claude Code，標題持續變動） | **0 筆** |
| 開一個新 Ghostty 視窗（陽性對照） | **2 筆**，帶新的 window-id |

`on-window-detected` **只在真正的新視窗觸發，不會因為標題變動重跑**。探針本身有效
（陽性對照有反應），所以 0 筆是真的 0 筆。**「標題變動觸發 re-detection」這條假設出局。**
探針已於量測後移除，config 與 repo 版本一致。

#### 由此產生的矛盾

AeroSpace 沒有任何機制會把 floating container 裡的視窗自己搬回 tiling tree，唯一會做這件事
的是 `on-window-detected` 命中 `layout tiling`。但現在確認 detection 不會重跑，而 alt-f
與腳本都已排除 —— **那 29 筆 `RECOVERED_TO_TILED` 就沒有任何已知的成因**。

最省事的解釋是：**那些成對的 drift/recovery 根本不是真的漂移，而是 `list-windows` 在某些
瞬間把 tiled 視窗回報成 `floating` 的觀測假象。** 這也解釋了為什麼多數漂移發生時你並沒有
回報畫面壞掉。

但這不能解釋全部。9536 那筆（03:47:54 漂移、沒有回復、07:27 採證時仍是 floating，而且你
確實看到視窗排版壞了）是真的。**所以日誌裡混了兩種東西**，而目前無法自動區分。

下一步要驗的是假象假設：用 200ms 之類的高頻取樣跑一段時間，看 `floating` 是否會在完全沒有
任何事件的情況下閃現一兩次又消失。若會，10 秒取樣的日誌就必須整批重新解讀，只有「持續
floating 超過 N 次取樣」才算數。

#### 高頻取樣：兩輪都是空的，取樣器已退場

200ms 取樣器（一次性工具，沒有進 repo）跑了兩輪，記錄每次 transition 並附上
「前一個狀態撐了幾個 sample」，用來分辨閃現與真漂移：

| 輪次 | 條件 | 樣本 | transition | query failure |
|---|---|---|---|---|
| 21:53–22:13 | 機器閒置 | 4381（3.7 Hz） | **0** | 0 |
| 22:51–22:54 | 下方的負載實驗期間 | — | **0** | 0 |

兩輪都命中「完全沒有 transition」這格，也就是**這兩段時間根本沒事發生**，
觀測假象假設既沒被證實也沒被推翻。實測頻率只有 3.7 Hz（270ms/次），
因為每次取樣都要 spawn 一次 `aerospace` CLI，要抓 200ms 級的閃現已在解析度邊緣。

取樣器已刪除。要重驗假象假設，得挑一段**確定會漂移**的時段再架一次，
在漂移不可預測之前，繼續掛著只是白燒 CPU。

### 2026-07-28 22:51 — 負載觸發實驗：陰性，但曝露不足

主流假設是「Ghostty UI thread 忙到 AX 查詢逾時 → AeroSpace 把視窗重判為不可 tile」，
因為那是唯一符合證據形狀的機制：31 筆漂移每次都同時打到 3–4 個 Ghostty 視窗，
沒有 sleep/wake、沒有使用者操作。與其守株待兔，直接製造負載試著重現。

負載必須打在**可見的** Ghostty 視窗上：隱藏或在別的 workspace 的視窗不 render，
UI thread 是閒的，AX 路徑完全沒被壓到。腳本是 `aero-load-probe.sh`
（一次性工具，沒有進 repo），4 個 CPU burner ＋ 2 個持續高吞吐輸出的 Ghostty 視窗。

| 項目 | 數值 |
|---|---|
| loadavg | 2.59 → **8.28**（8 核） |
| 曝露時間 | 22:51:33–22:53:53，**140 秒** |
| 200ms 取樣器 transition | 0 |
| 漂移記錄器事件 | 0 |

**這不算推翻負載假設**，兩個理由：

1. 140 秒太短。歷史上 31 筆漂移分散在 2.5 小時、間隔 10–40 分鐘，這種頻率下抽不到很正常。
2. 更重要的是**關鍵條件沒達成**。trace 顯示 AeroSpace 全程 6–37%、Ghostty 5–42%，
   兩個進程都沒滿載 —— loadavg 8 是 burner 撐起來的，不是 Ghostty。負載打錯地方了。

要再試，得拿掉 spew 的節流改成連續高吞吐輸出，把 Ghostty 單一進程壓到 100% 以上，
並且跑 20 分鐘以上。目前這條路線暫時擱置。

### 2026-07-28 23:05 — alt-z（fullscreen）假設出局，但撿到一個真行為

新假設：某個 Ghostty 視窗用 `alt-z` 放大很久之後，tiling 就壞掉。
`alt-z = 'fullscreen'`，是 AeroSpace 自己的 fullscreen，config 內沒有
`macos-native-fullscreen` 的綁定。實測四條路徑：

| 實驗 | `window-layout` | `window-is-fullscreen` |
|---|---|---|
| `fullscreen on` | `h_accordion`（不變） | false → **true** |
| fullscreen 期間開新視窗 | `h_accordion` | true → **false**（自己掉了） |
| fullscreen ＋ 切 workspace 再切回 | `h_accordion` | true → **false**（自己掉了） |
| fullscreen ＋ hide/unhide | `h_accordion` | true → **false**（自己掉了） |

**`window-is-fullscreen` 與 `window-layout` 完全正交，任何路徑都沒有產生 `floating`。**
所以 fullscreen 不可能讓視窗掉出 tiling tree，漂移記錄器把它歸進 `tiled` 也沒有被騙
—— 過去 31 筆的解讀不需要重來。

反過來說，既然新視窗、切 workspace、unhide 三種日常操作都會清掉 fullscreen，
「長時間維持放大」這個前提在這台機器的使用模式下幾乎不成立，假設本身也被削弱。

註：實測的是**轉換**，不是「真的放大好幾小時」。但要維持數小時 fullscreen，
只有完全不動桌面才做得到。

#### 撿到的真行為：fullscreen 會被默默清掉

AeroSpace 遇到新視窗誕生、workspace 切換、unhide，都會無聲地把 fullscreen 旗標清掉
（之後再下 `fullscreen off` 會回 `Already not fullscreen`）。
**「放大的視窗自己縮回去」不是 bug 也不是漏按，是這個行為。** 不影響 tiling，
但會讓人誤以為 `alt-z` 沒生效。

### 2026-07-30 11:53 — 第四次採證：負載假設復活，且形狀被修正

報告：`~/.local/state/aerodiag/20260730-115345.txt`

症狀經分流確認是**只有排版壞掉、快捷鍵正常**，第四度落在 floating 主線，
原本的 hotkey 案至今仍未重現。四個舊假設同樣全部落空
（Secure Input `OFF`、`responsive`、`already enabled (normal)`、`KeyboardLayout Name = ABC`）。

報告可見 `52 | 1 | floating | Ghostty`，而 `drift.log` 指出它 11:41:07 漂移、
到 11:53 採證時已持續 12 分鐘。這是新 callback 順序上線後**第一份「持續性漂移」的現場 AX 快照**。

#### 決定性的一行在 AX dump 的表頭：loadavg

| 漂移時刻 | loadavg（8 核） | 結果 |
|---|---|---|
| 07-29 22:19:50 | 9.37 / 29.74 / 17.00 | 10 秒後回復 |
| 07-29 23:18:14 | 2.91 / 4.22 / 3.67 | 未回復 |
| 07-30 10:41:10 | 4.21 / 6.91 / 10.87 | 5 分後回復 |
| **07-30 11:41:07** | **82.72 / 72.11 / 42.71** | 持續 12 分鐘以上 |
| CONTROL（健康對照） | 2.93 / 2.50 / 2.67 | — |

82.72 是 8 核超訂 10 倍。07-28 那場實驗只推到 8.28 就收工，結論寫「曝露不足，不算推翻」
—— 現在知道當時距離真實量級差一個數量級。

**更重要的是施力點錯了。** 這筆 dump 裡 Ghostty 只有 0.8% CPU、AeroSpace 0.0%，
兩個當事進程都是閒的。所以機制不是「Ghostty UI thread 忙到 AX 逾時」，
而是**整台機器飽和把 AeroSpace 的 AX／IPC 往返餓死**。07-28 把負載打在 Ghostty 身上，
方向本來就不對。

負載來源已由使用者確認：**多個 Claude Code session 並行 fan-out ＋ 同時開著 System Settings**。
日誌吻合 —— 11:38–11:39 有 spawn 爆量（23、40 筆/分），內含 System Settings 的一整排
extension controller（`systemsettingsagent`、`SettingsSystemExtensionController`、
`LegacyPluginEnablement`、`FSKitModuleManagement` 等）與 20 個 `mdworker_shared`，
爆量結束約 2 分鐘後漂移。兩個來源都可控、可重現。

#### AX 屬性與健康對照組逐項相同

| 欄位 | 漂移的 52 | CONTROL |
|---|---|---|
| `subrole` | `AXStandardWindow` | `AXStandardWindow` |
| `AXFullScreen` | 0 | 0 |
| `AXMinimized` | 0 | 0 |
| `AXModal` | 0 | 0 |
| `Aero.AxFailed` 筆數 | 6 | 6 |

**視窗在 macOS 眼中完全健康。** 所以不是「AeroSpace 依 AX 屬性把視窗重判為不可 tile」，
是 AeroSpace 自己的模型翻掉了。注意 dump 是在偵測到漂移後幾秒才抓的，
漂移瞬間的短暫 AX 失敗不會留在這份快照裡 —— 這條推論排除的是「持續性的 AX 異常」，
不是「瞬時 AX 逾時」。

#### 尚未解釋的反例

07-29 23:18:14 那筆 loadavg 只有 2.91，卻同時打到 62 與 641 兩個視窗且沒有回復。
該時段確實有 spawn 爆量（23:13 有 58 筆/分、23:15 有 38 筆），但 **CPU 沒有飽和**。
純 CPU 餓死解釋不了這一筆。

#### SecurityAgent 是干擾項，不是本次成因

報告的 `Frontmost app` 是 `com.apple.SecurityAgent`（pid 6044），前所未見。查證結果：

- 11:53:29.848 由 `authd` 觸發，right 是 `system.privilege.admin`（管理員密碼框），
  `credential 501 expired '5330.973881 > 300'`，即 sudo 憑證過期後的重新驗證。
- 與 System Settings 那波活動一致（使用者確認當時開著）。

**時間對不上本次漂移**：對話框 11:53:29 才出現，漂移是 11:41:07，晚了 12 分鐘。
所以它不是成因。但它本身是一個貨真價實的獨立 hotkey 殺手，並且補掉了假設 1 的缺口
（見上方「假設 1」那節）。這是本次採證最有價值的副產品。

#### 週期性：目前不算線索

10:41:10 與 11:41:07 只差 3 秒不到一小時，看起來有週期。但 07-28 那 19 個時間點
（01:21–03:47，間隔 10–40 分鐘）完全沒有這個規律，而已知的整點 launchd job 只有
`com.dropbox.DropboxUpdater.wake` 與 `com.google.GoogleUpdater.wake`（皆 `StartInterval 3600`），
兩者都是輕量喚醒。**先當巧合處理，除非取樣序列裡再看到同樣的間距。**

順帶排除 Time Machine：`tmutil latestbackup` 回 `Failed to mount destination`，備份目的地根本掛不上，
不可能是整點負載來源。

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

`macos/.local/bin/aerospace-drift-log`，由 launchd 每 10 秒取樣一次，寫兩份東西：

| 檔案 | 寫入時機 | 用途 |
|---|---|---|
| `drift.log` | 只在**狀態改變**時 | 日誌空白代表沒有漂移 |
| `samples/<日期>.tsv` | **每次取樣**都寫 | 負載相關性的分母 |

### 為什麼需要 samples 序列

`drift.log` 與 AX dump 只回答「漂移那一刻負載多少」。**光靠這個永遠無法證實或推翻負載假設**
—— 漂移時 loadavg 82 不代表什麼，如果這台機器一天有一半時間都在 82。
要算的是 `P(漂移 | 負載區間)`，那需要非漂移時的負載基線，也就是分母。

欄位：`epoch`、`stamp`、`load1`、`load5`、`load15`、`status`、`tiled`、`floating`、`unobservable`。

`status` 為 `ok` / `aerospace_down` / `query_failed`。**`query_failed` 特別重要**：
進程活著但查詢回空，正是負載假設預測的餓死訊號，把它與當下負載並排記錄才對得起來。

一天一個檔（10 秒間隔約 8600 行、500 KB），不做輪替 —— 這是臨時儀器，
收工就 `rm -rf samples/`。

判讀方式（收滿一兩天再做，樣本不足算不出東西）：

```sh
# 按 load1 分桶，看每桶的漂移取樣佔比
awk -F'\t' '$6=="ok" { b=int($3/10)*10; n[b]++; if ($8>0) d[b]++ }
            END { for (k in n) printf "load %3d-%3d  samples=%-6d floating=%-5d %.2f%%\n",
                  k, k+9, n[k], d[k]+0, (d[k]+0)*100/n[k] }' \
  ~/.local/state/aerospace-drift/samples/*.tsv | sort -n
```

負載假設要成立，高負載桶的百分比必須明顯高於低負載桶。若各桶差不多，
82.72 那筆就只是巧合，得回頭找別的機制 —— 07-29 23:18 的 2.91 反例已經在暗示這個可能。

| 事件 | 意義 |
|---|---|
| `BORN_FLOATING` | 視窗第一次被觀察到就是 floating → callback race |
| `DRIFTED_TO_FLOATING` | 本來 tiled、後來變 floating → 事後被重設，附視窗存活秒數 |
| `RECOVERED_TO_TILED` | 變回 tiled（通常是手動修的） |
| `AEROSPACE_DOWN` / `QUERY_FAILED` | 取樣失敗，避免日誌空白被誤讀成「沒漂移」 |

每筆事件都附上當下的 `window-is-fullscreen` 與**前一次取樣**的值。fullscreen 不會
造成漂移（見上方 23:05 那則），但 AeroSpace 會在新視窗、切 workspace、unhide 時默默
清掉這個旗標，沒有記下來的話事後無從得知漂移前一刻視窗是不是剛被踢出 fullscreen。
`seen.tsv` 因此多了第五欄；舊格式的四欄紀錄讀到的是空值，會顯示成 `unknown`。
app 被隱藏時 layout 讀不到，但 fullscreen 旗標仍讀得到，所以隱藏期間只凍結 layout、
繼續追蹤 fullscreen。

進入 floating 的那一刻（`BORN_FLOATING` / `DRIFTED_TO_FLOATING`）會自動抓一份
`aerospace debug-windows --window-id N`，連同 loadavg 與 AeroSpace／Ghostty 的 %CPU 存到
`~/.local/state/aerospace-drift/ax/<時間戳>-<wid>.txt`。回復（`RECOVERED_TO_TILED`）不抓。

這是驗證「AeroSpace 把視窗重新判定成不可 tile」的唯一手段：`window-layout` 只說得出
「父容器現在是 floating」，說不出為什麼。比對的重點欄位是 `AXSubrole`、`AXFullScreen`、
`AXMinimized`、以及 `Aero.AxFailed` 標記。

對照組：`ax/CONTROL-manual-float-20260728-214237-9912.txt` 是**用指令手動 float** 的健康
Ghostty 視窗，`subrole="AXStandardWindow"`、6 筆 `Aero.AxFailed` 全是按鈕的
`get.AXTitle(noValue)`（無害）。真正的漂移若在這些欄位上長得不一樣，答案就出來了。

只追蹤 config 歸類為 tiling 的三個終端機 app；其他 app 是 floating 屬設計如此，
不是異常。app 被 cmd-h 隱藏時 layout 讀到 `macos_native_window_of_hidden_app`，
會遮蔽真實狀態，因此視為**沒有觀測到**而非狀態轉換，以免產生假的 transition。

- 安裝：`scripts/macos/setup-aerospace-drift-log.sh`
- 日誌：`~/.local/state/aerospace-drift/drift.log`

判讀：收一兩天。若清一色 `BORN_FLOATING`，callback 順序的修改就是解答；
若出現 `DRIFTED_TO_FLOATING`，拿時間戳去對 `pmset -g log` 的 sleep/wake，
以及當下是否剛 cmd-h 過某個 app。

**第一輪（60 秒取樣，01:21–03:47）已判讀完畢：31 筆全是 `DRIFTED_TO_FLOATING`，
`BORN_FLOATING` 掛零，sleep/wake 也對不上。** 見上方 21:30 那則。
取樣間隔已改為 10 秒，目的是讓「同一個事件同時打到多個視窗」與「有人在幾秒內逐一操作」
在時間軸上分得開 —— 但這只是機率上的改善，不是決定性的：真正同時發生的事件與 10 秒內
完成的一輪操作仍然無法區分。

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
- 2026-07-28：漂移記錄器加採 `%{window-is-fullscreen}`，事件與 AX dump 都會帶上
  當下與前一次取樣的值，補掉「漂移前是不是剛離開 fullscreen」這個盲點。
- 2026-07-28：`aerospace.toml` 遷移到 `config-version = 2`，消除載入時的警告。
  v2 唯一的破壞性變更是 `persistent-workspaces` 不再從 key binding 推導、改為
  fallback 空陣列；本 config 沒有任何 workspace 綁定（space 由 FlashSpace 管），
  推導值本來就是空的，所以此遷移不改變行為，也**不應**補上
  `persistent-workspaces`。與 floating 漂移無關，純粹清警告。
- 2026-07-28 21:28：執行 `aerospace reload-config`。**這是 00:24 那份 config 第一次真正生效**
  ——AeroSpace 不會自動重載，而進程從 07-27 22:16 起沒重啟過。
- 2026-07-28 21:33：`aerospace-drift-log` 取樣間隔 60 秒 → 10 秒
  （`scripts/macos/com.leoluyi.aerospace-drift-log.plist` 的 `StartInterval`）。
- 2026-07-28 21:42：`aerospace-drift-log` 在視窗進入 floating 時自動抓 `debug-windows`
  的 AX dump。已端到端測過（手動 float → 9 秒後採到 11KB 的 dump → 還原）。
  測試自己造出來的三筆 transition 已從 `drift.log` 移除，AX dump 留下來當對照組。
  **`alt-f` 與 `aerospace.toml` 皆未更動**，維持單一變因。
- 2026-07-28：`0.21.2-Beta` → `0.21.3-Beta` 的升級**刻意先不做**。新的 callback 順序
  21:28 才上線，同時升級會讓「漂移消失」無法歸因。
- 2026-07-30 12:24：手動 `aerospace layout tiling --window-id 52` 修掉 11:41 那筆持續漂移
  （AX dump 已存檔，不損失證據）。**`drift.log` 裡 `12:24:36 RECOVERED_TO_TILED 52` 是這個
  人工動作，不是自發回復。** 這筆必須排除在「回復是自發還是人工」那個未解問題的統計之外。
- 2026-07-30 12:25：`aerospace-drift-log` 加寫 `samples/<日期>.tsv`，每次取樣都記
  loadavg 與各狀態視窗數，補上負載相關性的分母。詳見上方「為什麼需要 samples 序列」。
- 2026-07-30 12:26：`aerodiag` 在前景是 `com.apple.SecurityAgent` / `loginwindow` /
  `ScreenSaver` 時明確示警 —— 系統模態驗證框獨占鍵盤，是與 Secure Input 無關的獨立
  hotkey 殺手。正反向對照皆已測（SecurityAgent 與 loginwindow 觸發、Ghostty 靜默）。
- 2026-07-30 12:26：`aerodiag` 的 Secure Input 改列出**所有**持有者而非只列第一個
  （本機有多個 login session）。這不是修 bug：key 在關閉時不存在，原本的 `head -1`
  取到的是第一個持有者而非第一個 session，歷次 `OFF` 都是可信的陰性。
- 2026-07-30：**負載重現實驗尚未執行**。條件已確定：系統層飽和到 loadavg 60–90（不是 8）、
  持續 20 分鐘以上、同時開 System Settings、3–4 個可見且已 tiled 的 Ghostty 視窗。
  刻意後排 —— 平常跑 Claude Code 並行本來就會自然造出高負載，samples 序列會先累積基線。
- 2026-07-30：**刻意不做**讓漂移記錄器自動下 `layout tiling` 修復。那會污染
  `RECOVERED_TO_TILED` 的語意，而那恰好是目前唯一還沒有已知成因的現象。維持單一變因。
- `common_dotfiles/.config/aerospace/aerospace.toml` 未改動。

## 參考

- [AeroSpace #1486 — Add an indication when secure input is on](https://github.com/nikitabobko/AeroSpace/issues/1486)
- [AeroSpace Discussion #1205 — Alt key bindings stop working randomly](https://github.com/nikitabobko/AeroSpace/discussions/1205)
- [AeroSpace #732 — not registering key presses on letter keys](https://github.com/nikitabobko/AeroSpace/issues/732)
- [Ghostty: macOS Tiling Window Managers](https://ghostty.org/docs/help/macos-tiling-wms)
