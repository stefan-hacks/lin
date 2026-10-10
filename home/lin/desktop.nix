# home/lin/desktop.nix
# Desktop environment and GNOME-specific user configuration

{ config, pkgs, lib, ... }:

{
  # ── GNOME dconf settings (from Debian audit) ─────────────────────
  # NOTE: Font and theme settings are managed by programs.gtk below.
  # Only set GNOME-specific / non-GTK dconf settings here.
  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      clock-format = "12h";
      clock-show-weekday = true;
      clock-show-date = true;
      clock-show-seconds = false;
      cursor-theme = lib.mkForce "Adwaita";
      cursor-size = 24;
      enable-animations = true;
      enable-hot-corners = true;
      font-antialiasing = "grayscale";
      font-hinting = "slight";
      font-rgba-order = "rgb";
      show-battery-percentage = true;
    };

    "org/gnome/desktop/wm/preferences" = {
      button-layout = "appmenu:minimize,maximize,close";
      num-workspaces = 4;
    };

    "org/gnome/desktop/background" = {
      picture-options = "zoom";
      primary-color = "#1e1e2e";
    };

    "org/gnome/desktop/session" = {
      idle-delay = 300;  # 5 minutes
    };

    "org/gnome/desktop/screensaver" = {
      lock-enabled = true;
      lock-delay = 0;
      idle-activation-enabled = true;
    };

    "org/gnome/desktop/peripherals/touchpad" = {
      tap-to-click = true;
      natural-scroll = true;
    };

    "org/gnome/desktop/input-sources" = {
      sources = [ (lib.hm.gvariant.mkTuple [ "xkb" "us" ]) ];
      xkb-options = [ "ctrl:nocaps" ];  # Caps Lock → Ctrl
    };

    "org/gnome/mutter" = {
      experimental-features = [ "scale-monitor-framebuffer" ];
    };

    "org/gnome/settings-daemon/plugins/power" = {
      sleep-inactive-ac-timeout = 1800;
      sleep-inactive-battery-timeout = 900;
      power-button-action = "interactive";
    };

    "org/gnome/shell" = {
      favorite-apps = [
        "firefox.desktop"
        "chromium.desktop"
        "org.gnome.Console.desktop"
        "org.gnome.Nautilus.desktop"
        "code.desktop"
        "com.spotify.Client.desktop"
        "org.gnome.Settings.desktop"
      ];
      disable-user-extensions = false;
    };
  };

  # ── GTK theme ──────────────────────────────────────────────────────
  gtk = {
    enable = true;
    theme = {
      name = "Adwaita-dark";
      package = pkgs.gnome-themes-extra;
    };
    iconTheme = {
      name = "Adwaita";
      package = pkgs.adwaita-icon-theme;
    };
    font = {
      name = "Cantarell 11";
      package = pkgs.cantarell-fonts;
    };
  };

  # ── Qt theme ───────────────────────────────────────────────────────
  qt = {
    enable = true;
    platformTheme.name = "gtk";
    style = {
      name = "adwaita-dark";
      package = pkgs.adwaita-qt;
    };
  };

  # ── XDG user directories ───────────────────────────────────────────
  xdg = {
    enable = true;
    userDirs = {
      enable = true;
      createDirectories = true;
      desktop = "${config.home.homeDirectory}/Desktop";
      documents = "${config.home.homeDirectory}/Documents";
      download = "${config.home.homeDirectory}/Downloads";
      music = "${config.home.homeDirectory}/Music";
      pictures = "${config.home.homeDirectory}/Pictures";
      videos = "${config.home.homeDirectory}/Videos";
      templates = "${config.home.homeDirectory}/Templates";
      publicShare = "${config.home.homeDirectory}/Public";
    };
    mimeApps = {
      enable = true;
      defaultApplications = {
        "text/html" = "firefox.desktop";
        "x-scheme-handler/http" = "firefox.desktop";
        "x-scheme-handler/https" = "firefox.desktop";
        "application/pdf" = "org.gnome.Evince.desktop";
        "image/jpeg" = "org.gnome.eog.desktop";
        "image/png" = "org.gnome.eog.desktop";
        "text/plain" = "org.gnome.TextEditor.desktop";
      };
    };
  };
}
