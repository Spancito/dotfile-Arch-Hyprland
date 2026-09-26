#!/bin/bash

set -e

echo "Iniciando instalación de aplicaciones..."

echo "[1/3] Actualizando el sistema..."
sudo pacman -Syu --noconfirm

echo "[2/3] Instalando paquetes nativos..."
NATIVE_PKGS=(
    aria2 bind brave-bin code cpupower dunst egl-wayland f2fs-tools 
    fastfetch ffmpegthumbnailer flameshot flatpak gamemode gamescope git 
    git-lfs glfw grim gst-libav gst-plugins-bad gst-plugins-base gst-plugins-good 
    gst-plugins-ugly heroic-games-launcher hyprland kitty lutris man-pages 
    matugen meld mpvpaper noto-fonts obs-studio opencode pipewire-jack plocate 
    prismlauncher proton-cachyos-native pv python qt5-wayland qt6-wayland rofi 
    shelly slurp snapper steam swaybg thunar ttf-meslo-nerd unrar upower vim 
    vlc-plugins-all waybar wireplumber wl-clipboard wtype xdg-desktop-portal-hyprland 
    yay zed
)

sudo pacman -S --needed --noconfirm "${NATIVE_PKGS[@]}"

echo "[3/3] Instalando paquetes de AUR..."
AUR_PKGS=(
    antigravity 
    bottles 
    jdk 
    vesktop 
    zuno
)

yay -S --needed --noconfirm "${AUR_PKGS[@]}"

echo "========================================="
echo "¡Instalación completada con éxito! 🎉"
echo "========================================="
