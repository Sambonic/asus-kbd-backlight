#!/bin/bash
set -e

echo "=== ASUS Keyboard Backlight Uninstaller ==="

echo "[1/4] Stopping and disabling services..."
sudo systemctl stop asus-aura-daemon.service 2>/dev/null || true
sudo systemctl stop asus-kbd-backlight.service 2>/dev/null || true
sudo systemctl disable asus-aura-daemon.service 2>/dev/null || true
sudo systemctl disable asus-kbd-backlight.service 2>/dev/null || true

echo "[2/4] Removing files..."
sudo rm -f /etc/systemd/system/asus-kbd-backlight.service
sudo rm -f /etc/systemd/system/asus-aura-daemon.service
sudo rm -f /usr/local/bin/asus-aura-daemon

echo "[3/4] Removing state..."
sudo rm -rf /var/lib/asus-kbd

echo "[4/4] Reloading systemd..."
sudo systemctl daemon-reload

echo ""
echo "=== Uninstall complete ==="
