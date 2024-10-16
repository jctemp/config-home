pkgs: [
  (pkgs.writeShellScriptBin "overview" ''
    ${pkgs.uutils-coreutils-noprefix}/bin/echo "Available commands"
    ${pkgs.uutils-coreutils-noprefix}/bin/echo "  fmt:"
    ${pkgs.uutils-coreutils-noprefix}/bin/echo "    Format Nix files without writing a lock file"
    ${pkgs.uutils-coreutils-noprefix}/bin/echo "  check"
    ${pkgs.uutils-coreutils-noprefix}/bin/echo "    Run statix and deadnix"
    ${pkgs.uutils-coreutils-noprefix}/bin/echo "  mend:"
    ${pkgs.uutils-coreutils-noprefix}/bin/echo "    Attempt to automatically fix issues found by statix"
    ${pkgs.uutils-coreutils-noprefix}/bin/echo "  test:"
    ${pkgs.uutils-coreutils-noprefix}/bin/echo "    Perform a dry run build"
    ${pkgs.uutils-coreutils-noprefix}/bin/echo "  update:"
    ${pkgs.uutils-coreutils-noprefix}/bin/echo "    Format and update flake inputs"
    ${pkgs.uutils-coreutils-noprefix}/bin/echo "  upgrade:"
    ${pkgs.uutils-coreutils-noprefix}/bin/echo "    Format and switch to the new Home Manager configuration"
    ${pkgs.uutils-coreutils-noprefix}/bin/echo "  clean:"
    ${pkgs.uutils-coreutils-noprefix}/bin/echo "    Remove result symlink and other build artifacts"
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

  (pkgs.writeShellScriptBin "test" ''
    ${pkgs.home-manager}/bin/home-manager build \
      --flake . \
      --dry-run \
      --print-build-logs \
      $@
  '')

  (pkgs.writeShellScriptBin "update" ''
    ${pkgs.nix}/bin/nix fmt --no-write-lock-file
    ${pkgs.nix}/bin/nix flake update
  '')

  (pkgs.writeShellScriptBin "upgrade" ''
    local user=$1

    if [ -z $user ]; then
      user=$(${pkgs.uutils-coreutils-noprefix}/bin/whoami)
    fi
    ${pkgs.uutils-coreutils-noprefix}/bin/echo Running home-manager for $user

    ${pkgs.nix}/bin/nix fmt --no-write-lock-file
    ${pkgs.home-manager}/bin/home-manager switch --flake .#$user
  '')

  (pkgs.writeShellScriptBin "clean" ''
    ${pkgs.uutils-coreutils-noprefix}/bin/rm -f result
    ${pkgs.nix}/bin/nix-collect-garbage -d
  '')

]
