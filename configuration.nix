{
  pkgs,
  variables,
  ...
}: {
  imports = [
    ./modules/misc.nix
    ./modules/terminal.nix
    ./modules/dev-tools.nix
    ./modules/git-tools.nix
  ];

  module = {
    terminal.enable = true;
    dev-tools.enable = true;
    git-tools.enable = true;
  };

  home = {
    inherit (variables) username stateVersion;
    homeDirectory = "/home/${variables.username}";
    packages = with pkgs; [
      firefox
      google-chrome
      keepassxc
      spotify
      zotero
    ];
  };

  services.syncthing = {
    enable = true;
    extraOptions = [];
  };

  programs.home-manager.enable = true;
  systemd.user.startServices = "sd-switch";
}
