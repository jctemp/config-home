#!/usr/bin/env bash

set -o errexit  # Exit on error
set -o nounset  # Exit on unset variables
set -o pipefail # Exit on pipe failures

# shellcheck disable=2086
dir=$(dirname "$(readlink -f $0)");

# shellcheck source=/dev/null
source "$dir/argument_parser.sh"
# shellcheck source=/dev/null
source "$dir/logging.sh"

### CLI

## OPTIONS
configuration_path="."
user="$(whoami)"
theme="rose-pine"
graphics="true"

print_usage() {
    cat << EOF
Usage: $(basename "${BASH_SOURCE[0]}") [options]

Options:
    -p, --path PATH         Configuration path (default: ".")
    -n, --name NAME         Configuration name (default: "whoami")
    -t, --theme THEME       Name of the colour theme (default: "rose-pine")
    -g, --graphics GRAPHICS Wether to allow GUI applications (default: true)
    -v, --verbose           Print verbose output (debug logs)
    -h, --help              Print this help message

Example:
    $(basename "${BASH_SOURCE[0]}") --name nixos 
EOF
}

cli_debug "Starting argument parsing"
while [[ $# -gt 0 ]]; do
    case $1 in
        -p|--path)
            parse_argument "configuration_path" "$2"
            cli_debug "Set configuration path: $configuration_path"
            shift 2
            ;;
        -n|--name)
            parse_argument "name" "$2"
            cli_debug "Set user: $user"
            shift 2
            ;;
        -t|--theme)
            parse_argument "theme" "$2"
            cli_debug "Set theme: $theme"
            shift 2
            ;;
        -g|--graphics)
            parse_argument "configuration_name" "$2"
            cli_debug "Set graphics: $graphics"
            shift 2
            ;;
        -v|--verbose)
            # variable is used in cli_debug function
            # shellcheck disable=2034
            VERBOSE=1
            shift 1
            ;;
        -h|--help)
            print_usage
            exit 0
            ;;
        *)
            cli_error "Unknown option $1"
            print_usage
            exit 1
            ;;
    esac
done

cli_debug "Starting parameter validation"
validation_errors=()

if [ ! -d "$configuration_path" ]; then
    validation_errors+=("Configuration path is not existing locally")
fi

if [ ${#validation_errors[@]} -ne 0 ]; then
    cli_error "Incorrect or missing arguments"
    for error in "${validation_errors[@]}"; do
        cli_error "  $error"
    done
    echo
    print_usage
    exit 1
fi

cli_info "Arguments validated successfully"
cli_debug "Final arguments:"
cli_debug "| CONFIGURATION"
cli_debug "  | Path:     $configuration_path"
cli_debug "  | User:     $user"
cli_debug "  | Theme:    $theme"
cli_debug "  | Graphics: $graphics"

sed -i -r "s|name = \"[a-zA-Z]+\";|name = \"$user\";|" "$configuration_path/flake.nix"
sed -i -r "s|theme = \"[a-zA-Z]+\";|theme = \"$theme\";|" "$configuration_path/flake.nix"
sed -i -r "s|graphicsSupport = \"[a-zA-Z]+\";|graphicsSupport = $graphics;|" "$configuration_path/flake.nix"

home-manager switch \
    --flake "${configuration_path}#$user" \
    --print-build-logs \
    --refresh 

