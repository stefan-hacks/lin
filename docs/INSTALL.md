# Installation Guide: Debian → NixOS

## Prerequisites

- A NixOS live USB (unstable or 24.11+)
- Backup of `/home/lin`
- Backup of `/etc` (SSH keys, custom configs)
- This repo cloned to `/home/lin/lin` (or USB)

---

## Step 1: Boot NixOS Live ISO

```bash
# From the live environment
sudo -i
```

---

## Step 2: Verify Disk Layout

```bash
lsblk -f
# Confirm UUIDs match hosts/lin/default.nix:
#   /dev/nvme0n1p1 → 8AF8-BBF8  (ESP)
#   /dev/nvme0n1p2 → e21be7f5-...  (/boot)
#   /dev/nvme0n1p3 → d8nsjX-...   (LVM PV)
#   lin--vg-root   → 4a7bb303-...  (/)
#   lin--vg-swap_1 → b7febb4e-...  (swap)
```

---

## Step 3: Mount Existing Partitions

```bash
# Mount root
mount /dev/disk/by-uuid/4a7bb303-1a45-4d28-a157-0fbde3666d13 /mnt

# Mount boot
mkdir -p /mnt/boot
mount /dev/disk/by-uuid/e21be7f5-0d70-478f-b3a8-c374ca34bedc /mnt/boot

# Mount EFI
mkdir -p /mnt/boot/efi
mount /dev/disk/by-uuid/8AF8-BBF8 /mnt/boot/efi

# Activate swap
swapon /dev/disk/by-uuid/b7febb4e-1c4d-4fe2-ba50-3ec91086d6ae
```

---

## Step 4: Clone / Prepare This Repo

```bash
# Option A: Clone from GitHub (after push)
git clone https://github.com/stefan-hacks/lin.git /mnt/home/lin/lin

# Option B: Copy from USB
mkdir -p /mnt/home/lin/lin
cp -r /mnt/home/lin/lin/* /mnt/home/lin/lin/
```

---

## Step 5: Generate Hardware Config

```bash
nixos-generate-config --root /mnt --show-hardware-config > /mnt/home/lin/lin/hosts/lin/hardware-generated.nix
# Compare with existing hardware.nix and merge any new modules
```

---

## Step 6: Install NixOS

```bash
# Essential: use --no-root-passwd if you want to preserve the existing user setup
# Or set a new root password during install
nixos-install --flake /mnt/home/lin/lin#lin --no-root-passwd

# If you need to set a root password:
# nixos-install --flake /mnt/home/lin/lin#lin
```

---

## Step 7: Reboot

```bash
reboot
# Remove USB when prompted
```

---

## Step 8: Post-Install (as lin)

```bash
# Set user password
passwd

# Activate Home Manager
home-manager switch --flake ~/lin#lin

# Verify services
systemctl status jellyfin
systemctl status ollama
systemctl status apache2
systemctl status pipewire

# Verify desktop
echo $XDG_SESSION_TYPE   # should be wayland
gnome-shell --version       # should be GNOME 48+
```

---

## Step 9: Migrate Data

### Jellyfin
```bash
# If you backed up /var/lib/jellyfin:
sudo systemctl stop jellyfin
sudo rsync -av /backup/jellyfin/ /var/lib/jellyfin/
sudo chown -R jellyfin:jellyfin /var/lib/jellyfin
sudo systemctl start jellyfin
```

### Containers
```bash
# Re-pull and start containers
cd ~/lin/containers
podman-compose up -d
# Or use systemd quadlets:
systemctl --user start homepage
systemctl --user start guacamole
```

### Hermes Agent
```bash
# Not in nixpkgs — install manually:
git clone https://github.com/NousResearch/hermes-agent.git ~/.hermes-agent
# Follow Hermes Agent install docs
# Copy existing config:
rsync -av /backup/.hermes/ ~/.hermes/
```

### SSH Keys
```bash
mkdir -p ~/.ssh
chmod 700 ~/.ssh
cp /backup/.ssh/* ~/.ssh/
chmod 600 ~/.ssh/*
```

---

## Step 10: Verify Hardening

```bash
# Run lynis
sudo lynis audit system

# Check AppArmor
sudo aa-status

# Check firewall
sudo nft list ruleset

# Check auditd
sudo auditctl -l

# Check fail2ban
sudo fail2ban-client status sshd
```

---

## Troubleshooting

### Boot fails / wrong UUID
Edit `hosts/lin/default.nix` and update `fileSystems` entries with correct UUIDs from `blkid`.

### AMDGPU not loading
Add to `hardware.nix`:
```nix
boot.kernelParams = [ "amdgpu.sg_display=0" "nomodeset" ];
```

### PipeWire not working
```bash
systemctl --user restart pipewire pipewire-pulse
pactl info
```

### NetworkManager not connecting
```bash
nmcli device wifi list
nmcli device wifi connect "SSID" password "password"
```

---

*Guide generated: 2026-10-10*
