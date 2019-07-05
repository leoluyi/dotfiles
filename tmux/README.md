# tmux settings

## Oh My Tmux!

https://github.com/gpakosz/.tmux

Installation

```bash
$ git clone https://github.com/gpakosz/.tmux.git ~/.tmux
$ ln -s -f ~/.tmux/.tmux.conf ~/.tmux.conf
```

Restore settings

```bash
$ cp tmux.conf.local ~/.tmux.conf.local
```

## tmux-completion

```sh
# macOS
$ brew install tmux

# Ubuntu
$ sudo wget -O /usr/share/bash-completion/tmux_completion https://github.com/imomaliev/tmux-bash-completion/raw/master/completions/tmux
```

## Set copy-mode-vi

https://sanctum.geek.nz/arabesque/vi-mode-in-tmux/

Add the following line in `~/.tmux.conf.local`

```
# ~/.tmux.conf.local
set -g status-keys vi
set -g mode-keys vi
```

## 

Clone TPM:

```bash
$ git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
```

[List of plugins](https://github.com/gpakosz/.tmux/issues/228#issuecomment-472205869)

Use this syntax to add plugins in your `tmux.conf.local`:

```
set -g @tpm_plugins ' \
  tmux-plugins/tpm \
  tmux-plugins/tmux-sensible \
  tmux-plugins/tmux-continuum \
  tmux-plugins/tmux-resurrect \
  nhdaly/tmux-scroll-copy-mode \
  samoshkin/tmux-plugin-sysstat \
'
```

**Key bindings**

`prefix` + <kbd>I</kbd> (capital i)

- Installs new plugins from GitHub or any other git repository
- Refreshes TMUX environment

`prefix` + <kbd>U</kbd> (capital u)

- updates plugin(s)

`prefix` + <kbd>alt</kbd> + <kbd>u</kbd>

- remove/uninstall plugins not on the plugin list

