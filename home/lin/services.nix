# home/lin/services.nix
# User-level systemd services and timers

{ config, pkgs, lib, ... }:

{
  # ── Discord audit hook (Hermes Agent) ────────────────────────────────
  # The discord-audit.py script runs as part of Hermes Agent's lifecycle.
  # In NixOS, Hermes Agent runs under the user's systemd --user scope.
  # This section defines any custom user services needed.

  # ── Ollama client access ─────────────────────────────────────────────
  # Ollama runs as a system service; this just ensures the user can talk to it
  home.sessionVariables.OLLAMA_HOST = "http://localhost:11434";

  # ── Podman auto-start for user containers ────────────────────────────
  # Enable lingering so user services run when not logged in
  # services.linger.enable = true;  # Managed at system level

  # ── User cron jobs ───────────────────────────────────────────────────
  # services.cron = {
  #   enable = true;
  #   jobs = [
  #     { name = "backup-dotfiles"; value = "0 2 * * * rsync -a ~/.config /backup/"; }
  #   ];
  # };
}
