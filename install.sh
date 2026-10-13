#!/bin/bash
set -e

echo "=== ASUS Keyboard Backlight Installer ==="

echo "[1/6] Installing dependencies..."
sudo apt update -qq
sudo apt install -y -qq git build-essential pkg-config libhidapi-dev libudev-dev python3-evdev

echo "[2/6] Building hidapitester..."
cd /tmp
rm -rf hidapitester hidapi
git clone --depth 1 https://github.com/todbot/hidapitester.git
git clone --depth 1 https://github.com/libusb/hidapi.git
cd /tmp/hidapitester
make

echo "[3/6] Installing files..."
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
sudo cp /tmp/hidapitester/hidapitester /usr/local/bin/hidapitester
sudo chmod +x /usr/local/bin/hidapitester
sudo cp "$SCRIPT_DIR/asus-kbd-backlight.service" /etc/systemd/system/
sudo cp "$SCRIPT_DIR/asus-aura-daemon.service" /etc/systemd/system/
sudo cp "$SCRIPT_DIR/asus-aura-daemon" /usr/local/bin/
sudo chmod +x /usr/local/bin/asus-aura-daemon

echo "[4/6] Installing sleep/resume hook..."
sudo cp "$SCRIPT_DIR/asus-kbd-sleep" /usr/lib/systemd/system-sleep/asus-kbd-sleep
sudo chmod +x /usr/lib/systemd/system-sleep/asus-kbd-sleep

echo "[5/6] Initializing state..."
sudo mkdir -p /var/lib/asus-kbd
echo "3 0" | sudo tee /var/lib/asus-kbd/state

echo "[6/6] Enabling services..."
sudo systemctl daemon-reload
sudo systemctl enable asus-kbd-backlight.service
sudo systemctl enable asus-aura-daemon.service
sudo systemctl start asus-kbd-backlight.service
sudo systemctl start asus-aura-daemon.service

echo ""
echo "=== Installation complete ==="
echo "F2: brightness down | F3: brightness up | F4: cycle mode"
