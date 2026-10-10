# overlays/default.nix
# Custom package overlays for the 'lin' flake

final: prev: {
  # ── Override example: pin a package to a specific version ──────────
  # firefox = prev.firefox.override { ... };

  # ── Custom package: bashme (user's Go CLI) ───────────────────────
  # bashme = final.callPackage ../pkgs/bashme { };

  # ── Custom package: ros-cli (user's Rust CLI) ──────────────────
  # ros-cli = final.callPackage ../pkgs/ros-cli { };

  # ── Patches ────────────────────────────────────────────────────────
  # Example: apply a patch to a package
  # some-package = prev.some-package.overrideAttrs (oldAttrs: {
  #   patches = (oldAttrs.patches or []) ++ [ ./patches/fix-something.patch ];
  # });
}
