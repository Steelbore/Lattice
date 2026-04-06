# SPDX-License-Identifier: GPL-3.0-or-later
{
  description = "Lattice — A Steelbore NixOS Distribution";

  inputs = {
    # Core (Strictly Stable)
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";

    # Home Manager
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      ...
    }:
    let
      system = "x86_64-linux";

      # Steelbore color palette as a reusable attribute set
      steelborePalette = {
        voidNavy    = "#000027";
        moltenAmber = "#D98E32";
        steelBlue   = "#4B7EB0";
        radiumGreen = "#50FA7B";
        redOxide    = "#FF5C5C";
        liquidCool  = "#8BE9FD";
      };

      # ── mkLattice ────────────────────────────────────────────────────────
      # Build a Lattice NixOS configuration for a given x86-64 march level.
      # Usage:  nixos-rebuild switch --flake .#lattice-v3
      #
      #   v1 — baseline x86-64 (SSE2)        broadest compatibility
      #   v2 — SSE4.2 / POPCNT / CX16        ~2008+ CPUs
      #   v3 — AVX2 / BMI1/2 / FMA / MOVBE   ~2013+ CPUs (CachyOS default)
      #   v4 — AVX-512F/BW/CD/DQ/VL          Ice Lake+ / Zen 4+
      mkLattice = marchLevel: nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = { inherit steelborePalette; };
        modules = [
          # External modules
          home-manager.nixosModules.home-manager

          # Lattice modules
          ./hosts/lattice
          ./modules/core
          ./modules/theme
          ./modules/hardware
          ./modules/desktops
          ./modules/login
          ./modules/packages

          # Profile + Home Manager integration
          {
            steelbore.hardware.intel.marchLevel = marchLevel;

            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.backupFileExtension = "backup";
            home-manager.extraSpecialArgs = { inherit steelborePalette; };
            home-manager.users.mj = import ./users/mj/home.nix;
          }
        ];
      };

    in
    {
      nixosConfigurations = {
        # Default — AVX-512 (same as lattice-v4)
        lattice    = mkLattice "v4";

        # Explicit profiles
        lattice-v1 = mkLattice "v1";   # baseline x86-64    (SSE2)
        lattice-v2 = mkLattice "v2";   # x86-64-v2          (SSE4.2)
        lattice-v3 = mkLattice "v3";   # x86-64-v3  AVX2    (CachyOS default)
        lattice-v4 = mkLattice "v4";   # x86-64-v4  AVX-512 (Lattice default)
      };
    };
}
