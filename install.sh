#!/usr/bin/env bash
set -euo pipefail

repo_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)

dotfiles=(
  .bash_logout
  .bash_profile
  .bashrc
  .gitconfig
  .gtkrc-2.0
  .zshrc
)

config_dirs=(
  btop
  gtk-3.0
  gtk-4.0
  hypr
  kitty
  waybar
  xsettingsd
)

adopt() {
  for file in "${dotfiles[@]}"; do
    local target="$HOME/$file"
    local source="$repo_dir/$file"
    [[ -e "$target" || -L "$target" ]] || continue
    [[ "$target" -ef "$source" ]] && continue
    [[ ! -e "$source" && ! -L "$source" ]] || {
      printf 'Refusing to adopt %s: %s already exists.\n' "$target" "$source" >&2
      exit 1
    }
    mv -- "$target" "$source"
  done

  for dir in "${config_dirs[@]}"; do
    local target="$HOME/.config/$dir"
    local source="$repo_dir/config/$dir"
    [[ -e "$target" || -L "$target" ]] || continue
    [[ "$target" -ef "$source" ]] && continue
    [[ ! -e "$source" && ! -L "$source" ]] || {
      printf 'Refusing to adopt %s: %s already exists.\n' "$target" "$source" >&2
      exit 1
    }
    mkdir -p -- "$repo_dir/config"
    mv -- "$target" "$source"
  done
}

link() {
  for file in "${dotfiles[@]}"; do
    local source="$repo_dir/$file"
    local target="$HOME/$file"
    [[ -e "$source" ]] || continue
    [[ -e "$target" || -L "$target" ]] && [[ "$target" -ef "$source" ]] && continue
    [[ ! -e "$target" && ! -L "$target" ]] || {
      printf 'Refusing to link %s: it already exists.\n' "$target" >&2
      exit 1
    }
    ln -s -- "$source" "$target"
  done

  for dir in "${config_dirs[@]}"; do
    local source="$repo_dir/config/$dir"
    local target="$HOME/.config/$dir"
    [[ -d "$source" ]] || continue
    [[ -e "$target" || -L "$target" ]] && [[ "$target" -ef "$source" ]] && continue
    [[ ! -e "$target" && ! -L "$target" ]] || {
      printf 'Refusing to link %s: it already exists.\n' "$target" >&2
      exit 1
    }
    mkdir -p -- "$HOME/.config"
    ln -s -- "$source" "$target"
  done
}

case "${1:-install}" in
  adopt)
    adopt
    link
    ;;
  install)
    link
    ;;
  *)
    printf 'Usage: %s [adopt|install]\n' "${BASH_SOURCE[0]}" >&2
    exit 2
    ;;
esac
