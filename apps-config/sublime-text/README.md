# Sublime Text Settings

## Settings

### Sync settings

1. Install **Package Control**
2. Install [**Package Syncing**](https://packagecontrol.io/packages/Package%20Syncing)
3. Restore settings
    - On new machine, you have to download your backup settings to a sync folder.
    - Set the sync folder in command palette `Package Syncing: Define Sync Folder` as `/Users/leoluyi/Dropbox/leo_workspace/dotfiles/sublime-text/package_sync_mac`, then
    - **Package Syncing** will automatically pull all available files from that folder. **Restart** Sublime Text & Package Control will check for missing packages and install them automatically.

**Manually restore settings**

Put all files from `sublime-settings` into `~/Library/Application Support/Sublime Text 3/Packages/User/`

### OS X Command Line Tool

```
$ ln -s "/Applications/Sublime Text.app/Contents/SharedSupport/bin/subl" /usr/local/bin
```

### Canceling build shorcut keys

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

## LICENSE

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

