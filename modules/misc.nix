{
  pkgs,
  config,
  lib,
  ...
}: {
  options.module.misc.enable =
    lib.mkEnableOption
    "Enable the misc module";

  config = lib.mkIf config.module.misc.enable {
    home.packages = with pkgs; [
      keepassxc
      spotify
      zotero
    ];

    programs = {
      chromium = {
        enable = true;
        package = pkgs.google-chrome;
        commandLineArgs = [
          "--ignore-gpu-blocklist"
          "--enable-zero-copy"
        ];
      };
      firefox = {
        enable = true;
        # explore full configuration
      };
    };

    services.syncthing = {
      enable = true;
      extraOptions = [];
    };
  };
}
