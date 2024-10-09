{
  config,
  lib,
  pkgs,
  inputs,
  variables,
  ...
}: {
  options.module.git-tools.enable =
    lib.mkEnableOption
    "Enable the git tools module.";

  config = lib.mkIf config.module.git-tools.enable {
    programs = let
      gituiTheme = import "${inputs.self}/themes/gitui.nix";
      gituiSettings = ''
        (
            move_left: Some(( code: Char('h'), modifiers: "")),
            move_right: Some(( code: Char('l'), modifiers: "")),
            move_up: Some(( code: Char('k'), modifiers: "")),
            move_down: Some(( code: Char('j'), modifiers: "")),
            stash_open: Some(( code: Char('l'), modifiers: "")),
            open_help: Some(( code: F(1), modifiers: "")),
            status_reset_item: Some(( code: Char('U'), modifiers: "SHIFT")),
        )
      '';
    in {
      git = {
        enable = true;
        userName = "Jamie Temple";
        userEmail = "jamie-temple@live.de";
        signing.key = "1F7AD43C1F17EC41";
        signing.signByDefault = true;
      };

      gh = {
        enable = true;
        extensions = [
          pkgs.gh-s
          pkgs.gh-poi
          pkgs.gh-cal
          pkgs.gh-eco
          pkgs.gh-dash
          pkgs.gh-markdown-preview
        ];
        settings.git_protocol = "ssh";
      };

      git-cliff = {
        enable = true;
        settings.git = {
          conventional_commits = true;
          filter_unconventional = true;
          split_commits = false;
        };
      };

      gitui = {
        enable = true;
        keyConfig = gituiSettings;
        theme = builtins.getAttr variables.theme gituiTheme.themes;
      };
    };
  };
}
