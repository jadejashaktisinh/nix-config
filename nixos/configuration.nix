{ inputs, lib, config, pkgs, ... }: {
  imports = [
    ./hardware-configuration.nix
    ../modules/nixos/core.nix
    ../modules/nixos/desktop.nix
    ../modules/nixos/nginx.nix
    ../modules/nixos/go.nix
    ../modules/nixos/node.nix
    ../modules/nixos/wordpress.nix
    ../modules/nixos/hyprland.nix
    ../modules/nixos/waybar.nix
    ../modules/nixos/fonts.nix
  ];

  nixpkgs.overlays = [
    inputs.self.overlays.additions
    inputs.self.overlays.modifications
    inputs.self.overlays.unstable-packages
  ];

  # --- Toggle services here ---
  modules.nginx.enable     = true;
  modules.go.enable        = true;
  modules.node.enable      = true;
  modules.wordpress.enable = true;   # flip true + set domain to activate
  # modules.wordpress.domain = "example.com";
}
