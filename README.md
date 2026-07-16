# dotfiles

Centralized terminal & tooling configuration, managed with symlinks.

Everything lives in this one repo and is linked into place by [`install.sh`](./install.sh).
No git submodules, no remotes buried inside — it's fully self-contained.

## What's included

| Tool | Repo path | Linked to |
|------|-----------|-----------|
| **zsh** | `home/.zshrc`, `home/.zshenv` | `~/.zshrc`, `~/.zshenv` |
| **powerlevel10k** | `home/.p10k.zsh` | `~/.p10k.zsh` |
| **taskwarrior** | `home/.taskrc` | `~/.taskrc` |
| **nvim** | `config/nvim/` | `~/.config/nvim` |
| **fastfetch** | `config/fastfetch/` | `~/.config/fastfetch` |
| **ghostty** | `config/ghostty/` | `~/.config/ghostty` |
| **zed** | `config/zed/` | `~/.config/zed/{keymap,settings}.json` |

### Notably NOT tracked (on purpose)

- **oh-my-zsh** — the framework itself is not vendored; `install.sh` prompts you to
  run the official installer. Your `custom/` folder had no personal content.
- **htop** — you currently have no custom `htoprc`; nothing to version yet. When you
  configure it, htop writes `~/.config/htop/htoprc` — add it here and link it then.
- **iTerm2** — intentionally dropped (Ghostty is the primary terminal).
- **Taskwarrior data** (`~/.task/`) — your actual tasks; personal data, never committed.

## Setup on a fresh machine

```bash
git clone <your-repo-url> ~/dotfiles
cd ~/dotfiles
./install.sh
```

`install.sh` is idempotent and **non-destructive**: anything it would replace is first
moved to `~/.dotfiles-backup/<timestamp>/`. Re-run it any time.

### Dependencies

Install these first (macOS / Homebrew):

```bash
# terminal + prompt
brew install --cask ghostty
brew install powerlevel10k fastfetch neovim task htop

# Nerd Font used by ghostty/zed/p10k
brew install --cask font-jetbrains-mono-nerd-font

# oh-my-zsh (if not already installed)
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
```

Notes:
- `~/.zshrc` sources powerlevel10k from `/opt/homebrew/share/powerlevel10k/…` (the
  Homebrew formula), not the oh-my-zsh theme. Keep `ZSH_THEME="robbyrussell"` as-is.
- **nvim** uses [lazy.nvim](https://github.com/folke/lazy.nvim); plugins bootstrap and
  install automatically on first launch. Versions are pinned in `lazy-lock.json`.
- **fastfetch** references its logo by absolute path (`~/.config/fastfetch/nano.png`).
  Because the config dir is symlinked, that path resolves correctly for this user.

## Zed secrets

`config/zed/settings.json` in this repo is a **sanitized template**:

- `context7_api_key` is a placeholder (`REPLACE_WITH_YOUR_CONTEXT7_API_KEY`).
- `ssh_connections` is emptied (internal hosts were removed).

On a fresh machine `install.sh` copies the template to `~/.config/zed/settings.json`
only if none exists — then edit it and paste your real Context7 key and SSH hosts.
On a machine that already has a real `settings.json`, the script leaves it untouched.

If you keep machine-specific overrides, use `config/zed/settings.local.json`
(git-ignored) rather than editing the committed template.

> ⚠️ Never commit your real Context7 key. The `.gitignore` already excludes the local
> Zed state (prompts, conversations, themes, backup, `settings.local.json`).

## Layout

```
dotfiles/
├── install.sh          # symlinks everything into place (idempotent, backs up)
├── .gitignore          # excludes secrets & personal Zed/Task data
├── home/               # files that live in ~
│   ├── .zshrc  .zshenv  .p10k.zsh  .taskrc
└── config/             # files that live in ~/.config
    ├── nvim/  fastfetch/  ghostty/
    └── zed/            # keymap.json + sanitized settings.json template
```
