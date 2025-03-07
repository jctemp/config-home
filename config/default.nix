inputs: let
  mkUser = userSpec:
    inputs.home-manager.lib.homeManagerConfiguration {
      pkgs = import inputs.nixpkgs {
        system = "x86_64-linux";
        config.allowUnfree = true;
        overlays = [
          inputs.blender-bin.overlays.default
        ];
      };
      extraSpecialArgs = {
        inherit inputs;
        pkgs-stable = import inputs.nixpkgs-stable {
          system = "x86_64-linux";
          config.allowUnfree = true;
          overlays = [
            inputs.blender-bin.overlays.default
          ];
        };
      };
      modules = [
        "${inputs.self}/config/user-specs.nix"
        "${inputs.self}/config/modules.nix"
        (
          {...}: {
            userSpec = {inherit (userSpec) theme graphicsSupport;};
            home = {
              username = userSpec.name;
              stateVersion = "24.11";
              homeDirectory = "/home/${userSpec.name}";
            };
            programs.home-manager.enable = true;
            systemd.user.startServices = "sd-switch";
          }
        )
      ];
    };
in {
  ${inputs.userSpec.name} = mkUser inputs.userSpec;
}
