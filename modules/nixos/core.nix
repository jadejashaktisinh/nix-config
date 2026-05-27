{ config, lib, pkgs, ... }: {
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.networkmanager.enable = true;
  networking.hostName = "nixos";

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
    extraGroups = [ "wheel" "networkmanager" "docker" ];
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
    stdenv.cc.cc zlib fuse3 alsa-lib openssl icu libuuid
  ];

  environment.systemPackages = with pkgs; [
    git neovim vscode wget curl unzip gemini-cli 
  ];

  system.stateVersion = "25.11";

}
