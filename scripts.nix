pkgs: [
  (pkgs.writeShellScriptBin "overview" ''
    ${pkgs.uutils-coreutils-noprefix}/bin/echo -e "Available commands"
    ${pkgs.uutils-coreutils-noprefix}/bin/echo -e "  fmt:\n\tFormat Nix files without writing a lock file"
    ${pkgs.uutils-coreutils-noprefix}/bin/echo -e "  check\n\tRun statix and deadnix"
    ${pkgs.uutils-coreutils-noprefix}/bin/echo -e "  mend:\n\tAttempt to automatically fix issues found by statix"
    ${pkgs.uutils-coreutils-noprefix}/bin/echo -e "  dry-build:\n\tPerform a dry run build"
    ${pkgs.uutils-coreutils-noprefix}/bin/echo -e "  update:\n\tFormat and update flake inputs"
    ${pkgs.uutils-coreutils-noprefix}/bin/echo -e "  upgrade:\n\tFormat and switch to the new Home Manager configuration"
    ${pkgs.uutils-coreutils-noprefix}/bin/echo -e "  clean:\n\tRemove result symlink and other build artifacts"
  '')

  (pkgs.writeShellScriptBin "fmt" ''
    ${pkgs.nix}/bin/nix fmt --no-write-lock-file
  '')

  (pkgs.writeShellScriptBin "check" ''
    ${pkgs.statix}/bin/statix check .
    ${pkgs.deadnix}/bin/deadnix .
  '')

  (pkgs.writeShellScriptBin "mend" ''
    ${pkgs.statix}/bin/statix fix .
  '')

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
