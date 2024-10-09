let
  colors = import ./rose-pine.nix;
  createTheme = palette: {
    bg = palette.base;
    fg = palette.text;
    red = palette.primary;
    green = palette.quaternary;
    blue = palette.quinary;
    yellow = palette.secondary;
    magenta = palette.senary;
    orange = palette.tertiary;
    cyan = palette.quinary;
    black = palette.overlay;
    white = palette.text;
  };
in {
  themes = {
    rosePine = createTheme colors.rosePine;
    rosePineDawn = createTheme colors.rosePineDawn;
    rosePineMoon = createTheme colors.rosePineMoon;
  };
}
