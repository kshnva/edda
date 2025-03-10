{
  description = "A Nix-flake-based R development environment";

  inputs.nixpkgs.url = "https://flakehub.com/f/NixOS/nixpkgs/0.1.*.tar.gz";

  outputs = {
    self,
    nixpkgs,
  }: let
    supportedSystems = ["x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin"];
    forEachSupportedSystem = f:
      nixpkgs.lib.genAttrs supportedSystems (system:
        f {
          pkgs = import nixpkgs {
            inherit system;
          };
        });
  in {
    devShells = forEachSupportedSystem ({pkgs}: {
      default = pkgs.mkShell {
        packages = with pkgs;
          [
            R
            pandoc
            texlive.combined.scheme-full
            python312Packages.radian
          ]
          ++ (with pkgs.rPackages; [
            knitr
            languageserver
            httpgd
            lintr
            lme4
            rmarkdown
            ggplot2
            dplyr
            bookdown
            tidyverse
            broom
            gt
          ]);
        shellHook = ''
          mkdir -p .vscode
          echo "{\"r.rterm.linux\": \"${pkgs.python312Packages.radian}/bin/radian\"}" > .vscode/settings.json
        '';
      };
    });
  };
}
