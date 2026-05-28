{ config, lib, pkgs, ... }: {
  options.modules.nginx.enable = lib.mkEnableOption "nginx web server";

  config = lib.mkIf config.modules.nginx.enable {
    services.nginx = {
      enable = true;
      recommendedGzipSettings = true;
      recommendedOptimisation = true;
      recommendedProxySettings = true;
      recommendedTlsSettings = true;
      clientMaxBodySize = "10000m";
      commonHttpConfig = ''
        client_body_timeout 3600s;
        client_header_timeout 3600s;
        send_timeout 3600s; 
        client_body_buffer_size 50M;
      '';
    };

    networking.firewall.allowedTCPPorts = [ 80 443 ];
  };
}
