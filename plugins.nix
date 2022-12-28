{ 
  buildPythonPackage,
  callPackage,
  fetchPypi,
  lib,
  plover,
  sources,
}:
let
  inherit (lib) extends;
  plugins = builtins.fromJSON (builtins.readFile ./plugins.json);
  makePloverPlugin = plugin: (buildPythonPackage rec {
    pname = lib.lists.head (builtins.split "-[0-9]" plugin.filename);
    version = plugin.version;
    src = fetchPypi {
      inherit pname version;
      sha256 = plugin.sha256;
    };
    buildInputs = [ plover ];
  });
  pluginToAttr = p: { name = p.pname; value = p; };
  basicPlugins = final: prev: builtins.listToAttrs (map (p: pluginToAttr (makePloverPlugin p)) plugins);
  overrides = callPackage ./overrides.nix { };

  initialPackages = self: callPackage ./extra-plugins.nix { inherit plover sources; };

  extensible-self = lib.makeExtensible
    (extends overrides
      (extends basicPlugins initialPackages)
    );
in
  extensible-self