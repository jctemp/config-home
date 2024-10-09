let
  colors = import ./rose-pine.nix;
  createTheme = palette: {
    primary = {
      background = palette.base;
      foreground = palette.text;
    };
    normal = {
      black = palette.overlay;
      red = palette.primary;
      green = palette.quaternary;
      yellow = palette.secondary;
      blue = palette.quinary;
      magenta = palette.senary;
      cyan = palette.tertiary;
      white = palette.text;
    };
    bright = {
      black = palette.muted;
      red = palette.primary;
      green = palette.quaternary;
      yellow = palette.secondary;
      blue = palette.quinary;
      magenta = palette.senary;
      cyan = palette.tertiary;
      white = palette.text;
    };
    dim = {
      black = palette.muted;
      red = palette.primary;
      green = palette.quaternary;
      yellow = palette.secondary;
      blue = palette.quinary;
      magenta = palette.senary;
      cyan = palette.tertiary;
      white = palette.subtle;
    };
    cursor = {
      text = palette.base;
      cursor = palette.highlightMed;
    };
    vi_mode_cursor = {
      text = palette.base;
      cursor = palette.highlightMed;
    };
    search = {
      matches = {
        foreground = palette.base;
        background = palette.highlightMed;
      };
      focused_match = {
        foreground = palette.base;
        background = palette.tertiary;
      };
    };
    hints = {
      start = {
        foreground = palette.subtle;
        background = palette.surface;
      };
      end = {
        foreground = palette.muted;
        background = palette.surface;
      };
    };
    line_indicator = {
      foreground = "None";
      background = "None";
    };
    footer_bar = {
      foreground = palette.text;
      background = palette.surface;
    };
    selection = {
      inherit (palette) text;
      background = palette.highlightMed;
    };
  };
in {
  themes = {
    rosePine = createTheme colors.rosePine;
    rosePineDawn = createTheme colors.rosePineDawn;
    rosePineMoon = createTheme colors.rosePineMoon;
  };
}
