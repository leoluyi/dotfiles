# tmux settings

## Oh My Tmux!

https://github.com/gpakosz/.tmux

Installation

```bash
$ git clone https://github.com/gpakosz/.tmux.git ~/.tmux
$ ln -s -f ~/.tmux/.tmux.conf ~/.tmux.conf
$ cp ~/.tmux/.tmux.conf.local ~/.tmux.conf.local
```

Restore settings

```bash
# In folder `dotfiles/tmux/`
$ cp tmux.conf.local ~/.tmux.conf.local
```

## tmux-completion

```sh
# macOS
$ brew install tmux

# Ubuntu
$ sudo curl -fsSL -o /etc/bash_completion.d/tmux_completion https://github.com/imomaliev/tmux-bash-completion/raw/master/completions/tmux
```

## Set copy-mode-vi

https://sanctum.geek.nz/arabesque/vi-mode-in-tmux/

Add the following line in `~/.tmux.conf.local`

```
# ~/.tmux.conf.local
set -g status-keys vi
set -g mode-keys vi
```

## Automatic Tmux start

https://github.com/tmux-plugins/tmux-continuum/blob/master/docs/automatic_start.md

```
# ~/.tmux.conf.local
set -g @continuum-boot 'on'
set -g @continuum-restore 'on'
```

## [Tmux Plugin Manager](https://github.com/tmux-plugins/tpm)

Clone TPM to install:

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

# Initialize TMUX plugin manager (keep this line at the very bottom of tmux.conf.local)
run -b '~/.tmux/plugins/tpm/tpm'
```

**Key bindings**

`prefix` + <kbd>I</kbd> (capital i)

- Installs new plugins from GitHub or any other git repository
- Refreshes TMUX environment

`prefix` + <kbd>U</kbd> (capital u)

- updates plugin(s)

`prefix` + <kbd>alt</kbd> + <kbd>u</kbd>

- remove/uninstall plugins not on the plugin list
