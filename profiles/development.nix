# profiles/development.nix
# Development toolchain profile
# Rust, Go, Python, Nix tooling — matching current Debian install

{ config, pkgs, lib, ... }:

{
  # ── Build essentials ─────────────────────────────────────────────────
  environment.systemPackages = with pkgs; [
    # Compilers
    gcc
    gnumake
    cmake
    ninja
    pkg-config

    # Rust (stable)
    rustc
    cargo
    rustfmt
    clippy
    rust-analyzer
    # rustup  # Use rustup if you need multiple toolchains

    # Go
    go
    gopls
    delve
    golangci-lint

    # Python
    python3
    python3Packages.pip
    python3Packages.virtualenv
    python3Packages.ipython
    python3Packages.black
    python3Packages.flake8
    python3Packages.pytest
    python3Packages.mypy

    # Node.js (not on Debian but common)
    # nodejs
    # yarn
    # pnpm

    # Nix tooling
    nixpkgs-fmt
    nixd
    nil
    alejandra
    nix-output-monitor
    nix-tree
    nix-index
    comma

    # Version control
    git
    git-lfs
    gh
    pre-commit
    tig
    lazygit

    # Container tooling
    podman
    podman-compose
    buildah
    skopeo
    dive

    # Database clients
    sqlite
    postgresql
    redis

    # Debugging / profiling
    gdb
    lldb
    valgrind
    strace
    ltrace
    perf-tools
    bpftrace

    # Misc dev tools
    tmux
    direnv
    nix-direnv
    just
    gnum4
    automake
    autoconf
    libtool
    gettext
  ];

  # ── Rust environment ─────────────────────────────────────────────────
  environment.sessionVariables = {
    RUST_BACKTRACE = "1";
    CARGO_HOME = "$HOME/.cargo";
    RUSTUP_HOME = "$HOME/.rustup";
  };

  # ── Go environment ─────────────────────────────────────────────────────
  environment.sessionVariables.GOPATH = "$HOME/go";

  # ── Direnv (Nix integration) ────────────────────────────────────────
  programs.direnv = {
    enable = true;
    package = pkgs.direnv;
    silent = false;
  };

  # ── Podman / container configuration ────────────────────────────────
  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
    defaultNetwork.settings.dns_enabled = true;
  };

  virtualisation.containers = {
    enable = true;
    registries.search = [ "docker.io" "ghcr.io" "quay.io" ];
  };

  # ── Build cache ──────────────────────────────────────────────────────
  programs.ccache = {
    enable = true;
    cacheDir = "/var/cache/ccache";
  };

  # ── Development services ─────────────────────────────────────────────
  # services.redis.enable = true;  # Enable if needed
}
