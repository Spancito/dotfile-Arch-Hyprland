<div align="center">

  <img src="https://raw.githubusercontent.com/devicons/devicon/master/icons/linux/linux-original.svg" alt="Tux Linux" width="120" height="120" />

  # ❄️ Arch Linux + Hyprland Dotfiles

  *Una configuración minimalista, fluida y estética para Arch Linux impulsada por Hyprland y Wayland.*

  <p align="center">
    <a href="https://archlinux.org/">
      <img src="https://img.shields.io/badge/OS-Arch_Linux-1793D1?style=for-the-badge&logo=arch-linux&logoColor=white" alt="Arch Linux" />
    </a>
    <a href="https://hyprland.org/">
      <img src="https://img.shields.io/badge/WM-Hyprland-005F87?style=for-the-badge&logo=hyprland&logoColor=white" alt="Hyprland" />
    </a>
    <a href="https://wayland.freedesktop.org/">
      <img src="https://img.shields.io/badge/Display_Server-Wayland-FF6600?style=for-the-badge&logo=wayland&logoColor=white" alt="Wayland" />
    </a>
    <a href="https://github.com/Spancito/dotfile-Arch-Hyprland/stargazers">
      <img src="https://img.shields.io/github/stars/Spancito/dotfile-Arch-Hyprland?style=for-the-badge&color=f5c2e7" alt="Stars" />
    </a>
  </p>

  ---

</div>

## 📌 Descripción

Este repositorio contiene mis archivos de configuración personal (`dotfiles`) para un entorno de trabajo liviano y productivo en **Arch Linux**.

- **Window Manager:** Hyprland (Wayland Composer)
- **Terminal:** Kitty / Foot
- **Shell:** Zsh / Bash
- **Barra de estado:** Waybar
- **Lanzador de aplicaciones:** Rofi / Wofi
- **Wallpapers:** mpvpaper / swww (Soporte para fondos animados `.mp4`)

---

## 🎨 Capturas de Pantalla

<div align="center">
  <img src="https://raw.githubusercontent.com/archlinux/archweb/master/sitestatic/archlogo.png" alt="Preview Placeholder" width="700"/>
  <br/>
  <sub><i>Agrega aquí una captura de pantalla de tu escritorio</i></sub>
</div>

---

## 🚀 Instalación Rápida

> [!WARNING]
> Revisa el contenido de los scripts y archivos de configuración antes de copiarlos directamente a tu sistema para evitar sobrescribir tus configuraciones actuales.

1. **Clonar el repositorio:**

   ```bash
   git clone https://github.com/Spancito/dotfile-Arch-Hyprland.git ~/.config/dotfiles-temp
   ```

2. **Copiar las configuraciones:**

   ```bash
   cp -r ~/.config/dotfiles-temp/* ~/.config/
   rm -rf ~/.config/dotfiles-temp
   ```

---

## 🛠️ Requisitos e Instalación de Dependencias

Para asegurarte de que todos los módulos y fondos animados funcionen correctamente, instala los paquetes esenciales en Arch Linux:

```bash
sudo pacman -S --needed hyprland waybar kitty rofi-wayland mpvpaper git git-lfs
```

*Nota: Para los fondos de pantalla animados en formato `.mp4` almacenados con **Git LFS**, asegúrate de ejecutar `git lfs pull` tras clonar.*

---

<div align="center">

  **Desarrollado con ❤️ por [Spancito](https://github.com/Spancito)**

</div>