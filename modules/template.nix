{
  config,
  lib,
  ...
}: {
  options.module.name.enable =
    lib.mkEnableOption
    "Enable template module";

  config = lib.mkIf config.module.name.enable {
    # configurations
  };
}
