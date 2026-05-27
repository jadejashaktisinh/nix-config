{ config, lib, pkgs, ... }:

{
  # Dunst - Notification Daemon
  # https://dunst-project.org/documentation/dunst.5.html
  services.dunst = {
    enable = true;
    settings = {
      global = {
        monitor = 0;
        follow = "mouse";
        geometry = "300x5-30+50";
        origin = "bottom-right";
        offset = "30x50";
        scale = 0;
        notification_height = 0;
        separator_height = 2;
        padding = 8;
        horizontal_padding = 10;
        frame_width = 2;
        frame_color = "#89b4fa"; # Blue from catppuccin
        separator_color = "frame";
        sort = "urgency, time";
        font = "JetBrainsMono Nerd Font 12";
        line_height = 0;
        markup = "full";
        format = "<b>%s</b>\n%b";
        alignment = "left";
        vertical_alignment = "center";
        show_age_threshold = 60;
        ellipsize = "middle";
        ignore_newline = "no";
        stack_duplicates = "true";
        hide_duplicate_count = "false";
        show_indicators = "yes";
        icon_path = "/run/current-system/sw/share/icons/papirus-dark/16x16/apps:/run/current-system/sw/share/icons/papirus-dark/32x32/apps";
        sticky_history = "yes";
        history_length = 20;
        dmenu = "/run/current-system/sw/bin/dmenu -p 'Notifications:'";
        browser = "/run/current-system/sw/bin/xdg-open";
        always_run_script = "true";
        title = "Dunst";
        class = "Dunst";
        startup_notification = "false";
        verbosity = "mesg";
        force_xinerama = "false";
      };
      urgency_low = {
        background = "#313244"; # Surface1
        foreground = "#cdd6f4"; # Text
        timeout = 10;
      };
      urgency_normal = {
        background = "#313244"; # Surface1
        foreground = "#cdd6f4"; # Text
        timeout = 10;
      };
      urgency_critical = {
        background = "#f38ba8"; # Red
        foreground = "#11111b"; # Crust
        frame_color = "#f38ba8"; # Red
        timeout = 0;
      };
    };
  };

  home-manager.users.webdev4.home.packages = with pkgs; [
    dunst
    libnotify
  ];
}