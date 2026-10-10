# lin

> Comprehensive NixOS configuration for the `lin` machine.
> Migrating from Debian trixie → declarative NixOS.

---

## Structure

```
lin/
├── flake.nix                 # Entry point — flake inputs/outputs
├── hosts/
│   └── lin/
│       ├── default.nix       # Machine-specific config (hostname, filesystems, users)
│       └── hardware.nix        # AMD Rembrandt + Radeon 680M hardware quirks
├── modules/
│   └── system/
│       ├── default.nix         # System-wide environment
│       ├── networking.nix      # NetworkManager, systemd-resolved, iwd
│       ├── storage.nix         # LVM, filesystem tools
│       └── users.nix           # Group definitions
├── profiles/
│   ├── core.nix                # Minimal baseline (SSH, Nix, basic tools)
│   ├── desktop.nix             # GNOME 48 + Wayland + PipeWire
│   ├── development.nix         # Rust, Go, Python, containers
│   ├── server.nix              # Jellyfin, Apache, Ollama, Mullvad
│   └── hardening.nix           # AppArmor, auditd, sysctl hardening
├── home/lin/
│   ├── default.nix             # Home Manager entry point
│   ├── packages.nix            # User-level packages
│   ├── programs.nix            # Program configs (git, nvim, kitty, vscode)
│   ├── services.nix            # User systemd services
│   ├── desktop.nix             # GNOME dconf, GTK, Qt, XDG
│   ├── shell.nix               # Bash aliases and config
│   └── secrets.nix             # Sops-nix placeholder
├── overlays/
│   └── default.nix             # Custom package overrides
├── pkgs/
│   └── default.nix             # Custom packages (bashme, ros-cli, etc.)
├── docs/
│   ├── AUDIT.md                # Full Debian → NixOS migration audit
│   └── INSTALL.md              # Step-by-step install guide
└── secrets/
    └── .gitkeep               # Placeholder for encrypted secrets
```

---

## Hardware

| Component | Details |
|-----------|---------|
| **CPU** | AMD Ryzen 7 6800H (8c/16t, up to 4.78 GHz) |
| **GPU** | AMD Radeon 680M (Rembrandt iGPU) |
| **RAM** | 27 GB |
| **Storage** | Micron 2550 NVMe (1 TB, LVM) |
| **Network** | Realtek RTL8125 2.5GbE + Mediatek MT7921 WiFi |
| **Audio** | AMD HD Audio + PipeWire |
| **Bluetooth** | AMD Rembrandt USB4 |

---

## Quick Reference

```bash
# Build and activate (local)
sudo nixos-rebuild switch --flake .#lin

# Update flake inputs
nix flake update

# Build only (no activate)
nixos-rebuild build --flake .#lin

# Home Manager only
home-manager switch --flake .#lin

# Dev shell
nix develop

# Check flake
nix flake check
```

---

## Profiles

| Profile | Purpose |
|---------|---------|
| `core` | SSH, Nix settings, basic tools, sudo, logging |
| `desktop` | GNOME 48, Wayland, PipeWire, Flatpak, fonts |
| `development` | Rust, Go, Python, Podman, direnv, build tools |
| `server` | Jellyfin, Apache, Ollama, Mullvad, fail2ban, smartd |
| `hardening` | AppArmor, auditd, sysctl, kernel params, lynis |

---

## Services

| Service | Port | Notes |
|---------|------|-------|
| SSH | 22 | Key-only auth |
| HTTP (Apache) | 80 | DocumentRoot /var/www/html |
| Jellyfin | 8096 | AMD ROCm acceleration |
| Jellyfin HTTPS | 8920 | |
| Ollama | 11434 | Local LLM inference |
| Homepage | 3000 | Podman container |
| Guacamole | 8080 | Podman container |
| ROS Linux | 2222, 8081, 9091 | Podman container |

---

## Secrets

This repo uses [sops-nix](https://github.com/Mic92/sops-nix) for secrets management.

```bash
# Generate age key
mkdir -p ~/.config/sops/age
age-keygen -o ~/.config/sops/age/keys.txt

# Add public key to .sops.yaml
# Encrypt secrets
sops secrets/discord.yaml
```

---

## License

Unlicense / Public Domain — this is a personal machine configuration.

---

*Maintained by stefan-hacks / Lin*
