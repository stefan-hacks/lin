# profiles/server.nix
# Server / daemon profile
# Jellyfin, Apache, Ollama, Homepage, Guacamole, ROS Linux container

{ config, pkgs, lib, ... }:

{
  # ── Jellyfin Media Server ────────────────────────────────────────────
  services.jellyfin = {
    enable = true;
    openFirewall = true;
    # Data directories (Jellyfin defaults under /var/lib/jellyfin)
    # Cache and metadata are stored there automatically
  };

  # ── Apache HTTP Server ───────────────────────────────────────────────
  services.httpd = {
    enable = true;
    adminAddr = "webmaster@localhost";
    # DocumentRoot is set in the default virtual host config
    # extraConfig = "";
  };

  # Ensure /var/www/html exists
  systemd.tmpfiles.rules = [
    "d /var/www/html 0755 root root -"
  ];

  # ── Ollama (local LLM inference) ─────────────────────────────────
  services.ollama = {
    enable = true;
    openFirewall = true;
    # Listen on all interfaces (for local network access)
    host = "0.0.0.0";
    port = 11434;
    # AMD ROCm package
    package = pkgs.ollama-rocm;
  };

  # ── Homepage dashboard ───────────────────────────────────────────────
  # Homepage is currently running as a Podman container.
  # In NixOS, we can use a systemd service with the container image.
  # Alternatively, use services.homepage-dashboard if available in nixpkgs.
  # services.homepage-dashboard.enable = true;  # Check nixpkgs availability

  # ── Mullvad VPN (client) ───────────────────────────────────────────
  services.mullvad-vpn = {
    enable = true;
    # GUI is enabled by default; package auto-configured
  };

  # ── Fail2ban ─────────────────────────────────────────────────────────
  services.fail2ban = {
    enable = true;
    maxretry = 3;
    bantime = "1h";
    jails = {
      sshd = {
        enabled = true;
        settings = {
          port = "22";
          filter = "sshd";
          logpath = "/var/log/auth.log";
          maxretry = 3;
        };
      };
    };
  };

  # ── DNSmasq (local DNS caching) ────────────────────────────────────
  # services.dnsmasq.enable = true;

  # ── Smartmontools ────────────────────────────────────────────────────
  services.smartd = {
    enable = true;
    notifications.mail = {
      enable = false;
    };
  };

  # ── Cron / scheduled tasks ─────────────────────────────────────────
  services.cron = {
    enable = true;
    systemCronJobs = [
      # Daily logrotate
      "0 0 * * * root ${pkgs.logrotate}/sbin/logrotate /etc/logrotate.conf"
      # Weekly plocate update
      "15 4 * * 1 root ${config.services.locate.package}/bin/updatedb"
    ];
  };

  # ── Plocate (file search) ────────────────────────────────────────────
  services.locate = {
    enable = true;
    package = pkgs.plocate;
    interval = "weekly";
  };

  # ── System statistics ──────────────────────────────────────────────
  services.sysstat.enable = true;

  # ── Container services (Podman systemd quadlets) ───────────────────
  # Homepage container
  # systemd.services.homepage = {
  #   description = "Homepage dashboard";
  #   after = [ "network.target" ];
  #   wantedBy = [ "multi-user.target" ];
  #   serviceConfig = {
  #     ExecStart = "${pkgs.podman}/bin/podman run --rm --name homepage -p 3000:3000 ghcr.io/gethomepage/homepage:latest";
  #     ExecStop = "${pkgs.podman}/bin/podman stop -t 30 homepage";
  #     Restart = "always";
  #     User = "lin";
  #   };
  # };

  # Guacamole container
  # systemd.services.guacamole = {
  #   description = "Apache Guacamole";
  #   after = [ "network.target" ];
  #   wantedBy = [ "multi-user.target" ];
  #   serviceConfig = {
  #     ExecStart = "${pkgs.podman}/bin/podman run --rm --name guacamole -p 8080:8080 docker.io/oznu/guacamole:latest";
  #     ExecStop = "${pkgs.podman}/bin/podman stop -t 30 guacamole";
  #     Restart = "always";
  #     User = "lin";
  #   };
  # };

  # ── Open ports for services ──────────────────────────────────────────
  networking.firewall.allowedTCPPorts = [
    22      # SSH
    80      # HTTP (Apache)
    8080    # Guacamole
    8081    # ROS Linux (mapped)
    9090    # ROS Linux cockpit
    9091    # ROS Linux cockpit (mapped)
    3000    # Homepage
    11434   # Ollama
    8096    # Jellyfin
    8920    # Jellyfin HTTPS
    1900    # Jellyfin DLNA
    7359    # Jellyfin auto-discovery
  ];

  networking.firewall.allowedUDPPorts = [
    1900    # Jellyfin DLNA
    7359    # Jellyfin auto-discovery
  ];

  # ── Server packages ──────────────────────────────────────────────────
  environment.systemPackages = with pkgs; [
    jellyfin
    jellyfin-ffmpeg
    apacheHttpd
    ollama
    mullvad-vpn
    fail2ban
    smartmontools
    lynis
    # chkrootkit removed (unmaintained upstream)
    aide
  ];
}
