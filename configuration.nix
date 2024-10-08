{
  pkgs,
  username,
  stateVersion,
  ...
}: {
  home = {
    inherit username stateVersion;
    homeDirectory = "/home/${username}";
    packages = with pkgs; [
      firefox
      google-chrome
      keepassxc
      spotify
      zotero
    ];
  };

  programs = let
    theme = "rose-pine";
  in {
    alacritty = {
      enable = true;
      settings = {
        window.padding = {
          x = 5;
          y = 5;
        };
        scrolling.history = 10000;
        colors = (builtins.fromTOML (builtins.readFile ./themes/alacritty-${theme}.toml)).colors;
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
      keyConfig = ./settings/gitui.ron;
      theme = ./themes/gitui-${theme}.ron;
    };

    helix = {
      enable = true;
      defaultEditor = true;
      settings = {
        theme = builtins.replaceStrings ["-"] ["_"] theme;
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
          tinymist = {command = "${pkgs.tinymist}/bin/tinymist";};
          nixd = {command = "${pkgs.nixd}/bin/nixd";};
          zls = {command = "${pkgs.zls}/bin/zls";};
        };
        "language.debugger" = {
          name = "lldb-dap";
          command = "${pkgs.lldb}/bin/lldb-dap";
        };
        language = [
          {
            name = "nix";
            language-servers = ["nixd"];
            formatter = {
              command = "${pkgs.alejandra}/bin/alejandra";
            };
          }
          {
            name = "typst";
            formatter = {
              command = "${pkgs.typstyle}/bin/typstyle";
              args = ["format-all"];
            };
          }
        ];
      };
    };

    starship = {
      enable = true;
      enableBashIntegration = true;
      settings = builtins.fromTOML (builtins.readFile ./settings/starship.toml);
    };

    zellij = {
      enable = true;
      enableBashIntegration = true;
      settings = {
        inherit theme;
        simplified_ui = true;
        copy_command = "${pkgs.xclip}/bin/xclip -selection clipboard";
        themes = builtins.fromJSON (builtins.readFile ./themes/zellij-${theme}.json);
      };
    };

    home-manager.enable = true;
  };

  services.syncthing = {
    enable = true;
    extraOptions = [];
  };

  systemd.user.startServices = "sd-switch";
}
