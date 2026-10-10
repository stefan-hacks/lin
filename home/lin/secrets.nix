# home/lin/secrets.nix
# Secrets management placeholder (uses sops-nix)

{ config, pkgs, lib, ... }:

{
  # ── SOPS-nix integration ─────────────────────────────────────────────
  # Secrets are encrypted in the repo using age/sops.
  # The sops.yaml file defines which keys can decrypt which secrets.
  #
  # To set up:
  #   1. Generate an age key: age-keygen -o ~/.config/sops/age/keys.txt
  #   2. Add the public key to .sops.yaml
  #   3. Create secrets: sops secrets/my-secret.yaml
  #   4. Reference in config: config.sops.secrets."my-secret".path

  # Example secret reference:
  # sops.secrets."discord-webhook" = {
  #   sopsFile = ../../secrets/discord.yaml;
  #   format = "yaml";
  #   key = "webhook_url";
  # };

  # home.sessionVariables.DISCORD_WEBHOOK_URL = config.sops.secrets."discord-webhook".path;
}
