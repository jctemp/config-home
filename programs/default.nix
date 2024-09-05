{pkgs, ...}: {
  home = {
    packages = with pkgs; [
      # fx file manager
      bat
      chafa
      feh

      # Development
      lldb
      clang-tools
      marksman
      nil
    ];

    file = {
      ".config/felix/config.yaml" = {
        enable = true;
        source = ./settings/fx-settings.yaml;
      };
    };
  };

  programs = {
    alacritty = {
      enable = true;
      settings = {
        window.padding = {
          x = 5;
          y = 5;
        };
        scrolling.history = 10000;
      };
    };

    bash = {
      enable = true;
      enableCompletion = true;
      shellAliases = {
        ll = "ls -l";
        l = "ls -lA";
        la = "ls -la";
      };
    };

    direnv = {
      enable = true;
      enableBashIntegration = true;
      nix-direnv.enable = true;
    };

    git = {
      enable = true;
      userName = "Jamie Temple";
      userEmail = "jamie-temple@live.de";
      signing.key = "1F7AD43C1F17EC41";
      signing.signByDefault = true;
    };

    gh.enable = true;

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
      keyConfig = ./settings/gitui.ron;
    };

    helix = {
      enable = true;
      defaultEditor = true;
      settings = builtins.fromTOML (builtins.readFile ./settings/hx-settings.toml);
    };

    starship = {
      enable = true;
      enableBashIntegration = true;
      settings = builtins.fromTOML (builtins.readFile ./settings/starship.toml);
    };

    vscode = {
      enable = true;
      # package = pkgs.vscodium;
      extensions = with pkgs.vscode-extensions; [
        christian-kohler.path-intellisense
        ecmel.vscode-html-css
        jnoortheen.nix-ide
        mads-hartmann.bash-ide-vscode
        mkhl.direnv
        ms-vscode.live-server
        nvarner.typst-lsp
        pkief.material-icon-theme
        tamasfe.even-better-toml
        yzhang.markdown-all-in-one
      ];
      mutableExtensionsDir = true;
      userSettings =
        (builtins.fromJSON (builtins.readFile ./settings/vscode.json))
        // {
          "terminal.integrated.defaultProfile.linux" = "bash";
          "terminal.integrated.profiles.linux" = {
            "bash" = {
              "path" = "${pkgs.bashInteractive}/bin/bash";
              "icon" = "terminal-bash";
            };
          };
        };
    };

    zellij = {
      enable = true;
      enableBashIntegration = true;
      settings = {
        simplified_ui = true;
      };
    };

    home-manager.enable = true;
  };
}
