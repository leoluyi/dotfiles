# pipx — Practical Hands-On Guide

`pipx` installs Python **command-line applications** into isolated virtual
environments and exposes their executables on your `PATH` — without polluting the
global interpreter. Think of it as `brew install` for Python CLI tools.

**Golden rule:** never `pip install` into Homebrew's Python (it is externally
managed and read-only). Use `pipx` for Python-based CLIs, `uv` for project work.

## This machine's setup

Installed via Homebrew (`homebrew/Brewfile`), version 1.11.1.

| Setting | Value | Notes |
|---|---|---|
| App venvs | `~/.local/pipx/venvs/<app>` | One isolated venv per app |
| Shims (on `PATH`) | `~/.local/bin` | Already first in `PATH` (`.bash_profile`) |
| Man pages | `~/.local/share/man` | |
| Default base Python | `python@3.14` (the one pipx runs on) | Override per-app with `--python` |

Because `~/.local/bin` is already on your `PATH`, you do **not** need
`pipx ensurepath`. Verify any time with `pipx environment`.

## Core workflow

```bash
pipx install ruff            # install an app (creates ~/.local/pipx/venvs/ruff)
ruff --version               # the executable is now on PATH
pipx list                    # what's installed, with versions + exposed binaries
pipx upgrade ruff            # upgrade one app
pipx upgrade-all             # upgrade everything
pipx uninstall ruff          # remove an app and its shims
```

| Command | What it does |
|---|---|
| `pipx install <pkg>` | Create an isolated venv and expose its entry-point scripts |
| `pipx list` | List apps, versions, and exposed commands |
| `pipx list --short` | One line per app (`name version`) — scriptable |
| `pipx upgrade <pkg>` | Upgrade a single app |
| `pipx upgrade-all` | Upgrade every installed app |
| `pipx uninstall <pkg>` | Remove one app |
| `pipx uninstall-all` | Nuke everything pipx manages |
| `pipx reinstall <pkg>` | Rebuild a venv (use after a Python upgrade — see Maintenance) |
| `pipx reinstall-all` | Rebuild every app venv |
| `pipx runpip <pkg> <args>` | Run `pip` *inside* an app's venv (debugging) |
| `pipx environment` | Print resolved paths and config |

## Run without installing

`pipx run` fetches a package into a temporary cache, runs it, and discards it —
ideal for one-off or rarely-used tools.

```bash
pipx run cowsay -t "hello"           # run once, nothing installed
pipx run --spec httpie http GET example.com   # when command name != package name
pipx run cookiecutter gh:audreyr/cookiecutter-pypackage
```

Cached runs are reused for a few days, then refreshed automatically.

## Injecting extra dependencies

An app's venv is sealed. When a tool needs plugins or extras, `inject` them into
its venv rather than installing the plugin globally.

```bash
pipx install llm
pipx inject llm llm-anthropic         # add a plugin to llm's venv
pipx inject jupyter jupyterlab-vim    # add an extension to jupyter's venv
```

`pipx uninject <app> <pkg>` reverses it.

## Controlling the Python version

By default pipx builds each app venv with the Python it runs on (currently
`python@3.14`). Pin a specific interpreter per app when a tool isn't yet
compatible with the newest Python:

```bash
pipx install --python python3.13 some-tool
pipx install --python /opt/homebrew/bin/python3.12 legacy-tool
```

The chosen interpreter is baked into that app's venv and survives upgrades.

## Recommended apps for this setup

CLI tools that belong in pipx (not in a project venv, not in global pip):

```bash
pipx install ruff            # fast linter/formatter
pipx install httpie          # human-friendly HTTP client
pipx install poetry          # if/when a project uses it
pipx install cookiecutter    # project scaffolding
pipx install ipython         # standalone REPL
```

Skip anything Homebrew already provides as a formula (`llm`, `yt-dlp`, `glances`,
`black`, `isort`) — let `brew` own those so they upgrade with `brew upgrade`.
Use pipx for tools *not* packaged by brew, or when you want a version independent
of brew's.

## Maintenance: after a Homebrew Python upgrade

When `brew upgrade` bumps the Python that pipx runs on, existing app venvs can
break (they still reference the old interpreter). Rebuild them:

```bash
pipx reinstall-all           # rebuilds every app venv against the current Python
```

Related gotcha on this machine: `PYTHONPYCACHEPREFIX=~/.cache/python` means stale
bytecode can survive brew upgrades and cause phantom version-mismatch errors. If a
pipx app throws an import/version `SystemError` after an upgrade, clear it:

```bash
rm -rf ~/.cache/python        # pure regenerable bytecode cache
```

## Troubleshooting

| Symptom | Fix |
|---|---|
| `command not found` after install | `pipx environment` → confirm `~/.local/bin` on `PATH`; `pipx ensurepath` if missing |
| App broke after `brew upgrade python` | `pipx reinstall-all` |
| Phantom `SystemError: ... incompatible version` | `rm -rf ~/.cache/python`, then re-run |
| Need to inspect an app's deps | `pipx runpip <app> list` |
| App pulls wrong Python | reinstall with explicit `--python` |

## pipx vs `uv tool`

`uv` ships an equivalent (`uv tool install <pkg>`, `uvx <pkg>`) that is faster and
shares uv's Python cache. Both are valid; pick one per tool to avoid duplicate
shims. pipx is the stable, widely-documented default and is what this dotfiles
setup standardizes on. If you later consolidate on `uv`, the command mapping is
direct: `pipx install` → `uv tool install`, `pipx run` → `uvx`.

## Reference

- Docs: <https://pipx.pypa.io/>
- Project workflow (non-CLI work) uses `uv` instead — see `uv` docs.
