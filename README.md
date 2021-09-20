# nixos-config

[![NixOS 21.05](https://img.shields.io/badge/NixOS-21.05-blue?logo=NixOS&logoColor=white)](https://nixos.org)

My [NixOS](https://nixos.org) system+user configuration.
Powered by [Nix](https://github.com/NixOS/nix),
[Nix Flakes](https://nixos.wiki/wiki/Flakes),
[Home Manager](https://github.com/nix-community/home-manager),
and [passion](https://www.dictionary.com/browse/passion).

## My Setup

| _What Is_      | _What I Use_              |
| -------------- | ------------------------- |
| **Browser**    | Firefox                   |
| **DM**         | LightDM with Mini-Greeter |
| **Editor**     | Neovim                    |
| **Launcher**   | Rofi                      |
| **Shell**      | Zsh with Zgen             |
| **Status Bar** | Polybar                   |
| **WM**         | bspwm                     |

## Quickstart

Note: the optional steps are needed to set up a custom configuration and are
highly recommended (mainly because you probably have different hardware than
mine, and you also probably want to customize the system to your own needs).

Note 2: the commands in the following steps should be considered to be run as
root (e.g. using `sudo`).

1. Download and boot the latest build of [NixOS
   21.05](https://nixos.org/download.html).
2. Partition as you like and mount your root to `/mnt` (see [the
   manual](https://nixos.org/manual/nixos/stable/index.html#sec-installation)).
3. (Optional) Generate an initial configuration as stated in the manual, using
```shell
nixos-generate-config --root /mnt
```
4. (Optional) Temporarely move the files generated in `/mnt/etc/nixos` somewhere else.
5. Start a nix-shell with
```shell
nix-shell -p git nixFlakes
```
6. Clone this repo with
```shell
git clone https://github.com/BuriedInTheGround/nixos-config.git /mnt/etc/nixos
```
7. Fix some paths with
```shell
mv /etc/nixos /etc/nixos.bak
ln -s /mnt/etc/nixos /etc/nixos
```
8. (Optional) Create a sub-directory inside `hosts/` with the name you want for
   your host
9. (Optional) Put the files you moved in (4) into your host folder.
10. (Optional) Rename `hosts/<your-hostname>/configuration.nix` to
   `hosts/<your-hostname>/default.nix`.
11. (Optional) Customize `hosts/<your-hostname>/default.nix` my adding modules
    and NixOS settings.
12. (Optional) Set your username by changing my default (`"simone"`) in
   `modules/options.nix`
13. (Optional) Add your changes with git, e.g.
```shell
git add hosts/<your-hostname>
git add modules/options.nix
```
14. Install NixOS with
```shell
nixos-install --root /mnt --flake /mnt/etc/nixos#<your-hostname> --impure
```
15. (Optional) Use `nixos-enter` to setup some files or folders in advance.
16. Reboot.
17. Change your `root` and user password.
