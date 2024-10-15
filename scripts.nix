pkgs: [
  (pkgs.writeShellScriptBin "overview" ''
    echo "Available commands"
    echo "  fmt:"
    echo "    Format Nix files without writing a lock file"
    echo "  check"
    echo "    Run statix and deadnix"
    echo "  mend:"
    echo "    Attempt to automatically fix issues found by statix"
    echo "  test:"
    echo "    Perform a dry run build"
    echo "  update:"
    echo "    Format and update flake inputs"
    echo "  upgrade:"
    echo "    Format and switch to the new Home Manager configuration"
    echo "  clean:"
    echo "    Remove result symlink and other build artifacts"
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
      user=$(whoami)
    fi
    echo Running home-manager for $user

    ${pkgs.nix}/bin/nix fmt --no-write-lock-file
    ${pkgs.home-manager}/bin/home-manager switch --flake .#$user
  '')

  (pkgs.writeShellScriptBin "clean" ''
    rm -f result
    nix-collect-garbage -d
  '')
]
