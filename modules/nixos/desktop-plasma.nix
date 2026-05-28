{ config, lib, pkgs, ... }:

{
  # ---------------------------------------------------------------------------
  # SYSTEM LAYER (Native KDE SDDM display manager and Plasma 6)
  # ---------------------------------------------------------------------------
  services.xserver.enable = true;
  
  services.displayManager = {
    sddm = {
      enable = true;
      wayland.enable = true;
    };
    defaultSession = "plasma";
  };

  services.desktopManager.plasma6.enable = true;

  # Essential backend hardware services
  services.blueman.enable = true;
  networking.networkmanager.enable = true;
  
  # Inject fonts globally so your terminal and layouts render beautifully
  fonts.packages = with pkgs; [
    font-awesome
    nerd-fonts.jetbrains-mono
  ];

  # ---------------------------------------------------------------------------
  # USER LAYER (Pure Native Home Manager)
  # ---------------------------------------------------------------------------
  home-manager.users.webdev4 = { pkgs, ... }: {
    
    # 1. Custom Automatic Autostart Daemons (Replaces exec-once)
    home.file = {
      ".config/autostart/cliphist.desktop".text = ''
        [Desktop Entry]
        Type=Application
        Name=Cliphist
        Exec=wl-paste --type text --watch cliphist store
        Hidden=false
        NoDisplay=false
        X-GNOME-Autostart-enabled=true
      '';
      ".config/autostart/mpvpaper.desktop".text = ''
        [Desktop Entry]
        Type=Application
        Name=Mpvpaper
        Exec=mpvpaper -o "no-audio loop hwdec=auto-safe vd-lavc-threads=2 fps=30" all /home/webdev4/wallpapers/girl-of-the-coral-deep.mp4
        Hidden=false
        NoDisplay=false
        X-GNOME-Autostart-enabled=true
      '';
    };

    # 2. Native Custom Hotkeys Configuration for KDE
    # This writes directly to the native KDE global shortcuts config file
    xdg.configFile."kglobalshortcutsrc".text = ''
      [khotkeys]
      _k_run_command_kitty=Meta+Q,none,Launch Kitty
      _k_run_command_firefox=Meta+E,none,Launch Firefox
      _k_run_command_yazi=Meta+Y,none,Launch Yazi
      _k_run_command_lazygit=Meta+G,none,Launch Lazygit
      _k_run_command_cliphist=Meta+P,none,Clipboard Menu

      [kwin]
      Kill Window=Meta+C,none,Close Window
      Window Maximize=Meta+F,none,Maximize Window
      Toggle Floating=Meta+V,none,Toggle Floating Window
      Window to Direction Left=Meta+H,none,Walk Through Windows (Left)
      Window to Direction Down=Meta+J,none,Walk Through Windows (Down)
      Window to Direction Up=Meta+K,none,Walk Through Windows (Up)
      Window to Direction Right=Meta+L,none,Walk Through Windows (Right)
      Switch to Workspace 1=Meta+1,none,Switch to Desktop 1
      Switch to Workspace 2=Meta+2,none,Switch to Desktop 2
      Switch to Workspace 3=Meta+3,none,Switch to Desktop 3
      Switch to Workspace 4=Meta+4,none,Switch to Desktop 4
      Switch to Workspace 5=Meta+5,none,Switch to Desktop 5
      Switch to Workspace 6=Meta+6,none,Switch to Desktop 6
      Switch to Workspace 7=Meta+7,none,Switch to Desktop 7
      Switch to Workspace 8=Meta+8,none,Switch to Desktop 8
      Switch to Workspace 9=Meta+9,none,Switch to Desktop 9
      Switch to Workspace 10=Meta+0,none,Switch to Desktop 10

      [org.kde.krunner.desktop]
      RunCommand=Meta+Space\tMeta+R,none,Run Command
      
      [org.kde.spectacle.desktop]
      RectangularRegionScreenShot=Meta+Shift+S,none,Take Rectangular Region Screenshot
    '';

    # 3. Create the backend execution scripts for your commands
    home.file.".local/share/khotkeys/_k_run_command_kitty.desktop".text = "Expiry Application\n[Desktop Entry]\nExec=kitty\nType=Application";
    home.file.".local/share/khotkeys/_k_run_command_firefox.desktop".text = "Expiry Application\n[Desktop Entry]\nExec=firefox\nType=Application";
    home.file.".local/share/khotkeys/_k_run_command_yazi.desktop".text = "Expiry Application\n[Desktop Entry]\nExec=kitty -e yazi\nType=Application";
    home.file.".local/share/khotkeys/_k_run_command_lazygit.desktop".text = "Expiry Application\n[Desktop Entry]\nExec=kitty -e lazygit\nType=Application";
    home.file.".local/share/khotkeys/_k_run_command_cliphist.desktop".text = "Expiry Application\n[Desktop Entry]\nExec=cliphist list | rofi -dmenu | cliphist decode | wl-copy\nType=Application";
  };
}