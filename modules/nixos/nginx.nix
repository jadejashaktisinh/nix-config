{ config, lib, pkgs, ... }: {
  options.modules.nginx.enable = lib.mkEnableOption "nginx web server";

  config = lib.mkIf config.modules.nginx.enable {
    services.nginx = {
      enable = true;
      recommendedGzipSettings = true;
      recommendedOptimisation = true;
      recommendedProxySettings = true;
      recommendedTlsSettings = true;
    };

    networking.firewall.allowedTCPPorts = [ 80 443 ];
  };
}
