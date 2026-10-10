# System Audit: Debian trixie → NixOS Migration

## Machine Identity
| Property | Value |
|----------|-------|
| **Hostname** | `lin` |
| **OS** | Debian GNU/Linux 13 (trixie) |
| **Kernel** | Linux 6.12.107+deb13-amd64 |
| **Architecture** | x86_64 |
| **Init** | systemd 257 |
| **Target** | NixOS (nixos-unstable) |

---

## Hardware

### CPU
| Property | Value |
|----------|-------|
| **Model** | AMD Ryzen 7 6800H with Radeon Graphics |
| **Cores** | 8 |
| **Threads** | 16 |
| **Max MHz** | 4785 |
| **Min MHz** | 400 |
| **Microcode** | amd64-microcode 3.20250311.1 |

### GPU
| Property | Value |
|----------|-------|
| **Model** | AMD/ATI Rembrandt [Radeon 680M] [1002:1681] |
| **Driver** | amdgpu (kernel module) |
| **Mesa** | 25.0.7-2+deb13u1 |
| **Vulkan** | amdvlk / RADV |
| **VA-API** | mesa-va-drivers |

### Memory
| Property | Value |
|----------|-------|
| **Total RAM** | 27 GB |
| **Swap** | 27 GB (LVM) |
| **Used** | ~8 GB |

### Storage
| Device | Type | Size | Details |
|--------|------|------|---------|
| nvme0n1 | Micron 2550 NVMe | ~931 GB | DRAM-less |
| ├─nvme0n1p1 | vfat (ESP) | ~965 MB | /boot/efi |
| ├─nvme0n1p2 | ext4 | ~859 MB | /boot |
| └─nvme0n1p3 | LVM2 PV | ~929 GB | lin-vg |
|   ├─lin--vg-root | ext4 | ~901 GB | / (89% full) |
|   └─lin--vg-swap_1 | swap | ~27 GB | [SWAP] |

### Network
| Device | Type | Driver | Notes |
|--------|------|--------|-------|
| eno1 | Ethernet | r8169 / r8125 | Realtek RTL8125 2.5GbE |
| wlp3s0 | WiFi | mt7921 | Mediatek MT7921 |
| lo | Loopback | — | 127.0.0.1 |
| virbr0 | Bridge | — | libvirt NAT bridge |

### Audio
| Device | Driver | Notes |
|--------|--------|-------|
| AMD Radeon HD Audio | snd_hda_intel | HDMI audio |
| AMD Family 17h/19h HD Audio | snd_hda_intel | onboard |
| **PipeWire** | 1.4.2 | ALSA + Pulse emulation |
| **WirePlumber** | 0.5.8 | session manager |

### USB
| Controller | Driver | Notes |
|------------|--------|-------|
| AMD Rembrandt USB4 XHCI #3 | xhci_hcd | |
| AMD Rembrandt USB4 XHCI #4 | xhci_hcd | |
| AMD Rembrandt USB4 XHCI #5 | xhci_hcd | |
| AMD Rembrandt USB4 XHCI #6 | xhci_hcd | |
| AMD Rembrandt USB4 XHCI #8 | xhci_hcd | |

---

## Filesystems

### fstab
```
/dev/mapper/lin--vg-root  /      ext4  rw,relatime,errors=remount-ro
/dev/nvme0n1p2            /boot  ext4  rw,relatime
/dev/nvme0n1p1            /boot/efi  vfat  rw,relatime
/dev/mapper/lin--vg-swap_1 none  swap  sw
```

### Mount Options (findmnt)
- `/`: ext4, rw, relatime, errors=remount-ro
- `/boot/efi`: vfat, rw, relatime
- No LUKS encryption detected (plain LVM)
- No ZFS pools detected

---

## Boot Configuration

### Bootloader
| Property | Value |
|----------|-------|
| **Type** | GRUB2 |
| **EFI** | Yes (nodev) |
| **OS Prober** | Enabled |
| **Timeout** | 5 seconds |

### Kernel Parameters
```
quiet noresume nohibernate
```

### Initrd Modules
```
nvme xhci_pci thunderbolt usb_storage sd_mod sdhci_pci
```

---

## Installed Packages (2203 total)

### Category Breakdown

#### Core / System (Selection)
```
7zip, acl, adduser, apparmor, apt, bash, bc, bison, bzip2,
ca-certificates, coreutils, cron, cups, curl, dbus, diffutils,
dmidecode, dpkg, e2fsprogs, eject, fakeroot, fdisk, findutils,
gawk, gcc, gdb, gettext, ghostscript, glibc, gnupg, grep, gzip,
hostname, htop, init-system-helpers, iproute2, iputils-ping, less,
libaudit1, libcap2, libcryptsetup12, libpam-modules, libseccomp2,
linux-image-amd64, locales, login, lsb-release, lvm2, make, man-db,
mount, nano, ncurses-bin, netbase, netcat-openbsd, net-tools,
openssh-client, openssh-server, openssl, passwd, pciutils, perl-base,
procps, psmisc, python3, sed, sensible-utils, shared-mime-info,
sudo, systemd, sysvinit-utils, tar, tcpdump, tzdata, udev, util-linux,
vim-tiny, wget, whiptail, xz-utils, zlib1g
```

#### Desktop / GNOME
```
ga-gnome-shell, gnome-calculator, gnome-calendar, gnome-characters,
gnome-clocks, gnome-contacts, gnome-control-center, gnome-disk-utility,
gnome-keyring, gnome-logs, gnome-menus, gnome-online-accounts,
gnome-screenshot, gnome-session, gnome-settings-daemon, gnome-shell,
gnome-shell-extensions, gnome-system-monitor, gnome-terminal,
gnome-text-editor, gnome-themes-extra, gnome-tweaks, gnome-user-docs,
gnome-weather, nautilus, totem, eog, evince, file-roller,
gdm3, libgdm1, mutter, wayland-protocols, xserver-xorg-core,
xserver-xorg-video-amdgpu, xserver-xorg-input-libinput
```

#### Development
```
build-essential, cmake, cpp, cpp-14, gcc-14, g++-14, golang-1.24-go,
golang-go, python3, python3-pip, python3-venv, python3-dev,
rustc, cargo, rustfmt, clippy, git, git-lfs, gh, jq, yq,
buildah, podman, podman-compose, skopeo, criu, crun, conmon
```

#### Media / Entertainment
```
alsa-utils, ffmpeg, jellyfin, jellyfin-ffmpeg8, jellyfin-server,
jellyfin-web, mpv, pipewire, pipewire-alsa, pipewire-pulse,
vulkan-tools, vlc, vlc-bin, vlc-plugin-*
```

#### Security
```
apparmor, apparmor-profiles, apparmor-utils, fail2ban, iptables,
lynis, mullvad-vpn, nftables, openssl, rkhunter, sudo, tcpdump, ufw
```

#### Network
```
apache2, apache2-bin, apache2-utils, bind9-dnsutils, bridge-utils,
dnsmasq-base, netcat-openbsd, netcat-traditional, network-manager,
openssh-client, openssh-server, openssl, wget, curl
```

#### Hermes Agent Related
```
ollama (API), python3, curl, jq, gh, git, discord (webhook)
```

---

## System Services (Enabled)

| Service | Status | Notes |
|---------|--------|-------|
| `apache2` | enabled | DocumentRoot /var/www/html |
| `apparmor` | enabled | profiles loaded |
| `avahi-daemon` | enabled | mDNS |
| `bluetooth` | enabled | bluez |
| `cups` | enabled | printing |
| `cups-browsed` | enabled | |
| `fail2ban` | enabled | sshd jail |
| `gdm3` | enabled | GNOME display manager |
| `jellyfin` | active | 1.6G mem, custom drop-in |
| `mullvad-vpn` | active | disconnected (visible: Brazil) |
| `network-manager` | enabled | |
| `nix-daemon` | active | Nix 2.26.3, multi-user |
| `openssh` | enabled | PermitRootLogin prohibit-password |
| `pipewire` | active | PulseAudio compat |
| `smartd` | enabled | |
| `syslog` | enabled | via systemd-journald |
| `systemd-timesyncd` | enabled | NTP |
| `ufw` | installed | not active (nftables preferred) |

---

## Network Configuration

### Interfaces
| Interface | IP | State |
|-----------|-----|-------|
| eno1 | 192.168.x.x/24 | UP |
| virbr0 | 192.168.122.1/24 | UP |
| lo | 127.0.0.1/8 | UP |

### DNS
- systemd-resolved: enabled
- Fallback: 1.1.1.1, 8.8.8.8
- DNSSEC: true

### Firewall
- **nftables**: installed, no active rules
- **ufw**: installed, inactive
- **iptables**: legacy wrapper present
- **fail2ban**: sshd jail active

---

## Containers

### Podman (rootless)
| Container | Image | Status | Ports |
|-----------|-------|--------|-------|
| homepage | ghcr.io/gethomepage/homepage:latest | Up 12 days | 3000/tcp |
| nixos-test | docker.io/nixos/nix:latest | Up 12 days | — |
| guacamole | docker.io/oznu/guacamole:latest | Exited | 8080:8080 |
| ros-linux | localhost/ros-linux:latest | Exited | 2222:22, 8081:8080, 9091:9090 |

### Podman Info
- Version: 5.x (buildah 1.39.3, conmon 2.1.12)
- Cgroup: systemd v2
- Database: sqlite
- Storage: overlay

### Libvirt
- Installed but no active VMs

---

## Hermes Agent Configuration

### Installation
| Property | Value |
|----------|-------|
| **Path** | `~/.hermes/` |
| **Config** | `~/.hermes/config.yaml` |
| **Skills** | `~/.hermes/skills/` (30+ skills) |
| **Scripts** | `~/.hermes/scripts/` |

### Active Skills (Selection)
```
autonomous-ai-agents, debian-*, devops, github-*, media, mlops,
nix, nixos-*, note-taking, pdrx-expert, productivity, research,
software-development, stefan-hacks-config, subagent-orchestration
```

### Scripts
- `discord-audit.sh` — Discord webhook audit trail
- `hermes-cold-start.sh` — Launch sequence
- `startup-discord-ping.sh` — Online notification
- `sudo-askpass.sh` — GUI sudo prompt
- `wise_daily_report.py` — Financial reporting

### Discord Integration
- Streaming: enabled
- Tool progress: visible inline
- Audit hooks: `discord-audit.py`
- Cold start ping: enabled

---

## Security Posture

### AppArmor
- Enabled: yes
- Profiles: apparmor-profiles package loaded
- Mode: enforce (default)

### Lynis
- Last run: Oct 10 00:20
- Report: `/var/log/lynis-report.dat`

### Fail2ban
- SSH jail: enabled
- Max retry: 3
- Ban time: 1 hour

### Mullvad VPN
- Status: Disconnected
- Visible location: Brazil, Rio de Janeiro
- IPv4: 186.205.9.108

---

## Users & Groups

### Primary User
| Property | Value |
|----------|-------|
| **Username** | `lin` |
| **UID** | 1000 |
| **GID** | 1000 |
| **Shell** | /bin/bash |
| **Home** | /home/lin |
| **Groups** | sudo, audio, video, kvm, libvirt, docker, podman, netdev, bluetooth, scanner, lpadmin, nix-users, ollama, jellyfin, render, cdrom, floppy, dip, plugdev, users |

### Groups
```
audio:29, bluetooth:106, cdrom:24, dip:30, floppy:25,
jellyfin:117, kvm:993, libvirt:121, libvirt-qemu:64055,
lpadmin:108, netdev:101, nix-users:985, ollama:989,
plugdev:46, render:992, scanner:102, sudo:27, users:100,
video:44, lin:1000
```

---

## Nix Installation (Existing)

| Property | Value |
|----------|-------|
| **Version** | Nix 2.26.3 |
| **Mode** | Multi-user (daemon) |
| **Channels** | nixos-unstable, nixpkgs-unstable |
| **Store** | /nix/store |
| **User** | lin (member of nix-users:985) |

### Nix Configuration
```
experimental-features = nix-command flakes
```

---

## Existing Nix Projects

### i-nix (Rust CLI)
- Path: `~/.config/i-nix/`
- Structure: flake.nix, hosts/, modules/, profiles/, systems/, users/
- Hosts: laptop
- Profiles: core, desktop, development, gaming, server
- User: lin (with desktop/gnome, hyprland, kde, sway)

### Other Projects
- `~/bashme/` — Go CLI (binary with flag dispatch)
- `~/caelestia-shell/` — Shell project
- `~/nixvis/` — Nix visualizer
- `~/ros-cli/` — Rust CLI
- `~/my-pdrx-config/` — Debian dotfiles repo

---

## GNOME Settings (from dconf dump)

### Interface
- Theme: prefer-dark
- Clock: 12h, show weekday, show date
- Font: Cantarell 11
- Cursor: Adwaita 24px
- GTK Theme: Adwaita
- Animations: enabled
- Hot corners: enabled

### Session
- Idle delay: 300s
- Lock: enabled

### Peripherals
- Tap-to-click: true
- Natural scroll: true
- Caps Lock → Ctrl

---

## Bash Aliases Summary (691 lines)

### Categories
1. Safety nets & core overrides
2. Navigation & file management
3. Listing (eza)
4. Searching & filtering
5. Archiving & compression
6. Process & system monitoring
7. Disk, memory & hardware
8. Date & time
9. Networking
10. Web development & servers
11. Git (30+ aliases)
12. Docker/Podman
13. Cryptography & encoding
14. Colorised commands
15. Sysadmin helpers
16-26. Security / CTF (enumeration, web app testing, password attacks, privilege escalation, wireless, metasploit, payload generation, port forwarding, file analysis, proxy & anonymity, quick-helpers)
27. Maintenance & updates
28. Miscellaneous / fun

---

## Migration Notes

### ✅ Straightforward Migrations
- GNOME desktop environment (native NixOS module)
- PipeWire + WirePlumber (native module)
- Bluetooth + BlueZ (native module)
- SSH server (native module)
- Jellyfin (native module with AMD ROCm)
- Apache (native module)
- Podman (native module with dockerCompat)
- Ollama (native module)
- Fail2ban (native module)
- AppArmor (native module)
- Smartmontools (native module)
- Plocate (native module)
- Logrotate (native module)
- Git config (native module)
- Bash aliases (Home Manager)
- GNOME dconf (Home Manager)

### ⚠️ Requires Attention
- **LVM**: No LUKS. NixOS supports LVM natively. Verify UUIDs.
- **Grub**: Debian GRUB config has extra entries. Preserve with `extraEntries`.
- **Mullvad VPN**: Package `mullvad-vpn` available in nixpkgs.
- **Container migration**: Homepage, Guacamole, ros-linux need systemd quadlets or compose files.
- **Hermes Agent**: Not in nixpkgs. Run as user service or impermanence + git clone.
- **i-nix config**: Merge into this repo or keep separate.
- **Custom Go/Rust binaries**: Build from source in repo.

### ❌ Not Directly Supported
- **systemd-resolved + iwd**: Available in NixOS, verify compatibility.
- **Debian-specific packages**: Some tools may need alternatives or custom builds.

---

## Checklist for NixOS Install

- [ ] Back up /home/lin
- [ ] Back up /etc (ssh keys, apparmor profiles)
- [ ] Back up Jellyfin metadata (/var/lib/jellyfin)
- [ ] Verify disk UUIDs in `hosts/lin/default.nix`
- [ ] Generate age key for sops-nix
- [ ] Set `boot.loader.grub.device` correctly
- [ ] Test `nixos-install --dry-run` in VM
- [ ] Install NixOS with `nixos-install --flake .#lin`
- [ ] Migrate containers to podman-compose or quadlets
- [ ] Install Hermes Agent
- [ ] Verify all services start
- [ ] Run `lynis audit system` on new install

---

*Audit generated: 2026-10-10*
*Auditor: Lin (Hermes Agent)*
