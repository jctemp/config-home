{
  config,
  lib,
  pkgs,
  inputs,
  variables,
  ...
}: {
  options.module.dev-tools.enable =
    lib.mkEnableOption
    "Enable dev tools module";

  config = lib.mkIf config.module.dev-tools.enable {
    programs = let
      helixTheme = import "${inputs.self}/themes/helix.nix";
    in {
      direnv = {
        enable = true;
        enableBashIntegration = true;
        nix-direnv.enable = true;
      };

      helix = {
        enable = true;
        defaultEditor = true;
        settings = {
          theme = builtins.getAttr variables.theme helixTheme.themes;
          editor = {
            line-number = "absolute";
            true-color = true;
            rulers = [80 120];
            color-modes = true;
          };
          editor.lsp = {
            enable = true;
            display-messages = true;
          };
          editor.file-picker = {
            hidden = false;
          };
        };

        languages = {
          language-server = {
            nixd = {command = "${pkgs.nixd}/bin/nixd";};
          };
          language = [
            {
              name = "nix";
              language-servers = ["nixd"];
              formatter = {
                command = "${pkgs.alejandra}/bin/alejandra";
              };
            }
          ];
        };
      };
    };
  };
}
