{
  config,
  lib,
  pkgs,
  inputs,
  variables,
  ...
}: {
  options.module.terminal.enable =
    lib.mkEnableOption
    "Enable the terminal module";

  config = lib.mkIf config.module.terminal.enable {
    programs = let
      alacrittyTheme = import "${inputs.self}/themes/alacritty.nix";
      zellijTheme = import "${inputs.self}/themes/zellij.nix";
    in {
      alacritty = {
        enable = true;
        settings = {
          window.padding = {
            x = 5;
            y = 5;
          };
          scrolling.history = 10000;
          colors = builtins.getAttr variables.theme alacrittyTheme.themes;
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
          inherit (variables) theme;
          inherit (zellijTheme) themes;
          simplified_ui = true;
          copy_command = "${pkgs.xclip}/bin/xclip -selection clipboard";
        };
      };
    };
  };
}
