# profiles/core.nix
# Core system profile — minimal baseline shared across all hosts
# Derived from Debian trixie base installation audit

{ config, pkgs, lib, ... }:

{
  # ── Boot ───────────────────────────────────────────────────────────
  # GRUB2 is the only bootloader (user preference)
  boot.loader.grub.configurationLimit = 10;
  boot.loader.grub.extraEntries = ''
    menuentry "Debian (fallback)" --class debian {
      search --set=root --fs-uuid e21be7f5-0d70-478f-b3a8-c374ca34bedc
      linux /vmlinuz root=/dev/mapper/lin--vg-root ro quiet
      initrd /initrd.img
    }
  '';

  # ── Nix ──────────────────────────────────────────────────────────────
  nix = {
    settings = {
      experimental-features = [ "nix-command" "flakes" "ca-derivations" ];
      auto-optimise-store = true;
      allowed-users = [ "lin" "root" ];
      trusted-users = [ "lin" "root" ];
      substituters = [
        "https://cache.nixos.org"
        "https://nix-community.cachix.org"
      ];
      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
    optimise.automatic = true;
  };

  # ── System packages (Debian trixie equivalents) ──────────────────────
  environment.systemPackages = with pkgs; [
    # Core utilities
    coreutils-full
    util-linux
    gnumake
    gnugrep
    gnused
    gawk
    findutils
    diffutils
    patch
    which
    file
    less
    more
    man
    man-db

    # Compression / archiving
    gnutar
    gzip
    bzip2
    xz
    zip
    unzip
    p7zip

    # Networking
    curl
    wget
    rsync
    netcat-openbsd
    bind.dnsutils
    openssl
    cacert  # CA certificates bundle

    # Monitoring
    htop
    btop
    iotop
    lsof
    pciutils
    usbutils
    dmidecode
    smartmontools

    # Shell & CLI
    bash
    bash-completion
    eza
    fd
    ripgrep
    fzf
    jq
    yq-go
    tree
    ncdu

    # Text editors
    vim
    neovim

    # Version control
    git
    git-lfs
    gh

    # System administration
    sudo
    polkit
    systemd

    # Security basics
    gnupg
    pass
    age
    ssh-to-age
    sops
    openssl
    openssh

    # Hardware info
    cpufetch
    inxi
    lshw
    hwinfo
  ];

  # ── Programs ────────────────────────────────────────────────────────
  programs.bash = {
    enableCompletion = true;
    # promptInit = "";
  };

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  programs.git = {
    enable = true;
    config = {
      init.defaultBranch = "main";
      user.name = "stefan-hacks";
      user.email = "stefan-hacks@users.noreply.github.com";
      credential."https://github.com".helper = "!gh auth git-credential";
      push.autoSetupRemote = true;
      pull.rebase = true;
      core.editor = "nvim";
    };
  };

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
  };

  programs.htop.enable = true;
  programs.iotop.enable = true;

  # ── Services ─────────────────────────────────────────────────────────
  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "prohibit-password";
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      X11Forwarding = true;
    };
  };

  # ── Networking ─────────────────────────────────────────────────────
  networking.networkmanager.enable = true;
  networking.useDHCP = lib.mkDefault true;
  networking.firewall = {
    enable = true;
    allowPing = true;
  };

  # ── Time ─────────────────────────────────────────────────────────────
  services.timesyncd.enable = true;

  # ── Logging ────────────────────────────────────────────────────────
  services.journald.extraConfig = "SystemMaxUse=500M\nSystemMaxFileSize=50M\nMaxRetentionSec=1month";

  # ── Log rotation ─────────────────────────────────────────────────────
  services.logrotate.enable = true;

  # ── Locales ────────────────────────────────────────────────────────
  i18n.supportedLocales = [
    "en_US.UTF-8/UTF-8"
  ];

  # ── Console font ─────────────────────────────────────────────────────
  console.font = "Lat2-Terminus16";

  # ── Security: basic sudo ─────────────────────────────────────────────
  security.sudo = {
    enable = true;
    wheelNeedsPassword = true;
    extraRules = [{
      groups = [ "wheel" ];
      commands = [ { command = "ALL"; options = [ "NOPASSWD" "SETENV" ]; } ];
    }];
  };

  # ── Security: polkit ───────────────────────────────────────────────
  security.polkit.enable = true;
}
