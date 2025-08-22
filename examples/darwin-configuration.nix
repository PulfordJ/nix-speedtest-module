# Example nix-darwin configuration using the speedtest module

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
    # scriptName = "network-test";
  };

  # The module automatically handles:
  # - Installing speedtest-cli via Nix
  # - Installing corelocationcli via Homebrew (homebrew.casks)
  # - Making speedtesthelper available in PATH

  # Enable Homebrew (required for corelocationcli)
  homebrew = {
    enable = true;
    # The speedtest module will automatically add "corelocationcli" to casks
  };

  # Example: Configure shell aliases
  programs.zsh.enable = true;

  # Other Darwin configuration...
  users.users.myuser = {
    name = "myuser";
    home = "/Users/myuser";
  };

  system.stateVersion = 4;
}