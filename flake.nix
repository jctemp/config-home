{
  description = "Insane NixOS home configuration";

  nixConfig = {
    experimental-features = ["nix-command" "flakes"];
  };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs:
    inputs.flake-utils.lib.eachDefaultSystem (system: let
      pkgs = import inputs.nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
      mkProfile = (import ./lib.nix inputs).makeProfile pkgs;
    in {
      formatter = pkgs.alejandra;
      packages.homeConfigurations = builtins.listToAttrs [
        (
          mkProfile "temple" {
            inherit inputs;
            stateVersion = "23.11";
            theme = "rosePine";
          }
        )
        (
          mkProfile "operator" {
            inherit inputs;
            stateVersion = "23.11";
            theme = "rosePine";
          }
        )
      ];
      devShells = {
        default = pkgs.mkShellNoCC {
          packages = import "${inputs.self}/scripts.nix" pkgs;
          shellHook = "overview";
        };
      };
    });
}
