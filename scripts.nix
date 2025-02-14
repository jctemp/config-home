pkgs: [
  (pkgs.writeShellScriptBin "dry-build" ''
    ${pkgs.home-manager}/bin/home-manager build \
      --flake . \
      --dry-run \
      --print-build-logs \
      "$@"
  '')

  (pkgs.writeShellScriptBin "update" ''
    ${pkgs.nix}/bin/nix fmt --no-write-lock-file
    ${pkgs.nix}/bin/nix flake update
  '')

  (pkgs.writeShellScriptBin "upgrade" ''
    user=$1

    if [ -z $user ]; then
      user=$(${pkgs.uutils-coreutils-noprefix}/bin/whoami)
    fi
    ${pkgs.uutils-coreutils-noprefix}/bin/echo Running home-manager for $user

    ${pkgs.nix}/bin/nix fmt --no-write-lock-file
    ${pkgs.home-manager}/bin/home-manager switch --refresh --flake .#$user
  '')

  (pkgs.writeShellScriptBin "clean" ''
    ${pkgs.uutils-coreutils-noprefix}/bin/rm -f result
    ${pkgs.nix}/bin/nix-collect-garbage -d
  '')
]
