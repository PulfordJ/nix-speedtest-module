# Nix Speedtest Module

A Nix module that provides a speedtest command with GPS-based location detection and reverse geocoding for accurate location information.

## Features

- **Cross-platform support**: Works on NixOS and macOS (via nix-darwin)
- **GPS-based location**: Uses CoreLocationCLI on macOS for precise coordinates
- **Reverse geocoding**: Converts GPS coordinates to human-readable addresses
- **Fallback support**: Uses IP-based geolocation when GPS is unavailable
- **Automatic dependency management**: Handles installation of required tools

## Installation

### As a Flake Input

Add to your `flake.nix`:

```nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    speedtest-module.url = "github:PulfordJ/nix-speedtest-module";
  };

  outputs = { self, nixpkgs, speedtest-module, ... }: {
    # NixOS configuration
    nixosConfigurations.your-host = nixpkgs.lib.nixosSystem {
      modules = [
        speedtest-module.nixosModules.default
        {
          programs.speedtest.enable = true;
        }
      ];
    };

    # nix-darwin configuration
    darwinConfigurations.your-host = darwin.lib.darwinSystem {
      modules = [
        speedtest-module.darwinModules.default
        {
          programs.speedtest.enable = true;
        }
      ];
    };
  };
}
```

### Direct Import

Download and import directly:

```nix
# In your configuration.nix or darwin configuration
{
  imports = [ ./path/to/speedtest-module/default.nix ];
  
  programs.speedtest.enable = true;
}
```

## Usage

Once installed, the module provides:

- **`speedtesthelper`**: The main command
- **Shell alias**: `speedtest` alias pointing to `speedtesthelper` (configurable)

### Example Output

```bash
$ speedtest
## Speed Test - Fri 22 Aug 2025 18:11:54 CEST

**IP Address:** 203.0.113.1
**ISP/Provider:** AS1234 Example ISP
**Timezone:** America/New_York
**Getting precise GPS location...**
**GPS Coordinates:** [40.7128,-74.0060](https://maps.google.com/maps?q=40.7128,-74.0060)
**Resolving address from GPS coordinates...**
**Estimated Address (GPS-based):** 123 Main Street, New York, NY 10001, United States
**Street:** 123 Main Street
**City/State:** New York, NY
**Postal Code:** 10001
**Country:** United States

**Network Speed:**
- Ping: 12.345 ms
- Download: 150.67 Mbit/s
- Upload: 45.23 Mbit/s
```

## Configuration Options

```nix
programs.speedtest = {
  enable = true;
  
  # Optional: Customize the script name (default: "speedtesthelper")
  scriptName = "my-speedtest";
};
```

## Dependencies

The module automatically manages these dependencies:

### Cross-platform (via Nix)
- `speedtest-cli`: Network speed testing
- `curl`: HTTP requests for geolocation APIs

### macOS-specific (via Homebrew)
- `corelocationcli`: Precise GPS location detection

### Linux-specific
- Uses IP-based geolocation (no additional GPS dependencies)

## Testing

### Test the standalone script
```bash
# Run directly from the flake
nix run github:PulfordJ/nix-speedtest-module

# Or build and test locally
nix build github:PulfordJ/nix-speedtest-module
./result/bin/speedtesthelper
```

### Development shell
```bash
nix develop github:PulfordJ/nix-speedtest-module
```

## How It Works

1. **Network Information**: Fetches basic network info (IP, ISP, timezone) from ipinfo.io
2. **GPS Coordinates**: 
   - macOS: Uses CoreLocationCLI for precise GPS coordinates
   - Linux: Falls back to IP-based coordinates from ipinfo.io
3. **Reverse Geocoding**: Converts coordinates to addresses using OpenStreetMap Nominatim API
4. **Speed Test**: Runs speedtest-cli and formats the output

## Privacy Considerations

This tool makes requests to:
- `ipinfo.io` - For IP-based geolocation and network information
- `nominatim.openstreetmap.org` - For reverse geocoding GPS coordinates

On macOS, it may request location permission for CoreLocationCLI to access precise GPS coordinates.

## Contributing

Contributions are welcome! Please feel free to submit issues and pull requests.

## License

MIT License - see LICENSE file for details.