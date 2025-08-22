# Example NixOS configuration using the speedtest module

{ config, pkgs, ... }:

{
  imports = [
    # Import the speedtest module
    # Option 1: If using as a flake input, this import is handled in flake.nix
    # Option 2: Direct import (uncomment the line below)
    # ./path/to/nix-speedtest-module/default.nix
  ];

  # Enable the speedtest module
  programs.speedtest = {
    enable = true;
    # Optional: customize script name
    # scriptName = "my-speedtest";
  };

  # Example: Add shell alias in your shell configuration
  programs.zsh = {
    enable = true;
    shellAliases = {
      # The module automatically provides speedtesthelper
      # You can add your own alias if desired
      st = "speedtesthelper";
    };
  };

  # Other system configuration...
  users.users.myuser = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
  };

  system.stateVersion = "24.05";
}