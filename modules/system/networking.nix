# modules/system/networking.nix
# Network configuration module

{ config, pkgs, lib, ... }:

{
  # ── NetworkManager ───────────────────────────────────────────────────
  networking.networkmanager = {
    enable = true;
    dns = "systemd-resolved";
    wifi = {
      powersave = true;
      scanRandMacAddress = true;
      backend = "iwd";  # Use iwd instead of wpa_supplicant
    };
  };

  # ── Systemd-resolved ───────────────────────────────────────────────
  services.resolved = {
    enable = true;
    dnssec = "true";
    domains = [ "~." ];
    fallbackDns = [ "1.1.1.1" "8.8.8.8" ];
  };

  # ── Hostname ─────────────────────────────────────────────────────────
  networking.hostName = "lin";

  # ── Firewall (nftables-based, enabled in hardening.nix) ──────────
  # Additional rules can be added here per-host

  # ── VPN support ──────────────────────────────────────────────────────
  # Mullvad VPN configured in server.nix
  # WireGuard tools available
  networking.wireguard.enable = true;

  # ── Avahi (mDNS) ─────────────────────────────────────────────────────
  services.avahi = {
    enable = true;
    nssmdns = true;
    publish = {
      enable = true;
      addresses = true;
      workstation = true;
    };
  };
}
