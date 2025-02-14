{ lib, ... }:
{
  options.userSpec = {
    theme = lib.mkOption {
      type = lib.types.str;
      description = "Name of the theme";
    };
    graphicsSupport = lib.mkOption {
      type = lib.types.bool;
      description = "Allow GUI programs";
    };
  };
}
