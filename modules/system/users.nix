# modules/system/users.nix
# User management module

{ config, pkgs, lib, ... }:

{
  # ── User 'lin' is defined in hosts/lin/default.nix ─────────────────
  # This module handles group definitions and shared policies

  users.groups = {
    lin = { gid = 1000; };
    jellyfin = { gid = 117; };
    ollama = { gid = 989; };
    libvirt = { gid = 121; };
    nix-users = { gid = 985; };
    render = { gid = 992; };
  };

  # ── User shell defaults ──────────────────────────────────────────────
  users.defaultUserShell = pkgs.bash;

  # ── Mutable users ────────────────────────────────────────────────────
  # Allow password changes and useradd after initial install
  users.mutableUsers = true;
}
