{
  config,
  lib,
  pkgs,
  inputs,
  theme,
  ...
}: {
  options.module.terminal = {
    enable =
      lib.mkEnableOption
      "Enable the terminal module";
    emulator.enable = lib.mkOption {
      default = true;
      defaultText = "true";
      description = "Enable terminal emulator";
      type = lib.types.bool;
    };
  };

  config = lib.mkIf config.module.terminal.enable {
    programs = let
      alacrittyTheme = import "${inputs.self}/themes/alacritty.nix";
      zellijTheme = import "${inputs.self}/themes/zellij.nix";
    in {
      alacritty = lib.mkIf config.module.terminal.emulator.enable {
        enable = true;
        settings = {
          window.padding = {
            x = 5;
            y = 5;
          };
          scrolling.history = 10000;
          colors = builtins.getAttr theme alacrittyTheme.themes;
        };
      };

      bash = {
        enable = true;
        enableCompletion = true;
        shellAliases = {
          ll = "ls -lash";
          l = "ls -lA";
          la = "ls -la";
        };
      };

      starship = {
        enable = true;
        enableBashIntegration = true;
        settings = builtins.fromTOML (builtins.readFile "${inputs.self}/settings/starship.toml");
      };

      zellij = {
        enable = true;
        enableBashIntegration = true;
        settings = {
          inherit theme;
          inherit (zellijTheme) themes;
          simplified_ui = true;
          copy_command = "${pkgs.xclip}/bin/xclip -selection clipboard";
        };
      };
    };
  };
}
