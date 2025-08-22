# Example flake.nix showing how to use the speedtest module

{
  description = "Example system configuration with speedtest module";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    home-manager.url = "github:nix-community/home-manager";
    
    # Add the speedtest module
    speedtest-module.url = "github:PulfordJ/nix-speedtest-module";
  };

  outputs = { self, nixpkgs, nix-darwin, home-manager, speedtest-module }:
  let
    system = "aarch64-darwin"; # or "x86_64-linux" for NixOS
  in
  {
    # NixOS configuration example
    nixosConfigurations.my-nixos-host = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        # Import the speedtest module
        speedtest-module.nixosModules.default
        
        # Your system configuration
        {
          # Enable the speedtest functionality
          programs.speedtest.enable = true;
          
          # Other system configuration...
          users.users.myuser = {
            isNormalUser = true;
            extraGroups = [ "wheel" ];
          };
          
          system.stateVersion = "24.05";
        }
      ];
    };

    # nix-darwin configuration example
    darwinConfigurations.my-darwin-host = nix-darwin.lib.darwinSystem {
      system = "aarch64-darwin";
      modules = [
        # Import the speedtest module
        speedtest-module.darwinModules.default
        
        # Your Darwin configuration
        {
          # Enable the speedtest functionality
          programs.speedtest.enable = true;
          
          # Enable Homebrew (required for corelocationcli on macOS)
          homebrew.enable = true;
          
          # Other Darwin configuration...
          users.users.myuser = {
            name = "myuser";
            home = "/Users/myuser";
          };
          
          system.stateVersion = 4;
        }
      ];
    };

    # Home Manager configuration example (if using standalone)
    homeConfigurations.myuser = home-manager.lib.homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages.${system};
      modules = [
        {
          home = {
            username = "myuser";
            homeDirectory = if system == "aarch64-darwin" then "/Users/myuser" else "/home/myuser";
            stateVersion = "24.05";
            
            # If speedtest module is system-wide, you can add shell aliases here
            shellAliases = {
              st = "speedtesthelper";
              speedtest-gps = "speedtesthelper";
            };
          };
          
          programs.zsh = {
            enable = true;
            shellAliases = {
              speedtest = "speedtesthelper";
            };
          };
        }
      ];
    };
  };
}