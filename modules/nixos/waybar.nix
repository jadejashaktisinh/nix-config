{ config, lib, pkgs, ... }:

{
  home-manager.users.webdev4 = { pkgs, ... }: {
    # Waybar with system info modules
    programs.waybar = {
      enable = true;
      systemd.enable = false;
      style = builtins.readFile ./waybar-style.css;
      settings.mainBar = {
        layer = "top";
        position = "bottom";
        height = 32;
        modules-left = [ "hyprland/workspaces" ];
        modules-center = [ "hyprland/window" ];
        modules-right = [ "cpu" "memory" "network" "tray" "clock" ];
        "hyprland/workspaces" = {
          format = "{id}";
          on-click = "activate";
        };
        cpu = {
          format = " {usage}%";
          interval = 3;
          tooltip = false;
        };
        memory = {
          format = " {}%";
          interval = 5;
          tooltip = false;
        };
        network = {
          format-wifi = " {signalStrength}%";
          format-ethernet = " {ifname}";
          format-disconnected = "⚠ offline";
          tooltip = false;
        };
        clock = {
          format = " {:%H:%M  %d %b}";
          tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
        };
        tray = { spacing = 8; };
      };
    };
  };
}