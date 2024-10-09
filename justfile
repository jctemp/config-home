# Default to the current user if no username is provided
default_username := `whoami`

# Print the available commands
default:
  just --list

# Format Nix files without writing a lock file
fmt:
    nix fmt --no-write-lock-file

# Run statix to check for anti-patterns
statix:
    statix check .

# Run deadnix to find dead code
deadnix:
    deadnix .

# Format, run statix and deadnix, and perform a dry run build
check: fmt statix deadnix

# Attempt to automatically fix issues found by statix
fix:
    statix fix .
    just fmt

# Perform a dry run build
test args="":
    home-manager build --flake . --dry-run --print-build-logs {{args}}


# Format and update flake inputs
update:
    just fmt
    nix flake update

# Format and switch to the new Home Manager configuration
upgrade username=default_username:
    just fmt
    home-manager switch --flake .#{{username}}

# Alias for upgrade (for users more familiar with 'apply' terminology)
apply username=default_username: (upgrade username)


# Remove result symlink and other build artifacts
clean:
    rm -f result
    nix-collect-garbage -d
    
