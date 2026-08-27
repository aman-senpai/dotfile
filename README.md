# 🌌 Aman's Fedora Hyprland & Caelestia Dotfiles

A modern, fluid, and battery-efficient Wayland desktop environment on **Fedora Linux**, powered by **Hyprland** (v0.56+ Lua configuration) and **Caelestia Shell** (Quickshell / Qt6), styled with **Catppuccin Mocha** and **Material You** dynamic wallpaper theming.

---

## 📸 Desktop Overview

- **OS:** Fedora Linux (KDE Plasma base)
- **Window Manager:** [Hyprland](https://hyprland.org) (Native Lua Configuration: `hyprland.lua`)
- **Desktop Shell & Widgets:** [Caelestia Shell](https://github.com/caelestia-dots/shell) (built on [Quickshell](https://quickshell.outfoxxed.me))
- **CLI & Dynamic Themer:** [Caelestia CLI](https://github.com/caelestia-dots/cli) (Material You extraction)
- **Widget Style & Theme:** [Kvantum](https://github.com/tsujan/Kvantum) (`Catppuccin-Mocha-Blue`) & `qt6ct` / `qt5ct`
- **Default Browser:** [Zen Browser](https://zen-browser.app) (`zen-browser`)
- **Terminal Emulator:** [Kitty](https://sw.kovidgoyal.net/kitty/) & Foot
- **File Manager:** Dolphin
- **Icon Theme:** Papirus-Dark
- **Fonts:** Material Symbols Rounded, Rubik Variable, CaskaydiaCove Nerd Font

---

## ✨ Features & Customizations

### 1. Unified Dark Mode Across All Frameworks
- **Browsers & Modern Apps:** Configured `xdg-desktop-portal` so Zen Browser, Zed, Chrome, and Firefox immediately receive the FreeDesktop `prefer-dark` signal over D-Bus.
- **QtWidgets (Dolphin, Kate):** Styled with **Catppuccin Mocha Blue** via Kvantum and `qt6ct`.
- **Kirigami / QtQuick (System Settings, System Monitor):** Configured with native `org.kde.desktop` and `KDE_FULL_SESSION=true` to ensure full dark styling without QML crashes.
- **GTK 3 & GTK 4:** Pre-configured with `Breeze-Dark` and dark theme preference flags.

### 2. Ergonomic Trackpad Tuning
- Tuned `touchpadScrollFactor = 1.0` (up from Caelestia's default `0.3`), providing 3x faster, responsive two-finger scrolling.

### 3. Dynamic Material You Theming
- Wallpapers in `~/Pictures/Wallpapers/` dynamically generate unified Material You color palettes for the top bar, launcher, lockscreen, and window borders using `caelestia wallpaper`.

---

## ⌨️ Keybindings Cheat Sheet

### 🚀 Applications & Launchers
| Keybind | Action | Target App |
| :--- | :--- | :--- |
| **`Super + Space`** | **Toggle App Launcher** | Caelestia Launcher |
| **`Super + Return`** or **`Super + T`** | Open Terminal | `kitty` |
| **`Super + W`** or **`Super + B`** | Open Default Browser | `zen-browser` |
| **`Super + E`** | Open File Manager | `dolphin` |
| **`Super + C`** | Open Text Editor | `kate` |

### 🪟 Window Management
| Keybind | Action |
| :--- | :--- |
| **`Super + Q`** (or `Alt + F4`) | Close active window |
| **`Super + F`** | Toggle Fullscreen |
| **`Super + Alt + Space`** | Toggle Floating mode |
| **`Super + P`** | Pin window |
| **`Super + Left / Right / Up / Down`** | Move focus between windows |

### 📑 Workspaces
| Keybind | Action |
| :--- | :--- |
| **`Super + 1 ~ 9`** | Switch to workspace `1 ~ 9` |
| **`Super + Shift + 1 ~ 9`** | Move active window to workspace `1 ~ 9` |

### 🧰 Caelestia Widgets & Utilities
| Keybind | Action |
| :--- | :--- |
| **`Super + N`** | Toggle Nexus Sidebar (Quick Settings & Notifications) |
| **`Super + L`** | Lock Screen |
| **`Super + V`** | Clipboard History (`cliphist`) |
| **`Super + .`** | Emoji Picker |
| **`Print`** | Fullscreen Screenshot (`grim` + `swappy`) |
| **`Super + Shift + S`** | Interactive Region Screenshot |
| **`Ctrl + Super + Alt + R`** | Restart Caelestia Shell |
| **`Ctrl + Alt + Delete`** | Power / Session Menu |

---

## 🎨 Changing Wallpapers & Schemes

### Visual Picker (GUI)
1. Press `Super + Space` to open the launcher.
2. Type **`>wallpaper`** (or shorthand **`>w`**) to visually browse and apply wallpapers from `~/Pictures/Wallpapers/`.
3. Type **`>scheme`** to switch between preset color schemes (Catppuccin, TokyoNight, Nord, Dracula, Dynamic).

### Command Line (`caelestia` CLI)
```bash
# Set a specific wallpaper
caelestia wallpaper -f ~/Pictures/Wallpapers/Flow.jpg

# Switch scheme presets
caelestia scheme set -n catppuccin
caelestia scheme set -n tokyonight

# Return to adaptive Material You
caelestia scheme set -n dynamic -m dark
```

---

## 📁 Repository Structure

```text
.
├── .config/
│   ├── caelestia/                  # Custom user overrides & app definitions
│   │   ├── hypr-vars.lua           # Preferred apps, keybinds, and trackpad speed
│   │   ├── shell.json              # Wallpaper directory & shell appearance
│   │   └── cli.json                # Palette generation rules
│   │
│   ├── hypr/                       # Hyprland modular Lua configuration
│   │   ├── hyprland.lua            # Main entrypoint
│   │   ├── hyprland/
│   │   │   ├── keybinds.lua        # Shortcuts and dispatchers
│   │   │   ├── input.lua           # Touchpad, gestures, and mouse sensitivity
│   │   │   ├── env.lua             # Session environment variables
│   │   │   ├── decorations.lua     # Window borders, rounded corners, blur
│   │   │   ├── animations.lua      # Smooth window animations
│   │   │   └── rules.lua           # Window rules & floating behaviors
│   │   └── scheme/                 # Dynamic theme color injection
│   │
│   ├── quickshell/caelestia/       # Complete QML widget desktop shell
│   │   ├── shell.qml               # Root shell
│   │   ├── modules/                # Bar, Nexus, Launcher, Lock, Background
│   │   └── plugin/                 # C++ Qt6 QML plugins (Qalculator, Blobs, M3Shapes)
│   │
│   ├── Kvantum/                    # Catppuccin Mocha Qt theme engine config
│   ├── qt6ct/ & qt5ct/             # Qt dark palette definitions
│   ├── gtk-3.0/ & gtk-4.0/         # GTK dark styling & CSS
│   ├── environment.d/              # Systemd user session environment
│   └── systemd/user/               # Desktop portal systemd overrides
│
└── .gitignore
```

---

## 🛠️ Installation on Fedora

### 1. Enable Repositories & Install Dependencies
```bash
# Enable Hyprland COPR
sudo dnf copr enable sdegler/hyprland

# Install core packages and libraries
sudo dnf install -y \
  hyprland xdg-desktop-portal-hyprland xdg-desktop-portal-gtk \
  quickshell kvantum kvantum-qt5 qt6ct qt5ct \
  cmake ninja-build gcc-c++ git pkgconf-pkg-config \
  qt6-qtbase-devel qt6-qtdeclarative-devel qt6-qtshadertools-devel \
  qt6-qtimageformats qt6-qtsvg-devel \
  pipewire-devel libqalculate-devel aubio-devel \
  lm_sensors-devel NetworkManager-libnm-devel cava \
  swappy fish grim slurp wl-clipboard cliphist fuzzel \
  python3-build python3-installer python3-hatchling python3-hatch-vcs \
  python3-pillow python3-pip papirus-icon-theme google-rubik-fonts

# Install Python Material You color library
pip install --break-system-packages materialyoucolor
```

### 2. Install Caelestia CLI
```bash
git clone https://github.com/caelestia-dots/cli.git /tmp/caelestia-cli
cd /tmp/caelestia-cli
python3 -m build --wheel
sudo python3 -m installer dist/*.whl
```

### 3. Deploy Dotfiles
```bash
git clone https://github.com/aman-senpai/dotfile.git ~/dotfiles
cp -r ~/dotfiles/.config/* ~/.config/
```

### 4. Build Shell QML Plugins
```bash
cd ~/.config/quickshell/caelestia
cmake -B build -G Ninja -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/ -DINSTALL_QSCONFDIR="$HOME/.config/quickshell/caelestia"
cmake --build build
sudo cmake --install build
```

---

## 👤 Author
**Aman Senpai** ([@aman-senpai](https://github.com/aman-senpai))
