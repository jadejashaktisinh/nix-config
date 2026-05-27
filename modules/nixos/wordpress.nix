{ config, lib, pkgs, ... }: {
  options.modules.wordpress = {
    enable = lib.mkEnableOption "WordPress site";
    domain = lib.mkOption {
      type = lib.types.str;
      default = "localhost";
      description = "Domain name for WordPress";
    };
  };

  config = lib.mkIf config.modules.wordpress.enable {
    # WordPress requires nginx and mysql
    modules.nginx.enable = lib.mkDefault true;

    services.mysql = {
      enable = true;
      package = pkgs.mariadb;
      ensureDatabases = [ "wordpress" ];
      ensureUsers = [{
        name = "wordpress";
        ensurePermissions = { "wordpress.*" = "ALL PRIVILEGES"; };
      }];
      initialScript = ''
        ALTER USER 'wordpress'@'localhost' IDENTIFIED BY 'mle3uEu2Yv139uKlet4CMIhyfgQKXcgW';
        FLUSH PRIVILEGES;
      '';
    };

    services.phpfpm.pools.wordpress = {
      user = "webdev4";
      settings = {
        "listen.owner" = config.services.nginx.user;
        "pm" = "dynamic";
        "pm.max_children" = 32;
        "pm.start_servers" = 2;
        "pm.min_spare_servers" = 2;
        "pm.max_spare_servers" = 4;
      };
    };

    services.nginx.virtualHosts.${config.modules.wordpress.domain} = {
      root = "/var/lib/wordpress";
      locations."/" = {
        index = "index.php index.html";
        tryFiles = "$uri $uri/ /index.php?$args";
      };
      locations."~ \\.php$" = {
        extraConfig = ''
          fastcgi_pass unix:${config.services.phpfpm.pools.wordpress.socket};
          fastcgi_index index.php;
          include ${pkgs.nginx}/conf/fastcgi_params;
          fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
        '';
      };
    };

    environment.systemPackages = with pkgs; [ php wordpress ];

    systemd.tmpfiles.rules = [
      "d /var/lib/wordpress 0750 webdev4 nginx -"
    ];


  };
}
