# MacOS Settings

## Save MacOS Settings

- [references](https://github.com/pawelgrzybek/dotfiles/blob/master/setup-macos.sh)

Backup MacOS settings:

```sh
defaults read > macos-defaults.xml
```

Backup MacOS Keyboard settings:

```sh
defaults export com.apple.symbolichotkeys - > macos-keyboard-shortcuts.xml
```

Import the same xml file in new MacOS computer

```sh
defaults import com.apple.symbolichotkeys ./macos-keyboard-shortcuts.xml
/System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u
```

## Enable Dark Menu Bar and Dock With Light Theme in MacOS

```sh
defaults write -g NSRequiresAquaSystemAppearance -bool Yes
```

- Log out and log in again.
- Under the Appearance section, select **Dark**. This will turn only the menu bar
and Dock into dark mode.

---

## macOS `bash_profile`

Download bash_profile:

```
$ curl -fsSL -o ~/.bash_profile https://github.com/leoluyi/dotfiles/raw/master/macOS/bash_profile
```

### Upgrade to bash 4 in Mac OS X

http://clubmate.fi/upgrade-to-bash-4-in-mac-os-x/

Update homebrew packet database and install bash:

```bash
brew update && brew install bash
```

Configure terminal to use it:

```bash
# Add the new shell to the list of allowed shells
sudo bash -c 'echo /opt/homebrew/bin/bash >> /etc/shells'
# Change to the new shell
chsh -s /opt/homebrew/bin/bash
```

Check bash version with:

```bash
bash --version
```

---

## About bash_profile and bashrc on macOS

https://scriptingosx.com/2017/04/about-bash_profile-and-bashrc-on-macos/

- The usual convention is that `.bash_profile` will be executed at **login shells**
    - i.e. interactive shells where you login with your user name and password at the beginning.
    - When you ssh into a remote host, it will ask you for user name and password (or some other authentication) to log in, so it is a login shell.
- When you open a terminal application (**Terminal.app**), it does not ask for login (**Non-login shell**). You will just get a command prompt.
- In other versions of Unix or Linux, this will not run the `.bash_profile` but a different file `.bashrc`. The underlying idea is that the `.bash_profile` should be run only once when you login, and the `.bashrc` for every new interactive shell. However, Terminal.app on macOS, does not follow this convention. When **Terminal.app** opens a new window, it will run `.bash_profile`. Not, as users familiar with other Unix systems would expect, `.bashrc`.

There are two main approaches:

1. When you are living mostly or exclusively on macOS and the **Terminal.app**, you can create a `.bash_profile`, ignore all the special cases and be happy.
2. If you want to have an approach that is more resilient to other terminal applications and might work (at least partly) across Unix/Linux platforms, put your configuration code in `.bashrc` and source `.bashrc` from `.bash_profile` with the following code in `.bash_profile`:

```bash
if [ -r ~/.bashrc ]; then
   source ~/.bashrc
fi
```

So in macOS Terminal.app, before you even see a prompt, these scripts will be run:

- `/etc/profile`
    - `/etc/bashrc`
        - `/etc/bashrc_Apple_Terminal`
- if it exists: `~/.bash_profile`
    - when `~/.bash_profile` does not exists, `~/.bash_login`
    - when neither `~/.bash_profile` nor `~/.bash_login` exist, `~/.profile`
- `~/bash_profile` can optionally source `~/.bashrc`

## References

- https://macos-defaults.com/
