# Sublime Text Settings

## Settings

Put all files from `sublime-settings` into `~/Library/Application Support/Sublime Text 3/Packages/User/`

#### OS X Command Line

```
$ ln -s "/Applications/Sublime Text.app/Contents/SharedSupport/bin/subl" /usr/local/bin
```

#### Canceling build

https://stackoverflow.com/a/28397562/3744499

You want to use <kbd>Ctrl</kbd>+<kbd>Break</kbd>. For your own information, just go check under **Tools** in Sublime Text and you'll see **Cancel Build** and the above hotkey. It'll work just fine for infinite loops. Suffice to say, I've had the same happen!

For Windows users, there is no <kbd>Break</kbd> key, so go into Preferences>Key Bindings and change the line:

```
{ "keys": ["ctrl+break"], "command": "cancel_build" }
```

to a different shortcut <kbd>Ctrl</kbd>+<kbd>Alt</kbd>+<kbd>C</kbd>:

```
{ "keys": ["ctrl+alt+c"], "command": "cancel_build" }
```

**Method 2: Use [Chain of Command](https://packagecontrol.io/packages/Chain%20of%20Command)**

```
    { "keys": ["escape"], "command": "chain", 
        "args": {"commands": [
            ["cancel_build"],
            ["hide_panel", {"cancel": true}]
        ]},
        "context":
        [
            { "key": "panel_visible", "operator": "equal", "operand": true }
        ]
    }
```

---

## Shorcut keys

- http://docs.sublimetext.info/en/latest/reference/keyboard_shortcuts_osx.html
- https://www.sublimetext.com/docs/3/multiple_selection_with_the_keyboard.html

**General**

- Command Palette: <kbd>⌘</kbd>+<kbd>⇧</kbd>+<kbd>P</kbd>
- Python Console: <kbd>⌃</kbd>+<kbd>`</kbd>
- Toggle side bar: <kbd>⌘</kbd>+<kbd>K</kbd>, <kbd>⌘</kbd>+<kbd>B</kbd>

**Editing**

```
⌘+↩       Insert line after
⌘+⇧+↩   Insert line before
⌘+⇧+D   Duplicate line(s)
⌘+J       Join line below to the end of the current line
⌃+⇧+K   Delete current line of cursor
```

**Selection and Jump**

```
Block selection

⌥+click  Block selection using the mouse (Windows: Shift + Right Click)

Jumping

⌃+M       Jump to closing parentheses. Repeat to jump to opening parentheses

Adding a Line

⌃+⇧+⬆ and ⌃+⇧+⬇    Extra cursor on the line above/below (Windows/Linux: Ctrl+Alt+⬆ and Ctrl+Alt+⬇)

Splitting the Selection into Lines

⇧+⌘+L  (Windows/Linux: Ctrl+Shift+L)

Quick Add Next

⌘+L        Select line - Repeat to select next lines
⌘+D        Select word - Repeat to select next occurrence
⌘+K, ⌘+D  Individual occurrences can be skipped via Quick Skip Next (Windows: Ctrl+K, Ctrl+D)
⌘+U        If you go too far, use Undo Selection to step backwards (Windows: Ctrl+U)

Find All

⌃+⌘+G      Select all occurrences of current selection (Windows/Linux: Alt+F3)
```

**Navigation/Goto Anywhere**

```
⌘+P or ⌘+T   Quick-open files by name
⌘+R           Goto symbol / Goto word in current file
⌃+G            Goto line in current file
```

---

```
-- BEGIN LICENSE --
ZYNGA INC.
50 User License
EA7E-811825
927BA117 84C9300F 4A0CCBC4 34A56B44
985E4562 59F2B63B CCCFF92F 0E646B83
0FD6487D 1507AE29 9CC4F9F5 0A6F32E3
0343D868 C18E2CD5 27641A71 25475648
309705B3 E468DDC4 1B766A18 7952D28C
E627DDBA 960A2153 69A2D98A C87C0607
45DC6049 8C04EC29 D18DFA40 442C680B
1342224D 44D90641 33A3B9F2 46AADB8F
-- END LICENSE --
```

