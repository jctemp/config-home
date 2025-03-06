{
  inputs,
  config,
  pkgs,
  lib,
  pkgs-stable,
  ...
}: let
  cfg = config.userSpec;
in
  lib.mkMerge [
    {
      nixpkgs.config = {
        allowUnfreePredicate = pkgs:
          builtins.elem (lib.getName pkgs) [
            "spotify"
            "google-chrome"
            "citrix_workspace_24_05_0"
            "citrix-workspace"
          ];
        permittedInsecurePackages = [
          "electron-27.3.11"
        ];
      };
      # https://www.citrix.com/downloads/workspace-app/legacy-workspace-app-for-linux/workspace-app-for-linux-latest1.html
      home.packages = lib.mkIf cfg.graphicsSupport (
        with pkgs; [
          keepassxc
          spotify
          zotero
          blender_4_3
          freecad
          logseq
          citrix_workspace_24_05_0
        ]
      );

      programs.chromium = lib.mkIf cfg.graphicsSupport {
        enable = true;
        package = pkgs.google-chrome;
      };
    }
    {
      programs = let
        alacrittyTheme = import "${inputs.self}/themes/alacritty.nix";
        zellijTheme = import "${inputs.self}/themes/zellij.nix";
      in {
        alacritty = lib.mkIf cfg.graphicsSupport {
          enable = true;
          settings = {
            window.padding = {
              x = 5;
              y = 5;
            };
            scrolling.history = 10000;
            colors = builtins.getAttr cfg.theme alacrittyTheme.themes;
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
          settings = builtins.fromTOML (builtins.readFile "${inputs.self}/config/settings/starship.toml");
        };

        zellij = {
          enable = true;
          enableBashIntegration = true;
          settings = {
            inherit (cfg) theme;
            inherit (zellijTheme) themes;
            simplified_ui = true;
            copy_command = "${pkgs.xclip}/bin/xclip -sel clipboard";
          };
        };
      };
    }
    {
      home.file = {
        ".gnupg/gpg.conf" = {
          text = ''
            personal-cipher-preferences AES256 AES192 AES
            personal-digest-preferences SHA512 SHA384 SHA256
            personal-compress-preferences ZLIB BZIP2 ZIP Uncompressed
            default-preference-list SHA512 SHA384 SHA256 AES256 AES192 AES ZLIB BZIP2 ZIP Uncompressed
            cert-digest-algo SHA512
            s2k-digest-algo SHA512
            s2k-cipher-algo AES256
            charset utf-8
            no-comments
            no-emit-version
            no-greeting
            keyid-format 0xlong
            list-options show-uid-validity
            verify-options show-uid-validity
            with-fingerprint
            require-cross-certification
            no-symkey-cache
            armor
            use-agent
            throw-keyids
          '';
        };
        ".gnupg/scdaemon.conf" = {
          enable = true;
          text = "disable-ccid";
        };
      };

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
          userEmail = "jamie.c.temple@gmail.com";
          signing.key = "6A89175BB28B8B81";
          signing.signByDefault = true;
          signing.signer = "${pkgs-stable.gnupg}/bin/gpg";
        };

        gitui = {
          enable = true;
          keyConfig = gituiSettings;
          theme = builtins.getAttr cfg.theme gituiTheme.themes;
        };
      };
    }
    {
      programs.direnv = {
        enable = true;
        enableBashIntegration = true;
        nix-direnv.enable = true;
      };
    }
    {
      programs.helix = {
        enable = true;
        defaultEditor = true;
        settings = {
          theme = builtins.getAttr cfg.theme (import "${inputs.self}/themes/helix.nix").themes;
          editor = {
            line-number = "absolute";
            true-color = true;
            rulers = [
              80
              120
            ];
            color-modes = true;
          };
          editor.lsp = {
            enable = true;
            display-messages = true;
            display-inlay-hints = true;
          };
          editor.file-picker = {
            hidden = false;
          };
        };

        languages = {
          language-server = {
            yaml-language-server = {
              command = "${pkgs.yaml-language-server}/bin/yaml-language-server";
              args = ["--stdio"];
            };
            jsonnet-language-server = {
              command = "${pkgs.jsonnet-language-server}/bin/jsonnet-language-server";
              args = [
                "-t"
                "--lint"
              ];
            };
            taplo = {
              command = "${pkgs.taplo}/bin/taplo";
              args = [
                "lsp"
                "stdio"
              ];
            };
            bash-language-server = {
              command = "${pkgs.nodePackages.bash-language-server}/bin/bash-language-server";
              args = ["start"];
            };
            marksman = {
              command = "${pkgs.marksman}/bin/marksman";
              args = ["server"];
            };
            docker-langserver = {
              command = "${pkgs.dockerfile-language-server-nodejs}/bin/docker-langserver";
              args = ["--stdio"];
            };
            docker-compose-langserver = {
              command = "${pkgs.docker-compose-language-service}/bin/docker-compose-langserver";
              args = ["--stdio"];
            };
            # Programming
            clangd = {
              command = "${pkgs.clang-tools}/bin/clangd";
            };
            gleam = {
              command = "${pkgs.gleam}/bin/gleam";
              args = ["lsp"];
            };
            nixd = {
              command = "${pkgs.nixd}/bin/nixd";
            };
            pylsp = {
              command = "${pkgs.python312Packages.python-lsp-server}/bin/pylsp";
            };
            rust-analyzer = {
              command = "${pkgs.rust-analyzer}/bin/rust-analyzer";
            };
            tinymist = {
              command = "${pkgs.tinymist}/bin/tinymist";
            };
            zls = {
              command = "${pkgs.zls}/bin/zls";
            };
          };

          language = let
            c-formatter = {
              command = "${pkgs.clang-tools}/bin/clang-format";
              args = [
                "-style=file"
                "-assume-filename=%f"
              ];
            };
          in [
            {
              name = "c";
              formatter = c-formatter;
            }
            {
              name = "cpp";
              formatter = c-formatter;
            }
            {
              name = "nix";
              language-servers = ["nixd"];
              formatter = {
                command = "${pkgs.alejandra}/bin/alejandra";
              };
            }
            {
              name = "python";
              language-servers = ["pylsp"];
              formatter = {
                command = "${pkgs.ruff}/bin/ruff";
                args = [
                  "format"
                  "--silent"
                  "-"
                ];
              };
            }
            {
              name = "rust";
              formatter = {
                command = "${pkgs.rustfmt}/bin/rustfmt";
              };
              persistent-diagnostic-sources = [
                pkgs.rustPlatform.rustLibSrc
                "${pkgs.rustc}/bin/rustc"
                "${pkgs.clippy}/bin/clippy"
              ];
            }
            {
              name = "typst";
              formatter = {
                command = "${pkgs.typstyle}/bin/typstyle";
                args = [
                  "format"
                  "-"
                ];
              };
            }
            {
              name = "zig";
              formatter = {
                command = "${pkgs.zig}/bin/zig";
                args = [
                  "fmt"
                  "--stdin"
                ];
              };
            }
          ];
        };
      };
    }
  ]
