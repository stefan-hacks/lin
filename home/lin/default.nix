# home/lin/default.nix
# Home Manager configuration for user 'lin'

{ config, pkgs, lib, ... }:

{
  imports = [
    ./packages.nix
    ./programs.nix
    ./services.nix
    ./desktop.nix
    ./shell.nix
    ./secrets.nix
  ];

  # ── Identity ────────────────────────────────────────────────────────
  home.username = "lin";
  home.homeDirectory = "/home/lin";
  home.stateVersion = "24.11";

  # ── Session variables ──────────────────────────────────────────────
  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
    TERMINAL = "kitty";
    BROWSER = "firefox";
    PAGER = "less -R --mouse";
    MOZ_ENABLE_WAYLAND = "1";
    NIXOS_OZONE_WL = "1";
    QT_QPA_PLATFORM = "wayland;xcb";
    RUST_BACKTRACE = "1";
    CARGO_HOME = "$HOME/.cargo";
    GOPATH = "$HOME/go";
  };

  # ── File creation ──────────────────────────────────────────────────
  home.file = {
    # Git config (already in system programs.git, but can override here)
    ".config/git/ignore".text = ''''
      *.swp
      *~
      .DS_Store
      Thumbs.db
    ''';
  };

  # ── Allow unfree packages for user ─────────────────────────────────
  nixpkgs.config.allowUnfree = true;

  # ── Enable Home Manager ────────────────────────────────────────────
  programs.home-manager.enable = true;
}
