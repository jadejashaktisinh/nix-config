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
    modules.nginx.enable = lib.mkDefault true;

    services.mysql = {
      enable = true;
      package = pkgs.mariadb;
      ensureDatabases = [ "wordpress" "spatheory" ];
    };

    systemd.services.mysql.postStart = lib.mkAfter ''
      ${config.services.mysql.package}/bin/mysql -e "
        CREATE USER IF NOT EXISTS 'wordpress'@'localhost' IDENTIFIED BY 'root';
        ALTER USER 'wordpress'@'localhost' IDENTIFIED BY 'root';
        GRANT ALL PRIVILEGES ON wordpress.* TO 'wordpress'@'localhost';
        FLUSH PRIVILEGES;
      "
    '';

    # 1. Configure PHP-FPM for heavy-lifting
    services.phpfpm.pools.wordpress = {
      user = "webdev4";
      group = "nginx";
      
      phpOptions = ''
        log_errors = on
        upload_max_filesize = 20000M
        post_max_size = 20000M
        memory_limit = 2048M
        max_execution_time = 7200
        max_input_time = 7200
      '';

      settings = {
        "listen.owner" = config.services.nginx.user;
        "listen.group" = config.services.nginx.group;
        "listen.mode" = "0660";
        
        "pm" = "dynamic";
        "pm.max_children" = 32;
        "pm.start_servers" = 4;
        "pm.min_spare_servers" = 2;
        "pm.max_spare_servers" = 6;
        
        # FIX 1: Stop PHP-FPM from killing long-running background tasks
        "request_terminate_timeout" = "7200s"; 
      };
    };

    systemd.tmpfiles.rules = [
      "d /var/lib/wordpress 2775 webdev4 nginx -"
    ];

    # 2. Configure Nginx Virtual Host with matching thresholds
    services.nginx.virtualHosts.${config.modules.wordpress.domain} = {
      root = "/var/lib/wordpress";
      
      # FIX 2: Raise global vhost timeouts and payload limits
      extraConfig = ''
        keepalive_timeout 7200s;
        client_body_timeout 7200s;
        client_header_timeout 7200s;
        send_timeout 7200s;
        client_max_body_size 20000m;
        client_body_buffer_size 128k; # Keeps individual memory chunks small but highly efficient
      '';
    
      locations."/" = {
        index = "index.php index.html";
        tryFiles = "$uri $uri/ /index.php?$args";
      };

      # Match any file ending in .php safely
      locations."~ \\.php$" = {
        extraConfig = ''
          fastcgi_pass unix:/run/phpfpm/wordpress.sock;
          fastcgi_index index.php;
          include ${pkgs.nginx}/conf/fastcgi_params;
          fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;

          # FIX 3: Force NGINX to stay open while PHP processes massive data structures
          fastcgi_read_timeout 7200s;
          fastcgi_send_timeout 7200s;
          fastcgi_connect_timeout 7200s;
          
          # FIX 4: Optimize buffers for huge AJAX response payloads
          fastcgi_buffers 16 16k;
          fastcgi_buffer_size 32k;
        '';
      };
    };
  };
}
