# profiles/desktop.nix
# Desktop / graphical workstation profile
# GNOME 48 + Wayland + PipeWire (matching current Debian setup)
# AMD Radeon 680M — mesa/amdvlk stack

{ config, pkgs, lib, ... }:

{
  # ── X11 / Wayland ────────────────────────────────────────────────────
  services.xserver = {
    enable = true;
    xkb = {
      layout = "us";
      variant = "";
      options = "";
    };
  };

  # ── GNOME Desktop ──────────────────────────────────────────────────
  # services.xserver.displayManager.gdm.enable = true;
  # services.xserver.desktopManager.gnome.enable = true;

  # NixOS 24.11+ option names for GNOME
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome = {
    enable = true;
    # Enable core apps
    extraGSettingsOverridePackages = with pkgs; [
      gnome-settings-daemon
      gnome-control-center
    ];
  };

  # ── GNOME services ─────────────────────────────────────────────────
  services.gnome.gnome-keyring.enable = true;
  services.gnome.tracker-miners.enable = false;  # Disable indexing (privacy)
  services.gnome.tracker.enable = false;

  # ── DConf defaults (GNOME settings from audit) ─────────────────────
  # GSettings overrides are managed via Home Manager dconf (see home/lin/desktop.nix)
  programs.dconf.enable = true;
  # services.xserver.desktopManager.gnome.extraGSettingsOverrides = "";

  # ── XDG portal ─────────────────────────────────────────────────────
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gnome
      xdg-desktop-portal-gtk
    ];
    config.common.default = "*";
  };

  # ── Fonts ──────────────────────────────────────────────────────────
  fonts = {
    packages = with pkgs; [
      cantarell-fonts
      dejavu_fonts
      liberation_ttf
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-color-emoji
      source-code-pro
      font-awesome
    ];
    fontconfig = {
      enable = true;
      defaultFonts = {
        sansSerif = [ "Cantarell" "DejaVu Sans" ];
        serif = [ "DejaVu Serif" ];
        monospace = [ "Source Code Pro" "DejaVu Sans Mono" ];
        emoji = [ "Noto Color Emoji" ];
      };
    };
  };

  # ── Desktop packages (from Debian audit) ─────────────────────────────
  environment.systemPackages = with pkgs; [
    # Browsers
    chromium
    firefox

    # GNOME ecosystem
    gnome-tweaks
    gnome-connections
    gnome-calculator
    gnome-calendar
    gnome-characters
    gnome-clocks
    gnome-contacts
    gnome-logs
    gnome-maps
    gnome-screenshot
    gnome-system-monitor
    gnome-text-editor
    gnome-weather
    nautilus
    eog          # Image viewer
    evince       # PDF viewer
    file-roller  # Archive manager
    totem        # Video player

    # Media
    vlc
    mpv
    ffmpeg
    imagemagick

    # Communication
    # (Discord handled via Flatpak or web)

    # Office
    libreoffice

    # Theming
    adwaita-icon-theme
    adwaita-qt
    papirus-icon-theme

    # Utilities
    pavucontrol
    wl-clipboard
    grim
    slurp
  ];

  # ── Flatpak support ──────────────────────────────────────────────────
  services.flatpak.enable = true;
  # xdg-desktop-portal-gnome already listed above

  # ── Wayland-specific ─────────────────────────────────────────────────
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";  # Electron apps use Wayland
    MOZ_ENABLE_WAYLAND = "1";
    QT_QPA_PLATFORM = "wayland;xcb";
  };

  # ── AppArmor (Debian has apparmor enabled) ─────────────────────────
  security.apparmor = {
    enable = true;
    packages = [ pkgs.apparmor-utils pkgs.apparmor-profiles ];
  };

  # ── Accessibility ──────────────────────────────────────────────────
  services.blueman.enable = true;
}
