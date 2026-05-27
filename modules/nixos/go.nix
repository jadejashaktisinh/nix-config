{ config, lib, pkgs, ... }: {
  options.modules.go.enable = lib.mkEnableOption "Go development environment";

  config = lib.mkIf config.modules.go.enable {
    environment.systemPackages = with pkgs; [ go gopls gotools ];
  };
}
