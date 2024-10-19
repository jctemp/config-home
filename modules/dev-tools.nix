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
              args = ["-t" "--lint"];
            };
            taplo = {
              command = "${pkgs.taplo}/bin/taplo";
              args = ["lsp" "stdio"];
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
            clangd = {command = "${pkgs.clang-tools}/bin/clangd";};
            gleam = {
              command = "${pkgs.gleam}/bin/gleam";
              args = ["lsp"];
            };
            nixd = {command = "${pkgs.nixd}/bin/nixd";};
            pylsp = {command = "${pkgs.python312Packages.python-lsp-server}/bin/pylsp";};
            rust-analyzer = {command = "${pkgs.rust-analyzer}/bin/rust-analyzer";};
            tinymist = {command = "${pkgs.tinymist}/bin/tinymist";};
            zls = {command = "${pkgs.zls}/bin/zls";};
          };

          language = let
            formatter = {
              command = "${pkgs.clang-tools}/bin/clang-format";
              args = ["-style=file" "-assume-filename=%f"];
            };
          in [
            {
              name = "c";
              inherit formatter;
            }
            {
              name = "cpp";
              inherit formatter;
            }
            {
              name = "nix";
              language-servers = ["nixd"];
              formatter = {command = "${pkgs.alejandra}/bin/alejandra";};
            }
            {
              name = "python";
              language-servers = ["pylsp"];
              formatter = {
                command = "${pkgs.ruff}/bin/ruff";
                args = ["format" "--silent" "-"];
              };
            }
            {
              name = "rust";
              formatter = {command = "${pkgs.rustfmt}/bin/rustfmt";};
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
                args = ["format" "-"];
              };
            }
            {
              name = "zig";
              formatter = {
                command = "${pkgs.zig}/bin/zig";
                args = ["fmt" "--stdin"];
              };
            }
          ];
        };
      };
    };
  };
}
