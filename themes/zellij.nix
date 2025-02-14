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
    rose-pine = createTheme colors.rosePine;
    rose-pine-dawn = createTheme colors.rosePineDawn;
    rose-pine-moon = createTheme colors.rosePineMoon;
  };
}
