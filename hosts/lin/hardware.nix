# hosts/lin/hardware.nix
# AMD Rembrandt (Ryzen 7 6800H) + Radeon 680M specific hardware config

{ config, pkgs, lib, ... }:

{
  # ── CPU microcode ────────────────────────────────────────────────────
  hardware.cpu.amd.updateMicrocode = true;

  # ── Graphics ─────────────────────────────────────────────────────────
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      mesa
      amdvlk
      vaapiVdpau
      libvdpau-va-gl
      rocmPackages.clr.icd      # OpenCL
    ];
    extraPackages32 = with pkgs; [
      driversi686Linux.amdvlk
    ];
  };

  # ── AMD GPU kernel module settings ───────────────────────────────────
  boot.kernelModules = [ "kvm-amd" "amdgpu" ];
  boot.blacklistedKernelModules = [ "nouveau" "nvidia" "nvidia_drm" "nvidia_modeset" ];

  # ── Firmware ─────────────────────────────────────────────────────────
  hardware.enableAllFirmware = true;

  # ── Bluetooth ────────────────────────────────────────────────────────
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      General = {
        Enable = "Source,Sink,Media,Socket";
        Experimental = true;
      };
    };
  };

  # ── Sound ────────────────────────────────────────────────────────────
  # PipeWire (replaces PulseAudio)
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
    wireplumber.enable = true;
  };
  # Disable PulseAudio daemon (PipeWire provides compatibility)
  hardware.pulseaudio.enable = false;

  # ── Power management ─────────────────────────────────────────────────
  powerManagement = {
    enable = true;
    cpuFreqGovernor = "schedutil";
  };

  # ── Thermal management ───────────────────────────────────────────────
  services.thermald.enable = true;

  # ── USB autosuspend (AMD Rembrandt specific tuning) ────────────────
  services.tlp = {
    enable = true;
    settings = {
      USB_AUTOSUSPEND = 1;
      USB_EXCLUDE_WWAN = 1;  # Keep Mediatek WiFi alive
      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_SCALING_GOVERNOR_ON_BAT = "schedutil";
      CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
      CPU_ENERGY_PERF_POLICY_ON_BAT = "balance_power";
    };
  };

  # ── Printing ─────────────────────────────────────────────────────────
  services.printing = {
    enable = true;
    drivers = with pkgs; [ gutenprint hplip ];
  };

  # ── Scanner ────────────────────────────────────────────────────────
  hardware.sane = {
    enable = true;
    extraBackends = with pkgs; [ sane-airscan ];
  };

  # ── Fingerprint reader (if present on HP 840 G8) ─────────────────────
  # services.fprintd.enable = true;  # Uncomment if hardware detected
}
