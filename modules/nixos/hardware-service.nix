{ config, lib, pkgs, ... }: {

  # 1. Enable Hardware Bluetooth Services
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true; # Automatically power up controller on startup
    settings = {
      General = {
        Experimental = true; # Enables battery level indicators for accessories
      };
    };
  };

  # Enable Bluetooth background manager service (tray support)
  services.blueman.enable = true;

  # 2. Enable Networking Services (Wi-Fi + Ethernet)
  networking.networkmanager.enable = true;

  # 3. Inject standard icon fonts globally so Waybar can render them
  fonts.packages = with pkgs; [
    font-awesome # Essential glyphs for network/bluetooth bars
  ];

  # Allow your user account to manage networks without needing sudo every time
  users.users.webdev4.extraGroups = [ "networkmanager" ];
}