{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  inputs.flake-utils.url = "github:numtide/flake-utils";
  inputs.plover_plugins_registry = { url = "github:openstenoproject/plover_plugins_registry"; flake = false; };
  inputs.plover = { url = "github:openstenoproject/plover"; flake = false; };
  inputs.rtf-tokenize = { url = "github:openstenoproject/rtf_tokenize"; flake = false; };
  inputs.plover-stroke = { url = "github:openstenoproject/plover_stroke"; flake = false; };
  inputs.plover-machine-hid = { url = "github:dnaq/plover-machine-hid"; flake = false; };

  outputs = { self, nixpkgs, flake-utils, ... }@sources:
    flake-utils.lib.eachDefaultSystem
      (system:
      let pkgs = nixpkgs.legacyPackages.${system};
      in {
        devShells.default = pkgs.mkShell {
          PLUGINREGISTRY="${sources.plover_plugins_registry}/registry.json";
          packages = with pkgs; with python3Packages; [
            curl
            ipython
            jq
          ];
        };
        packages.plover = pkgs.python3Packages.callPackage ./plover.nix { inherit sources; };
        packages.default = self.packages.${system}.plover;
        packages.plover-with-plugins = f: let
          plover = self.packages.${system}.plover;
          plugins = pkgs.python3Packages.callPackage ./plugins.nix { inherit plover sources; };
        in
          plover.overrideAttrs (old: {
            propagatedBuildInputs = old.propagatedBuildInputs ++ (f plugins);
          });
      }
    );
}
