{ config, lib, pkgs, ... }:

{
  home-manager.users.webdev4 = { pkgs, ... }: {
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
        # Added 'bluetooth' right into your display modules line
        modules-right = [ "cpu" "memory" "network" "bluetooth" "tray" "clock" ];
        
        "hyprland/workspaces" = {
          format = "{id}";
          on-click = "activate";
        };
        
        cpu = {
          format = " {usage}%";
          interval = 3;
          tooltip = false;
        };
        
        memory = {
          format = " {}%";
          interval = 5;
          tooltip = false;
        };
        
        # Enhanced Network module with clear font icons
        network = {
          # Left click opens a terminal-based network selector (nmtui)
          on-click = "${pkgs.kitty}/bin/kitty --class network-manager -e nmtui";
          format-wifi = " {essid} ({signalStrength}%)";
          format-ethernet = " {ifname}";
          format-linked = " {ifname} (No IP)";
          format-disconnected = " Offline";
          tooltip-format = "Subnet Mask: {ipaddr}/{cidr}\nGateway: {gwaddr}";
        };

        # Brand New Bluetooth control module
        bluetooth = {
          format = " {status}";
          format-disabled = " off";
          format-connected = " {num_connections} connected";
          tooltip-format = "{controller_alias}\t{controller_address}";
          tooltip-format-connected = "{controller_alias}\t{controller_address}\n\n{device_enumerate}";
          tooltip-format-enumerate-connected = "{device_alias}\t{device_address}";
          # Left click opens the graphical Blueman bluetooth manager manager window
          on-click = "${pkgs.blueman}/bin/blueman-manager";
        };

        clock = {
          format = " {:%H:%M  %d %b}";
          tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
        };
        
        tray = { spacing = 8; };
      };
    };
  };
}