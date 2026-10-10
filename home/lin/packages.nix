# home/lin/packages.nix
# User-level packages (not system-wide)

{ config, pkgs, lib, ... }:

{
  home.packages = with pkgs; [
    # CLI utilities
    tldr
    tealdeer
    bat
    exa
    eza
    fd
    ripgrep
    fzf
    zoxide
    starship
    direnv
    nix-direnv
    just
    tokei
    hyperfine
    dust
    procs
    sd
    choose
    zellij
    tmux

    # Development
    vscode
    jetbrains.idea-community  # Or pycharm, etc.
    insomnia  # API client
    postman   # Alternative

    # Media
    spotify
    obs-studio
    gimp
    inkscape
    blender
    kdenlive

    # Communication
    discord
    element-desktop
    signal-desktop
    thunderbird

    # System
    pavucontrol
    blueman
    networkmanagerapplet
    flameshot
    peek

    # Browsers
    brave
    librewolf

    # Note-taking
    obsidian
    # zettlr

    # Finance
    # gnucash

    # Fun
    cmatrix
    cowsay
    fortune
    lolcat
  ];
}
