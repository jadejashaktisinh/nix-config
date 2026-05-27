{ config, lib, pkgs, ... }:

{
  # zsh as default login shell (mkForce overrides bash set in core.nix)
  programs.zsh.enable = true;
  users.users.webdev4.shell = lib.mkForce pkgs.zsh;

  home-manager.users.webdev4 = { pkgs, ... }: {
    # Zsh
    programs.zsh = {
      enable = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
      initContent = ''
        eval "$(zoxide init zsh)"
        eval "$(starship init zsh)"
        eval "$(direnv hook zsh)"
        if [[ $- == *i* ]]; then fastfetch; fi
        alias ls='eza --icons'
        alias ll='eza -la --icons --git'
        alias cat='bat'
        alias cd='z'
      '';
    };

    # Starship prompt — Catppuccin Mocha
    programs.starship = {
      enable = true;
      settings = {
        format = "$directory$git_branch$git_status$nix_shell$cmd_duration$line_break$character";
        directory = { style = "bold blue"; truncation_length = 3; };
        git_branch = { style = "bold mauve"; symbol = " "; };
        git_status = { style = "bold red"; };
        nix_shell = { style = "bold cyan"; symbol = " "; };
        character = {
          success_symbol = "[❯](bold green)";
          error_symbol = "[❯](bold red)";
        };
      };
    };
  };
}
