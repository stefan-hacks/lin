# hosts/lin/default.nix
# Machine-specific configuration for 'lin'
# AMD Ryzen 7 6800H | Radeon 680M | 27GB RAM | Micron 2550 NVMe
# Debian trixie → NixOS migration target

{ config, pkgs, lib, ... }:

{
  imports = [
    # Hardware quirks for AMD Rembrandt + Radeon 680M
    ./hardware.nix
  ];

  # ── Host identity ────────────────────────────────────────────────────
  networking.hostName = "lin";
  networking.hostId = "cafebabe";  # Required for ZFS (placeholder)

  # ── Bootloader ───────────────────────────────────────────────────────
  # Current Debian uses GRUB2 — keep GRUB2 for familiarity
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "nodev";
  boot.loader.grub.efiSupport = true;
  boot.loader.grub.useOSProber = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";

  # ── Kernel ─────────────────────────────────────────────────────────
  # Debian runs 6.12.107 — NixOS default is close; pin for stability
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernelParams = [
    "noresume"
    "nohibernate"
    "quiet"
    "amdgpu.sg_display=0"  # Fix for some Rembrandt display issues
  ];

  # ── Initrd ───────────────────────────────────────────────────────────
  boot.initrd.availableKernelModules = [
    "nvme"
    "xhci_pci"
    "thunderbolt"
    "usb_storage"
    "sd_mod"
    "sdhci_pci"
  ];

  # ── Filesystems (matching current Debian LVM layout) ────────────────
  # NOTE: These UUIDs match the LIVE Debian machine — verify before install
  fileSystems."/" = {
    device = "/dev/disk/by-uuid/4a7bb303-1a45-4d28-a157-0fbde3666d13";
    fsType = "ext4";
    options = [ "noatime" "errors=remount-ro" ];
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/e21be7f5-0d70-478f-b3a8-c374ca34bedc";
    fsType = "ext4";
    options = [ "noatime" ];
  };

  fileSystems."/boot/efi" = {
    device = "/dev/disk/by-uuid/8AF8-BBF8";
    fsType = "vfat";
    options = [ "umask=0077" "noatime" ];
  };

  swapDevices = [
    { device = "/dev/disk/by-uuid/b7febb4e-1c4d-4fe2-ba50-3ec91086d6ae"; }
  ];

  # ── ZFS support (disabled by default — enable if adding pools) ─────
  # boot.supportedFilesystems = [ "zfs" ];
  # services.zfs.autoScrub.enable = true;

  # ── Console / TTY ────────────────────────────────────────────────────
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  # ── Locale ─────────────────────────────────────────────────────────
  time.timeZone = "America/Sao_Paulo";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # ── Users ──────────────────────────────────────────────────────────
  users.users.lin = {
    isNormalUser = true;
    description = "lin";
    extraGroups = [
      "wheel"
      "networkmanager"
      "audio"
      "video"
      "plugdev"
      "kvm"
      "libvirt"
      "docker"
      "podman"
      "bluetooth"
      "scanner"
      "lpadmin"
      "nix-users"
      "ollama"
      "jellyfin"
      "netdev"
      "cdrom"
      "floppy"
      "dip"
      "users"
    ];
    shell = pkgs.bash;
    # SSH public key for remote access
    openssh.authorizedKeys.keys = [
      # Add your SSH pubkey here
      # "ssh-ed25519 AAAAC3..."
    ];
  };

  # ── Mutable user password (set on first boot via passwd) ─────────────
  users.mutableUsers = true;

  # ── State version (matches NixOS release for this config) ────────────
  system.stateVersion = "24.11";
}
