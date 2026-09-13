# MindustryBinNix

Packages the official prebuilt [Mindustry](https://github.com/Anuken/Mindustry) client jar as a Nix
package, without building from source. (The `mindustry` package in nixpkgs rebuilds it with Gradle;
this repo uses the official `Mindustry.jar` directly.)

Each upstream release maps to one package, named like `mindustry-bin-160_3` (dots in the version are
replaced with `_`). There is no `default` or `mindustry-bin` alias — always refer to a concrete version.

## Usage

### Run directly

```sh
# Run once (nix builds/downloads automatically)
nix run github:yueyinqiu/MindustryBinNix#mindustry-bin-160_3

# Run from a local checkout
nix run .#mindustry-bin-160_3
```

### Ad-hoc shell

```sh
nix shell github:yueyinqiu/MindustryBinNix#mindustry-bin-160_3
# The `mindustry` command is now on PATH
mindustry
```

### Add to home-manager

Add this repo as a flake input:

```nix
{
  inputs = {
    home-manager.url = "github:nix-community/home-manager";
    mindustry-bin.url = "github:yueyinqiu/MindustryBinNix";
  };

  outputs = { home-manager, mindustry-bin, ... }: {
    homeConfigurations."your-user" = home-manager.lib.homeManagerConfiguration {
      # ... pkgs etc. omitted ...
      modules = [
        {
          home.packages = [
            mindustry-bin.packages.x86_64-linux.mindustry-bin-160_3
          ];
        }
      ];
    };
  };  
}
```

> Change the system to `aarch64-linux` to match yours.

---

Most of the content in this repository was generated with AI assistance.
