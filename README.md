# ASUS Keyboard Backlight Control

Automated keyboard backlight control for ASUS TUF laptops on Ubuntu Linux.

## What it does

- **Boot initialization**: Wakes up the keyboard controller automatically at boot
- **Static white backlight**: Sets keyboard to static white at brightness 3 on boot
- **F2/F3**: Brightness down/up (works natively via asus-nb-wmi)
- **F4 (Aura)**: Cycles through modes: Static → Breathe → Color Cycle → Static
- **State persistence**: Saves brightness and mode across reboots

## Requirements

- ASUS TUF laptop with RGB keyboard (tested on TUF A16 FA608PM)
- Ubuntu 22.04+ or similar Debian-based distro
- kernel with `asus-nb-wmi` driver

## Install

```bash
git clone https://github.com/Sambonic/asus-kbd-backlight.git
cd asus-kbd-backlight
sudo ./install.sh
```

The installer will:
1. Install dependencies (git, build-essential, libhidapi-dev, python3-evdev)
2. Build hidapitester
3. Copy service files to correct locations
4. Enable and start systemd services

## Uninstall

```bash
sudo ./uninstall.sh
```

## Manual mode control

```bash
# Static (mode 0)
echo "0 0 255 255 255 0" | sudo tee /sys/class/leds/asus::kbd_backlight/kbd_rgb_mode

# Breathe (mode 1)
echo "0 1 255 255 255 0" | sudo tee /sys/class/leds/asus::kbd_backlight/kbd_rgb_mode

# Color Cycle (mode 2)
echo "0 2 255 255 255 0" | sudo tee /sys/class/leds/asus::kbd_backlight/kbd_rgb_mode

# Brightness (0-3)
echo 3 | sudo tee /sys/class/leds/asus::kbd_backlight/brightness
```

## Mode format

`<save> <mode> <R> <G> <B> <speed>`

| Mode | Name | Description |
|------|------|-------------|
| 0 | Static | Solid color |
| 1 | Breathe | Fades in and out |
| 2 | Color Cycle | Cycles through RGB spectrum |

Speed: 0=slow, 1=medium, 2=fast (for breathe/cycle modes)

## State file

`/var/lib/asus-kbd/state` stores `<brightness> <mode>`

## Files

- `asus-kbd-backlight.service` - Boot initialization service
- `asus-aura-daemon.service` - F4 mode cycler service
- `asus-aura-daemon` - Python daemon that detects F4 (KEY_PROG4) and cycles modes
- `install.sh` - One-click installer
- `uninstall.sh` - Uninstaller
