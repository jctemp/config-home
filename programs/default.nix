{pkgs, ...}: {
  home = {
    packages = with pkgs; [
      # fx file manager
      bat
      chafa
      feh
      felix-fm
      zoxide
    ];

    file = {
      ".config/felix/config.yaml" = {
        enable = true;
        source = ./settings/fx-settings.yaml;
      };
    };

    # shellAliases = {
    #   code = "codium";
    # };
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
        mkhl.direnv
        ms-vscode-remote.remote-containers
        ms-vscode-remote.remote-ssh
        ms-vscode.live-server
        ms-vsliveshare.vsliveshare
        zhuangtongfa.material-theme

        ecmel.vscode-html-css
        golang.go
        haskell.haskell
        jnoortheen.nix-ide
        mads-hartmann.bash-ide-vscode
        ms-azuretools.vscode-docker
        ms-python.python
        ms-python.vscode-pylance
        ms-toolsai.jupyter
        ms-toolsai.jupyter-renderers
        ms-toolsai.vscode-jupyter-cell-tags
        ms-toolsai.vscode-jupyter-slideshow
        ms-vscode.cmake-tools
        ms-vscode.cpptools
        njpwerner.autodocstring
        nvarner.typst-lsp
        ocamllabs.ocaml-platform
        rust-lang.rust-analyzer
        serayuzgur.crates
        tamasfe.even-better-toml
        yzhang.markdown-all-in-one
        ziglang.vscode-zig
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
