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
    extraGSettingsPackages = with pkgs; [
      gnome.gnome-settings-daemon
      gnome.gnome-control-center
    ];
  };

  # ── GNOME services ─────────────────────────────────────────────────
  services.gnome.gnome-keyring.enable = true;
  services.gnome.tracker-miners.enable = false;  # Disable indexing (privacy)
  services.gnome.tracker.enable = false;

  # ── DConf defaults (GNOME settings from audit) ─────────────────────
  programs.dconf.enable = true;
  services.xserver.desktopManager.gnome.extraGSettingsOverrides = '''
    [org.gnome.desktop.interface]
    color-scheme='prefer-dark'
    clock-format='12h'
    clock-show-weekday=true
    clock-show-date=true
    font-name='Cantill 11'
    document-font-name='Cantill 11'
    cursor-theme='Adwaita'
    cursor-size=24
    gtk-theme='Adwaita'
    icon-theme='Adwaita'
    enable-animations=true
    enable-hot-corners=true

    [org.gnome.desktop.wm.preferences]
    button-layout='appmenu:minimize,maximize,close'
  ''';

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
      noto-fonts-emoji
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
    gnome.gnome-tweaks
    gnome.gnome-connections
    gnome.gnome-calculator
    gnome.gnome-calendar
    gnome.gnome-characters
    gnome.gnome-clocks
    gnome.gnome-contacts
    gnome.gnome-logs
    gnome.gnome-maps
    gnome.gnome-screenshot
    gnome.gnome-system-monitor
    gnome.gnome-text-editor
    gnome.gnome-weather
    gnome.nautilus
    gnome.eog          # Image viewer
    gnome.evince       # PDF viewer
    gnome.file-roller  # Archive manager
    gnome.totem        # Video player

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
  xdg.portal.extraPortals = lib.mkAfter [ pkgs.xdg-desktop-portal-gnome ];

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
