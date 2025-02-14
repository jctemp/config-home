{
  description = "Insane NixOS home configuration";

  nixConfig = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
  };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs:
    let
      userSpec = {
        name = "nixos";
        theme = "rose-pine";
        graphicsSupport = true;
      };
    in
    (inputs.flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import inputs.nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };
      in
      {
        formatter = pkgs.alejandra;
        packages.homeConfigurations = import ./config (inputs // { inherit userSpec; });
        devShells.default = pkgs.mkShellNoCC {
          name = "home config";
          packages =
            let
              scriptsPkgs = pkgs.callPackage ./scripts { };
            in
            [
              pkgs.home-manager
              scriptsPkgs
            ];
        };
      }
    ));
}
