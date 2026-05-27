{ config, lib, pkgs, ... }:

{
  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    nerd-fonts.fira-code
    nerd-fonts.symbols-only   # icon-only font for apps that need it
    noto-fonts-color-emoji
    papirus-icon-theme
  ];
}
