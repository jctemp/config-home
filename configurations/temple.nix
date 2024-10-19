{
  username,
  stateVersion,
  ...
}: {
  module = {
    misc.enable = true;
    terminal.enable = true;
    dev-tools.enable = true;
    git-tools.enable = true;
  };

  home = {
    inherit username stateVersion;
    homeDirectory = "/home/${username}";
  };

  programs.home-manager.enable = true;
  systemd.user.startServices = "sd-switch";
}
