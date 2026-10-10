# modules/system/storage.nix
# Storage configuration module

{ config, pkgs, lib, ... }:

{
  # ── LVM support ────────────────────────────────────────────────────────
  # LVM is already configured in the host's fileSystems block
  # Ensure dm_mod is available
  boot.kernelModules = [ "dm_mod" ];

  # ── Filesystem tools ─────────────────────────────────────────────────
  environment.systemPackages = with pkgs; [
    lvm2
    e2fsprogs
    xfsprogs
    btrfs-progs
    dosfstools
    ntfs3g
    exfat
    cryptsetup
    mdadm
    parted
    gparted
  ];

  # ── FUSE ─────────────────────────────────────────────────────────────
  programs.fuse.userAllowOther = true;

  # ── Auto-mount ───────────────────────────────────────────────────────
  services.gvfs.enable = true;  # GNOME virtual filesystem
}
