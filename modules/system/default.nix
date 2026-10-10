# modules/system/default.nix
# Reusable system-level modules for all NixOS hosts

{ config, pkgs, lib, ... }:

{
  imports = [
    ./networking.nix
    ./storage.nix
    ./users.nix
  ];

  # ── System-wide environment ────────────────────────────────────────────
  environment.variables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
    PAGER = "less";
    LESS = "-R --mouse";
    MOZ_ENABLE_WAYLAND = "1";
    NIXOS_OZONE_WL = "1";
    QT_QPA_PLATFORM = "wayland;xcb";
    XDG_CONFIG_DIRS = [
      "/etc/xdg"
      "/run/current-system/sw/etc/xdg"
    ];
    XDG_DATA_DIRS = [
      "/usr/local/share"
      "/usr/share"
      "/run/current-system/sw/share"
    ];
  };

  # ── Shell aliases (minimal — full aliases in Home Manager) ──────────
  environment.shellAliases = {
    ll = "ls -la";
    la = "ls -a";
    l = "ls -CF";
    grep = "grep --color=auto";
    fgrep = "fgrep --color=auto";
    egrep = "egrep --color=auto";
  };

  # ── Etc files ────────────────────────────────────────────────────────
  environment.etc = {
    "issue".text = ''''
      \4{1} (\n) on \l
    ''';
  };

  # ── Systemd defaults ─────────────────────────────────────────────────
  systemd.extraConfig = ''''
    [Manager]
    DefaultTimeoutStartSec=30s
    DefaultTimeoutStopSec=30s
  ''';

  # ── Udisks (auto-mount removable media) ──────────────────────────────
  services.udisks2.enable = true;
  services.devmon.enable = true;
}
