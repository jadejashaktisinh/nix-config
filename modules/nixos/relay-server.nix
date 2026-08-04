{
  config,
  lib,
  pkgs,
  ...
}:
{

  services.nginx.virtualHosts."*.relayserver.com" = {
    locations."/" = {
      proxyPass = "http://127.0.0.1:8000"; # Change to your app's local port
      proxyWebsockets = true; # Enable if your app uses websockets
    };
  };
  services.dnsmasq = {
    enable = true;
    settings = {
      # Resolves any subdomain under relayserver.com to your local machine
      address = "/://relayserver.com/127.0.0.1";
    };
  };

  # Force your system to use the local dnsmasq instance for lookups
  networking.nameservers = [ "127.0.0.1" ];
}
