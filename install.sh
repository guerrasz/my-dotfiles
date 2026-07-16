#!/usr/bin/env bash
#
# install.sh — symlink these dotfiles into place.
#
# Safe to re-run (idempotent). Any existing real file/dir that would be
# replaced is moved to a timestamped backup dir first — nothing is deleted.
#
set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP="$HOME/.dotfiles-backup/$(date +%Y%m%d-%H%M%S)"

info()  { printf '\033[1;34m::\033[0m %s\n' "$*"; }
ok()    { printf '\033[1;32m ✓\033[0m %s\n' "$*"; }
warn()  { printf '\033[1;33m !!\033[0m %s\n' "$*"; }

# link SRC -> DEST, backing up whatever is currently at DEST
link() {
  local src="$1" dest="$2"
  if [[ -L "$dest" && "$(readlink "$dest")" == "$src" ]]; then
    ok "already linked: ${dest/#$HOME/~}"
    return
  fi
  if [[ -e "$dest" || -L "$dest" ]]; then
    mkdir -p "$BACKUP$(dirname "${dest/#$HOME/}")"
    mv "$dest" "$BACKUP${dest/#$HOME/}"
    warn "backed up existing ${dest/#$HOME/~} -> ${BACKUP/#$HOME/~}"
  fi
  mkdir -p "$(dirname "$dest")"
  ln -s "$src" "$dest"
  ok "linked ${dest/#$HOME/~} -> ${src/#$HOME/~}"
}

info "Linking home dotfiles"
link "$DOTFILES/home/.zshrc"    "$HOME/.zshrc"
link "$DOTFILES/home/.zshenv"   "$HOME/.zshenv"
link "$DOTFILES/home/.p10k.zsh" "$HOME/.p10k.zsh"
link "$DOTFILES/home/.taskrc"   "$HOME/.taskrc"

info "Linking ~/.config tools"
link "$DOTFILES/config/nvim"      "$HOME/.config/nvim"
link "$DOTFILES/config/fastfetch" "$HOME/.config/fastfetch"
link "$DOTFILES/config/ghostty"   "$HOME/.config/ghostty"

info "Linking Zed (per-file: keeps your local prompts/themes/settings intact)"
mkdir -p "$HOME/.config/zed"
link "$DOTFILES/config/zed/keymap.json" "$HOME/.config/zed/keymap.json"
# settings.json holds a secret placeholder — never clobber a real local file.
if [[ ! -e "$HOME/.config/zed/settings.json" ]]; then
  cp "$DOTFILES/config/zed/settings.json" "$HOME/.config/zed/settings.json"
  warn "copied Zed settings TEMPLATE -> ~/.config/zed/settings.json"
  warn "  edit it and replace REPLACE_WITH_YOUR_CONTEXT7_API_KEY with your real key"
else
  ok "kept existing ~/.config/zed/settings.json (not overwritten)"
fi

# oh-my-zsh framework is NOT vendored here; install it if missing.
if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
  warn "oh-my-zsh not found. Install it, then re-run this script:"
  warn '  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended'
fi

echo
info "Done. Backups (if any) are in ${BACKUP/#$HOME/~}"
info "Open a new shell or run: exec zsh"
