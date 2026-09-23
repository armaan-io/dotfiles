# dotfiles

Portable Linux desktop configuration for this account. The repository owns the
linked files listed in `install.sh`; application state, browser profiles,
tokens, SSH keys, histories, caches, and machine-specific data stay outside it.

## Restore

```sh
git clone git@github.com:armaan-io/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
./install.sh
```

The installer only creates missing links and refuses to replace existing files.
Move or back up an existing file first if you want the repository version.

## Add the current configuration

On the machine containing the current configuration, run this once:

```sh
cd ~/.dotfiles
./install.sh adopt
git add .
git commit -m "Track desktop dotfiles"
git push
```

`adopt` moves the selected files into the repository and replaces them with
symbolic links. It refuses to overwrite a repository copy.

## Prerequisites

The Hyprland profile expects Arch Linux packages for Hyprland, Hypridle,
Hyprlock, Hyprpaper, Waybar, Kitty, Btop, Rofi, Dunst, Thunar, Flameshot,
PipeWire/WirePlumber, `brightnessctl`, `playerctl`, and the Papirus icon theme.
It also expects a Nerd Font for Waybar. Add wallpapers separately under
`~/Pictures/Wallpapers`.
