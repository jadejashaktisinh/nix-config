{
  config,
  lib,
  pkgs,
  ...
}:
{
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.networkmanager.enable = true;
  networking.hostName = "nixos";

  time.timeZone = "Asia/Kolkata";

  nix.settings = {
    experimental-features = "nix-command flakes";
    flake-registry = "";
  };
  nix.channel.enable = false;

  nixpkgs.config.allowUnfree = true;

  security.sudo.enable = true;

  users.users.webdev4 = {
    isNormalUser = true;
    description = "webdev4";
    extraGroups = [
      "wheel"
      "networkmanager"
      "docker"
      "nginx"
    ];
    shell = pkgs.bash;
    initialPassword = "123456";
  };

  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = false;
    };
  };

  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    stdenv.cc.cc
    zlib
    fuse3
    alsa-lib
    openssl
    icu
    libuuid
  ];

  environment.systemPackages = with pkgs; [
    git
    neovim
    vscode
    wget
    curl
    unzip
    gemini-cli
    pkgs.zed-editor
  ];

  system.stateVersion = "25.11";
  services.dbus.enable = true;
  services.dbus.packages = [ pkgs.gcr ];

  services.earlyoom = {
    enable = true;

    # Send SIGTERM if free RAM drops below 10%
    freeMemThreshold = 10;

    # Send SIGKILL if free RAM drops below 5%
    freeMemKillThreshold = 5;

    # Send SIGTERM if free Swap drops below 10%
    freeSwapThreshold = 10;

    # Send SIGKILL if free Swap drops below 5%
    freeSwapKillThreshold = 5;

    # Pass custom arguments to prefer/avoid certain applications
    # --avoid protects a process; --prefer targets it first
    extraArgs = [
      "--avoid" "^(Xorg|Xwayland|gnome-shell|sway)$"
      "--prefer" "^(chrome|firefox|nix-daemon)$"
    ];

  };

  networking.hosts = {
    "127.0.0.1" = [ "adminer.local" ];
  };

}
