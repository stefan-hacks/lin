# pkgs/default.nix
# Custom packages exposed by this flake

{ pkgs }: {
  # ── User's custom tools ──────────────────────────────────────────
  # bashme = pkgs.callPackage ./bashme { };
  # ros-cli = pkgs.callPackage ./ros-cli { };
  # i-nix = pkgs.callPackage ./i-nix { };

  # ── Convenience wrappers ──────────────────────────────────────────
  # nix-shell-dev = pkgs.writeShellScriptBin "nix-shell-dev" ''''
  #   exec nix-shell -p gcc gnumake cmake git
  # ''';
}
