#!/bin/bash

set -e

echo "Iniciando instalación de aplicaciones..."

echo "[1/3] Actualizando el sistema..."
sudo pacman -Syu --noconfirm

echo "[2/3] Instalando paquetes nativos..."
NATIVE_PKGS=(
    aria2 bind cava code cpupower dunst egl-wayland f2fs-tools
    fastfetch ffmpegthumbnailer flameshot flatpak gamemode gamescope git
    git-lfs glfw grim gst-libav gst-plugins-bad gst-plugins-base gst-plugins-good
    gst-plugins-ugly hyprland kitty lutris man-pages
    matugen meld noto-fonts obs-studio opencode pipewire-jack plocate
    prismlauncher pv python qt5-wayland qt6-wayland rofi
    slurp snapper swaybg thunar ttf-meslo-nerd unrar upower vim
    vlc-plugins-all waybar wireplumber wl-clipboard wtype xdg-desktop-portal-hyprland
    zed xorg-xcursorgen
)

sudo pacman -S --needed --noconfirm "${NATIVE_PKGS[@]}"

echo "[3/3] Instalando paquetes de AUR..."
AUR_PKGS=(
    antigravity
    bottles
    brave-bin
    heroic-games-launcher
    jdk
    mpvpaper
    proton-cachyos-native
    shelly
	steam
    vesktop
    zuno
    papirus-icon-theme
    papirus-folders-git
)

yay -S --needed --noconfirm "${AUR_PKGS[@]}"
echo "[4/4] Copiando temas base al directorio local..."
mkdir -p ~/.local/share/icons
cp -r /usr/share/icons/Papirus ~/.local/share/icons/ 2>/dev/null || true
cp -r /usr/share/icons/Papirus-Dark ~/.local/share/icons/ 2>/dev/null || true

echo "¡Instalación completada con éxito!"
