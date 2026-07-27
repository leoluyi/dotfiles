# AeroSpace 快捷鍵失效調查

追蹤一個間歇性故障：AeroSpace 全域快捷鍵整組沒反應，重啟 AeroSpace 後恢復。

狀態：**等待故障重現以取得證據**（2026-07-27 起）

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
| floating 視窗沒被列出 = 追蹤壞掉 | 誤判。floating 視窗本來就不出現在 `list-windows`，`list-apps` 顯示所有 app 都有被認到 |

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

## 故障時怎麼做

**先不要重啟 AeroSpace**，重啟會銷毀證據。在終端機執行：

```sh
aerodiag
```

報告存到 `~/.local/state/aerodiag/<時間戳>.txt`。

腳本位於 `macos/.local/bin/aerodiag`。

## 已做的變更

- 2026-07-27：AeroSpace `0.20.3-Beta` → `0.21.3-Beta`（跨一個 minor，該期間上游修過
  數個 AX 與 hotkey 相關問題）。若升級後不再重現，即無需再往下追。
- 2026-07-27：新增 `macos/.local/bin/aerodiag`。
- `common_dotfiles/.config/aerospace/aerospace.toml` 未改動。

## 參考

- [AeroSpace #1486 — Add an indication when secure input is on](https://github.com/nikitabobko/AeroSpace/issues/1486)
- [AeroSpace Discussion #1205 — Alt key bindings stop working randomly](https://github.com/nikitabobko/AeroSpace/discussions/1205)
- [AeroSpace #732 — not registering key presses on letter keys](https://github.com/nikitabobko/AeroSpace/issues/732)
- [Ghostty: macOS Tiling Window Managers](https://ghostty.org/docs/help/macos-tiling-wms)
