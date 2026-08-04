{ config, lib, pkgs, ... }:

{
  programs.hyprland.enable = true;
  programs.hyprland.xwayland.enable = true;

  # Use greetd for a more reliable Wayland login
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd 'dbus-run-session Hyprland'";
        user = "webdev4";
      };
    };
  };

  home-manager.users.webdev4 = { pkgs, ... }: {
    wayland.windowManager.hyprland = {
      enable = true;
      settings = {
        monitor = ",preferred,auto,1";

        "exec-once" = [
            # 1. CRITICAL: D-Bus environment setup MUST happen first.
            # We chain it with '&&' to guarantee gnome-keyring starts AFTER the environment is ready.
            # "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP && systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP && ${pkgs.gnome-keyring}/bin/gnome-keyring-daemon --start --components=secrets"

            # 2. UI / Desktop bars
            "waybar"
            "${pkgs.dunst}/bin/dunst &> /tmp/dunst.log"

            # 3. Clipboard history daemons
            "wl-paste --type text --watch cliphist store"
            "wl-paste --type image --watch cliphist store"

            # 4. Scratchpad terminal
            "kitty --class scratch"
          ];

        general = {
          gaps_in = 6;
          gaps_out = 12;
          "border_size" = 2;
          "col.active_border" = "rgba(89b4faee) rgba(cba6f7ee) 45deg";
          "col.inactive_border" = "rgba(1e1e2eaa)";
          layout = "dwindle";
        };

        decoration = {
          rounding = 10;
          blur = {
            enabled = true;
            size = 4;
            passes = 1;
            new_optimizations = true;
          };
          shadow = {
            enabled = true;
            range = 12;
            color = "rgba(1a1a2eee)";
          };
          "active_opacity" = 1.0;
          "inactive_opacity" = 0.92;
        };

        animations = {
          enabled = true;
          bezier = [
            "easeOut, 0.16, 1, 0.3, 1"
            "easeIn, 0.7, 0, 0.84, 0"
          ];
          animation = [
            "windows, 1, 4, easeOut, slide"
            "windowsOut, 1, 3, easeIn, slide"
            "fade, 1, 4, easeOut"
            "workspaces, 1, 4, easeOut, slide"
          ];
        };

        dwindle = {
          pseudotile = true;
          preserve_split = true;
        };

        input = {
          kb_layout = "us";
          follow_mouse = 1;
          touchpad.natural_scroll = false;
        };

        misc = {
          force_default_wallpaper = 0;
          disable_hyprland_logo = true;
        };

        # Scratchpad terminal rules
        windowrulev2 = [
          "workspace special:scratch silent, class:^(scratch)$"
          "float, class:^(scratch)$"
          "size 80% 70%, class:^(scratch)$"
          "center, class:^(scratch)$"
        ];

        "$mainMod" = "SUPER";
        bind = [
          "$mainMod, Q, exec, kitty"
          "$mainMod, C, killactive"
          "$mainMod, E, exec, firefox"
          "$mainMod, R, exec, rofi -show drun"
          "$mainMod, Space, exec, rofi -show drun"
          "$mainMod, V, togglefloating"
          "$mainMod, F, fullscreen"
          "$mainMod, L, exec, hyprlock"
          # Clipboard history picker
          "$mainMod, P, exec, cliphist list | rofi -dmenu | cliphist decode | wl-copy"
          # Scratchpad terminal toggle
          "$mainMod, grave, togglespecialworkspace, scratch"
          "$mainMod SHIFT, grave, movetoworkspace, special:scratch"
          # Screenshot
          "$mainMod SHIFT, S, exec, grimblast copy area"
          # File manager / lazygit
          "$mainMod, Y, exec, kitty -e yazi"
          "$mainMod, G, exec, kitty -e lazygit"
          # Arrow key focus/move
          "$mainMod, left, movefocus, l"
          "$mainMod, right, movefocus, r"
          "$mainMod, up, movefocus, u"
          "$mainMod, down, movefocus, d"
          "$mainMod SHIFT, left, movewindow, l"
          "$mainMod SHIFT, right, movewindow, r"
          "$mainMod SHIFT, up, movewindow, u"
          "$mainMod SHIFT, down, movewindow, d"
          # Vim-style focus
          "$mainMod, H, movefocus, l"
          "$mainMod, J, movefocus, d"
          "$mainMod, K, movefocus, u"
          "$mainMod, L, movefocus, r"
          # Vim-style move window
          "$mainMod SHIFT, H, movewindow, l"
          "$mainMod SHIFT, J, movewindow, d"
          "$mainMod SHIFT, K, movewindow, u"
          "$mainMod SHIFT, L, movewindow, r"
          # Workspaces
          "$mainMod, 1, workspace, 1"   "$mainMod, 2, workspace, 2"
          "$mainMod, 3, workspace, 3"   "$mainMod, 4, workspace, 4"
          "$mainMod, 5, workspace, 5"   "$mainMod, 6, workspace, 6"
          "$mainMod, 7, workspace, 7"   "$mainMod, 8, workspace, 8"
          "$mainMod, 9, workspace, 9"   "$mainMod, 0, workspace, 10"
          "$mainMod SHIFT, 1, movetoworkspace, 1"
          "$mainMod SHIFT, 2, movetoworkspace, 2"
          "$mainMod SHIFT, 3, movetoworkspace, 3"
          "$mainMod SHIFT, 4, movetoworkspace, 4"
          "$mainMod SHIFT, 5, movetoworkspace, 5"
          "$mainMod SHIFT, 6, movetoworkspace, 6"
          "$mainMod SHIFT, 7, movetoworkspace, 7"
          "$mainMod SHIFT, 8, movetoworkspace, 8"
          "$mainMod SHIFT, 9, movetoworkspace, 9"
          "$mainMod SHIFT, 0, movetoworkspace, 10"
        ];

        # Volume and brightness (no modifier needed for media keys)
        bindel = [
          ", XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
          ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
          ", XF86MonBrightnessUp, exec, brightnessctl set 5%+"
          ", XF86MonBrightnessDown, exec, brightnessctl set 5%-"
        ];
        bindl = [
          ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        ];

        bindm = [
          "$mainMod, mouse:272, movewindow"
          "$mainMod, mouse:273, resizewindow"
        ];
      };
    };
  };
}
