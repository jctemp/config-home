{
  pkgs,
  username,
  stateVersion,
  ...
}: {
  imports = [
    ./programs
  ];

  # To write systemd services do not look at the nixpkgs. After service name
  # simply replicate the systemd service file with the Nix language.
  #
  # https://www.freedesktop.org/software/systemd/man/latest/systemd.service.html
  systemd.user = {
    enable = true;
    services = {
      "rclone-mount" = {
        Unit = {
          Description = "Mount Google Drive";
          After = ["network-online.target"];
          Wants = ["network-online.target"];
        };
        Service = {
          Type = "exec";
          ExecStart = ''
            ${pkgs.rclone}/bin/rclone mount \
              --vfs-cache-mode full \
              --vfs-cache-max-size 50G \
              --vfs-read-ahead 256M \
              --buffer-size 16M \
              --daemon \
              drive: ~/Drive
          '';
          Restart = "on-failure";
          RestartSec = "5s";
        };
        Install = {
          WantedBy = ["default.target"];
        };
      };
      "rclone-sync" = {
        Unit = {
          Description = "Sync Google Drive";
          After = ["network-online.target"];
          Requires = ["rclone-mount.service"];
        };
        Service = {
          Type = "oneshot";
          ExecStart = "${pkgs.rclone}/bin/rclone sync ~/Drive drive:";
          Restart = "on-failure";
          RestartSec = "5s";
        };
        Install = {
          WantedBy = ["default.target"];
        };
      };
      "rclone-backup-local" = {
        Unit = {
          Description = "Backup to local";
          After = ["network-online.target"];
          Requires = ["rclone-mount.service"];
        };
        Service = {
          Type = "oneshot";
          ExecStart = "${pkgs.rclone}/bin/rclone copy --fast-list --transfers 32 drive: ~/Backup";
          Restart = "on-failure";
          RestartSec = "5s";
        };
        Install = {
          WantedBy = ["default.target"];
        };
      };
    };
  };

  home = {
    inherit username stateVersion;
    homeDirectory = "/home/${username}";
    packages = with pkgs; [
      nvim

      # daily tools
      firefox
      google-chrome
      keepassxc
      spotify

      # Note-taking
      obsidian
      typst
      zotero
      rclone
    ];
  };

  systemd.user.startServices = "sd-switch";
}
