# Standalone home-manager entry point (unused when home-manager runs as NixOS module).
# Actual home config lives in modules/nixos/desktop.nix under home-manager.users.webdev4.
{ inputs, lib, config, pkgs, ... }: {
  home = {
    username = "webdev4";
    homeDirectory = "/home/webdev4";
    stateVersion = "25.11";
  };
  programs.home-manager.enable = true;
}
