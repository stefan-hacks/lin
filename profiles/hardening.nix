# profiles/hardening.nix
# Security hardening profile
# Replicates Debian security posture: AppArmor, fail2ban, lynis, nftables

{ config, pkgs, lib, ... }:

{
  # ── Boot hardening ───────────────────────────────────────────────────
  boot.kernel.sysctl = {
    # Kernel hardening
    "kernel.kptr_restrict" = 2;
    "kernel.dmesg_restrict" = 1;
    "kernel.printk" = "3 3 3 3";
    "kernel.unprivileged_bpf_disabled" = 1;
    "kernel.yama.ptrace_scope" = 2;
    "kernel.sysrq" = 0;

    # Network hardening
    "net.ipv4.conf.all.rp_filter" = 1;
    "net.ipv4.conf.default.rp_filter" = 1;
    "net.ipv4.conf.all.accept_source_route" = 0;
    "net.ipv4.conf.default.accept_source_route" = 0;
    "net.ipv4.conf.all.accept_redirects" = 0;
    "net.ipv4.conf.default.accept_redirects" = 0;
    "net.ipv4.conf.all.send_redirects" = 0;
    "net.ipv4.conf.default.send_redirects" = 0;
    "net.ipv4.icmp_echo_ignore_broadcasts" = 1;
    "net.ipv4.icmp_ignore_bogus_error_responses" = 1;
    "net.ipv4.tcp_syncookies" = 1;
    "net.ipv4.tcp_rfc1337" = 1;
    "net.ipv4.ip_forward" = 0;
    "net.ipv6.conf.all.accept_source_route" = 0;
    "net.ipv6.conf.default.accept_source_route" = 0;
    "net.ipv6.conf.all.accept_redirects" = 0;
    "net.ipv6.conf.default.accept_redirects" = 0;

    # Memory
    "vm.mmap_rnd_bits" = 32;
    "vm.mmap_rnd_compat_bits" = 16;
    "vm.swappiness" = 10;
    "vm.unprivileged_userfaultfd" = 0;

    # FS
    "fs.protected_hardlinks" = 1;
    "fs.protected_symlinks" = 1;
    "fs.suid_dumpable" = 0;
  };

  # ── Boot parameters ──────────────────────────────────────────────────
  boot.kernelParams = [
    "quiet"
    "noresume"
    "nohibernate"
    "slub_debug=FZ"
    "init_on_alloc=1"
    "init_on_free=1"
    "page_alloc.shuffle=1"
    "randomize_kstack_offset=on"
    "vsyscall=none"
    "debugfs=off"
    "lockdown=integrity"
  ];

  # ── Security modules ─────────────────────────────────────────────────
  security.apparmor = {
    enable = true;
    killUnconfinedConfinables = true;
    packages = with pkgs; [
      apparmor-utils
      apparmor-profiles
      apparmor-parser
    ];
  };

  # ── Audit framework ──────────────────────────────────────────────────
  security.auditd.enable = true;
  security.audit = {
    enable = true;
    rules = [
      # Track authentication events
      "-a always,exit -F arch=b64 -S setuid -S setgid -S setreuid -S setregid -k identity"
      "-a always,exit -F arch=b64 -S execve -k exec"
      "-w /etc/passwd -p wa -k identity"
      "-w /etc/shadow -p wa -k identity"
      "-w /etc/group -p wa -k identity"
      "-w /etc/sudoers -p wa -k sudoers"
      # Track file integrity
      "-w /etc/ssh/sshd_config -p wa -k ssh-config"
    ];
  };

  # ── PAM hardening ──────────────────────────────────────────────────
  security.pam.services.sudo = {
    # Require strong passwords (if setting passwords)
    # text = ''
    #   auth required pam_unix.so
    # '';
  };

  # ── Sudo hardening ───────────────────────────────────────────────────
  security.sudo.extraConfig = "Defaults log_input,log_output\nDefaults logfile=\"/var/log/sudo-io\"\nDefaults timestamp_timeout=5\nDefaults requiretty";

  # ── SSH hardening (overrides core.nix) ───────────────────────────────
  services.openssh.settings = {
    PermitRootLogin = lib.mkForce "no";
    PasswordAuthentication = false;
    PubkeyAuthentication = true;
    X11Forwarding = lib.mkForce false;
    AllowTcpForwarding = "local";
    MaxAuthTries = 3;
    LoginGraceTime = 30;
    ClientAliveInterval = 300;
    ClientAliveCountMax = 2;
    Banner = null;
  };

  # ── Firewall (nftables-based) ─────────────────────────────────────
  networking.firewall = {
    enable = true;
    allowPing = true;
    # Default: drop all incoming
    # Specific ports opened in server.nix
    # Connection tracking
    logRefusedConnections = true;
    logRefusedPackets = true;
  };

  # ── UFW-style wrapper (not needed with NixOS firewall) ─────────────
  # NixOS uses its own nftables-based firewall

  # ── Automatic updates ──────────────────────────────────────────────
  # NixOS handles this via nix.gc + nix.optimise
  # For system updates:
  system.autoUpgrade = {
    enable = false;  # Manual upgrade policy
    # flake = inputs.self.outPath;
    # flags = [ "--update-input" "nixpkgs" "--no-write-lock-file" ];
    # allowReboot = false;
  };

  # ── Lynis audit scheduling ───────────────────────────────────────────
  systemd.services.lynis-audit = {
    description = "Periodic Lynis security audit";
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.lynis}/bin/lynis audit system --quiet --no-colors --report-file /var/log/lynis-report.dat";
    };
  };
  systemd.timers.lynis-audit = {
    description = "Weekly Lynis audit";
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "weekly";
      Persistent = true;
    };
  };

  # ── AIDE file integrity ──────────────────────────────────────────────
  # NOTE: services.aide is not available in nixpkgs.
  # Install aide package and configure manually, or use a custom module.
  # packages.aide is available in environment.systemPackages above.

  # ── Hardening packages ───────────────────────────────────────────────
  environment.systemPackages = with pkgs; [
    lynis
    # chkrootkit removed (unmaintained upstream)
    # rkhunter removed (unmaintained upstream)
    aide
    clamav
    clamtk
    nftables
    tcpdump
    wireshark
    nmap
  ];
}
