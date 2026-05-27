{ config, lib, pkgs, ... }: {
  # Auto-lock on idle
  services.hypridle.enable = true;

  environment.systemPackages = with pkgs; [
    # Desktop
    firefox kitty slack rofi mpvpaper mako
    wl-clipboard grimblast cliphist
    # Media / brightness
    brightnessctl wireplumber
    # Terminal tools
    neovim helix bat eza fzf zoxide yazi lazygit btop direnv starship
    # System
    fastfetch wget jq
    # setwallpaper: switch live (video) or static (image) wallpaper instantly
    (writeShellScriptBin "setwallpaper" ''
      FILE="$1"
      if [ -z "$FILE" ]; then
        echo "Usage: setwallpaper <path-to-video-or-image>"
        exit 1
      fi
      pkill -x mpvpaper 2>/dev/null || true
      MONITORS=$(hyprctl monitors -j | ${jq}/bin/jq -r '.[].name')
      for MON in $MONITORS; do
        mpvpaper -o "no-audio loop hwdec=auto-safe vd-lavc-threads=2 fps=30" "$MON" "$FILE" &
      done
    '')
  ];

  # direnv shell hook system-wide
  programs.direnv.enable = true;

  home-manager.users.webdev4 = { pkgs, ... }: {
    home.stateVersion = "25.11";

    # Fastfetch config
    xdg.configFile."fastfetch/config.jsonc".source = ./fastfetch.jsonc;

    # hyprlock config
    xdg.configFile."hypr/hyprlock.conf".text = ''
      background {
        monitor =
        color = rgba(30, 30, 46, 1.0)
      }
      input-field {
        monitor =
        size = 300, 50
        outline_thickness = 2
        outer_color = rgb(89b4fa)
        inner_color = rgb(30, 30, 46)
        font_color = rgb(205, 214, 244)
        placeholder_text = <i>Password...</i>
        position = 0, -100
        halign = center
        valign = center
      }
      label {
        monitor =
        text = cmd[update:1000] echo "<b>$(date +"%H:%M")</b>"
        color = rgba(205, 214, 244, 1.0)
        font_size = 64
        position = 0, 100
        halign = center
        valign = center
      }
    '';

    # hypridle: lock → hyprlock → suspend (safe ordering)
    xdg.configFile."hypr/hypridle.conf".text = ''
      listener {
        timeout = 300
        on-timeout = loginctl lock-session
      }
      listener {
        timeout = 330
        on-timeout = hyprlock
      }
      listener {
        timeout = 600
        on-timeout = systemctl suspend
      }
    '';

    # nix-direnv: caches nix shells so `use flake` doesn't rebuild every time
    programs.direnv.enable = true;
    programs.direnv.nix-direnv.enable = true;

    # Neovim
    programs.neovim = {
      enable = true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;
      extraConfig = ''
        set number relativenumber
        set tabstop=2 shiftwidth=2 expandtab
        set termguicolors
        set scrolloff=8
        set signcolumn=yes
        set updatetime=100
        set clipboard=unnamedplus
      '';
      plugins = with pkgs.vimPlugins; [
        # Catppuccin theme
        catppuccin-nvim
        # Statusline
        lualine-nvim
        # File tree
        nvim-tree-lua
        nvim-web-devicons
        # Fuzzy finder
        telescope-nvim
        plenary-nvim
        # LSP
        nvim-lspconfig
        # Treesitter
        (nvim-treesitter.withPlugins (p: with p; [
          nix lua bash javascript typescript python go
        ]))
        # Autocompletion
        nvim-cmp
        cmp-nvim-lsp
        luasnip
        # Git signs in gutter
        gitsigns-nvim
        # Auto pairs
        nvim-autopairs
        # Comment toggle
        comment-nvim
      ];
      extraLuaConfig = ''
        -- Theme
        require("catppuccin").setup({ flavour = "mocha" })
        vim.cmd.colorscheme("catppuccin")

        -- Statusline
        require("lualine").setup({ options = { theme = "catppuccin" } })

        -- File tree (toggle with <leader>e)
        require("nvim-tree").setup()
        vim.keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>", { silent = true })

        -- Telescope (fuzzy find)
        local tb = require("telescope.builtin")
        vim.keymap.set("n", "<leader>ff", tb.find_files)
        vim.keymap.set("n", "<leader>fg", tb.live_grep)
        vim.keymap.set("n", "<leader>fb", tb.buffers)

        -- Treesitter
        require("nvim-treesitter.configs").setup({
          highlight = { enable = true },
          indent = { enable = true },
        })

        -- Gitsigns
        require("gitsigns").setup()

        -- Autopairs
        require("nvim-autopairs").setup()

        -- Comment (gcc to toggle line, gc in visual)
        require("Comment").setup()

        -- Completion
        local cmp = require("cmp")
        cmp.setup({
          snippet = { expand = function(args) require("luasnip").lsp_expand(args.body) end },
          mapping = cmp.mapping.preset.insert({
            ["<C-Space>"] = cmp.mapping.complete(),
            ["<CR>"]      = cmp.mapping.confirm({ select = true }),
            ["<Tab>"]     = cmp.mapping.select_next_item(),
            ["<S-Tab>"]   = cmp.mapping.select_prev_item(),
          }),
          sources = cmp.config.sources({
            { name = "nvim_lsp" },
            { name = "luasnip" },
          }),
        })

        -- LSP (nil_ls for Nix, ts_ls for JS/TS)
        local caps = require("cmp_nvim_lsp").default_capabilities()
        local lsp = require("lspconfig")
        lsp.nil_ls.setup({ capabilities = caps })
        lsp.ts_ls.setup({ capabilities = caps })
        lsp.gopls.setup({ capabilities = caps })

        -- LSP keymaps on attach
        vim.api.nvim_create_autocmd("LspAttach", {
          callback = function(ev)
            local opts = { buffer = ev.buf, silent = true }
            vim.keymap.set("n", "gd",  vim.lsp.buf.definition, opts)
            vim.keymap.set("n", "K",   vim.lsp.buf.hover, opts)
            vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
            vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
          end,
        })
      '';
    };

    # LSP servers as packages
    home.packages = with pkgs; [ nil nodePackages.typescript-language-server gopls mariadb ];

    programs.bash = {
      enable = true;
      initExtra = ''
        if [[ $- == *i* ]]; then fastfetch; fi
      '';
    };
  };
}
