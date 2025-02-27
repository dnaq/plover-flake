{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/1da52dd49a127ad74486b135898da2cef8c62665";
  inputs.flake-utils.url = "github:numtide/flake-utils";
  inputs.plover_plugins_registry = {
    url = "github:openstenoproject/plover_plugins_registry";
    flake = false;
  };
  inputs.plover = {
    url = "github:greghope667/plover/pyqt6-migration";
    flake = false;
  };
  inputs.importlib-resources = {
    url = "github:python/importlib_resources/v5.13.0";
    flake = false;
  };
  inputs.pyqt6rc = {
    url = "github:domarm-comat/pyqt6rc";
    flake = false;
  };
  inputs.rtf-tokenize = {
    url = "github:openstenoproject/rtf_tokenize";
    flake = false;
  };
  inputs.plover-stroke = {
    url = "github:openstenoproject/plover_stroke";
    flake = false;
  };
  inputs.plover-machine-hid = {
    url = "github:dnaq/plover-machine-hid";
    flake = false;
  };
  inputs.plover2cat = {
    url = "github:greenwyrt/plover2CAT";
    flake = false;
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
    ...
  } @ sources:
    flake-utils.lib.eachDefaultSystem
    (
      system: let
        pkgs = nixpkgs.legacyPackages.${system};
      in {
        devShells.default = pkgs.mkShell {
          PLUGINREGISTRY = "${sources.plover_plugins_registry}/registry.json";
          packages = with pkgs; [
            curl
            python311Packages.ipython
            jq
          ];
        };
        packages.default = self.packages.${system}.plover;
        packages.plover = let
          pyqt6 = pkgs.python311Packages.pyqt6.override {withMultimedia = true;};
          plover = pkgs.python311Packages.callPackage ./plover.nix {inherit sources pyqt6;};
          with-plugins = f: let
            plugins = pkgs.python311Packages.callPackage ./plugins.nix {inherit plover sources;};
          in
            plover.overrideAttrs (old: {
              propagatedBuildInputs = old.propagatedBuildInputs ++ (f plugins);
            });
        in
          plover // {inherit with-plugins;};
      }
    );
}
