inputs: {
  makeProfile = pkgs: username: args: {
    name = username;
    value = inputs.home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      extraSpecialArgs =
        {
          inherit username;
        }
        // args;
      modules = [
        "${inputs.self}/modules"
        "${inputs.self}/configurations/${username}.nix"
      ];
    };
  };
}
