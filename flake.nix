{
  description = "lin — comprehensive NixOS configuration for stefan-hacks' machine";

  inputs = {
    # ── NixOS ecosystem ────────────────────────────────────────────────
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };

    # ── Security & hardening ────────────────────────────────────────────
    srvos = {
      url = "github:nix-community/srvos";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # ── Disk partitioning (declarative) ─────────────────────────────────
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # ── Secrets management ──────────────────────────────────────────────
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # ── VSCode extensions (optional) ────────────────────────────────────
    nix-vscode-extensions = {
      url = "github:nix-community/nix-vscode-extensions";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ { self, nixpkgs, home-manager, flake-parts, srvos, disko, sops-nix, ... }:
    let
      inherit (nixpkgs) lib;
      systems = [ "x86_64-linux" "aarch64-linux" ];

      # Per-system helper
      forAllSystems = f: lib.genAttrs systems (system: f system);

      # Common module arguments passed to all hosts
      extraArgs = { inherit inputs self; };
    in
    flake-parts.lib.mkFlake { inherit inputs; } {
      inherit systems;

      flake = {
        # ── NixOS system configurations ──────────────────────────────────
        nixosConfigurations = {
          lin = nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
            specialArgs = extraArgs;
            modules = [
              # Hardware
              ./hosts/lin

              # System modules
              ./modules/system

              # Profiles
              ./profiles/core.nix
              ./profiles/desktop.nix
              ./profiles/development.nix
              ./profiles/server.nix
              ./profiles/hardening.nix

              # Home Manager integration
              home-manager.nixosModules.home-manager
              {
                home-manager.useGlobalPkgs = true;
                home-manager.useUserPackages = true;
                home-manager.users.lin = import ./home/lin;
                home-manager.extraSpecialArgs = extraArgs;
              }

              # Sops-nix for secrets
              sops-nix.nixosModules.sops
            ];
          };
        };

        # ── Home Manager standalone (for non-NixOS hosts) ────────────────
        homeConfigurations.lin = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
          extraSpecialArgs = extraArgs;
          modules = [ ./home/lin ];
        };

        # ── Custom packages exposed by this flake ────────────────────────
        packages = forAllSystems (system:
          import ./pkgs { pkgs = nixpkgs.legacyPackages.${system}; }
        );

        # ── Formatter ────────────────────────────────────────────────────
        formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.nixpkgs-fmt);

        # ── Overlays ─────────────────────────────────────────────────────
        overlays.default = import ./overlays;
      };

      # ── Per-system outputs (dev shell, checks) ─────────────────────────
      perSystem = { config, pkgs, system, ... }: {
        devShells.default = pkgs.mkShell {
          name = "lin-config";
          nativeBuildInputs = with pkgs; [
            nixpkgs-fmt
            nixd
            sops
            age
            ssh-to-age
          ];
          shellHook = ''
            echo "🛠️  lin NixOS config dev shell"
            echo "   flake check     — validate flake"
            echo "   nixos-rebuild   — build/activate"
          '';
        };
      };
    };
}
