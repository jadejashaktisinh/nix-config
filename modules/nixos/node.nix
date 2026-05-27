{ config, lib, pkgs, ... }: {
  options.modules.node.enable = lib.mkEnableOption "Node.js development environment";

  config = lib.mkIf config.modules.node.enable {
    environment.systemPackages = with pkgs; [ nodejs_22 nodePackages.npm nodePackages.yarn ];
  };
}
