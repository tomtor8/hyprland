#!/usr/bin/env fish

# Wait for Hyprland socket and D-Bus environment to settle
sleep 2

# Pass Wayland variables to systemd user session
dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=Hyprland
systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP

# Gracefully restart portal systemd units in order
systemctl --user stop xdg-desktop-portal-hyprland xdg-desktop-portal
systemctl --user start xdg-desktop-portal-hyprland
systemctl --user start xdg-desktop-portal
