{
  pkgs,
  username,
  stateVersion,
  ...
}: {
  imports = [
    ./programs
  ];

  home = {
    inherit username stateVersion;
    homeDirectory = "/home/${username}";
    packages = with pkgs; [
      nvim

      # daily tools
      firefox
      google-chrome
      keepassxc
      spotify

      # Note-taking
      obsidian
      typst
      zotero
      rclone
    ];
  };

  systemd.user.startServices = "sd-switch";
}
