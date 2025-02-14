let
  colors = import ./rose-pine.nix;
  createTheme = palette: ''
    (
        selected_tab: Some("${palette.tertiary}"),
        command_fg: Some("${palette.text}"),
        selection_bg: Some("${palette.highlightLow}"),
        cmdbar_bg: Some("${palette.base}"),
        cmdbar_extra_lines_bg: Some("${palette.overlay}"),
        disabled_fg: Some("${palette.muted}"),
        diff_line_add: Some("${palette.quinary}"),
        diff_line_delete: Some("${palette.primary}"),
        diff_file_added: Some("${palette.secondary}"),
        diff_file_removed: Some("${palette.primary}"),
        diff_file_moved: Some("${palette.senary}"),
        commit_hash: Some("${palette.tertiary}"),
        commit_time: Some("${palette.quinary}"),
        commit_author: Some("${palette.secondary}"),
        danger_fg: Some("${palette.primary}"),
        push_gauge_bg: Some("${palette.overlay}"),
        push_gauge_fg: Some("${palette.quinary}"),
        tag_fg: Some("${palette.secondary}"),
        branch_fg: Some("${palette.quinary}"),
    )
  '';
in {
  themes = {
    rose-pine = createTheme colors.rosePine;
    rose-pine-dawn = createTheme colors.rosePineDawn;
    rose-pine-moon = createTheme colors.rosePineMoon;
  };
}
