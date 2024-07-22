{
  buildPythonPackage,
  callPackage,
  fetchPypi,
  lib,
  plover,
  sources,
}: let
  inherit (lib) extends;
  getName = plugin: lib.lists.head (builtins.split "-[0-9]" plugin.filename);
  plugins = builtins.fromJSON (builtins.readFile ./plugins.json);
  makePloverPlugin = plugin: (buildPythonPackage rec {
    pname = plugin.name;
    version = plugin.version;
    src = fetchPypi {
      inherit version;
      pname = lib.lists.head (builtins.split "-[0-9]" plugin.filename);
      sha256 = plugin.sha256;
    };
    buildInputs = [plover];
  });
  makeRenamedPloverPlugin = plugin: let
    name = getName plugin;
  in {
    inherit name;
    value = throw "The plugin ${name} has been renamed to ${plugin.name}. See the readme for more info.";
  };
  pluginToAttr = p: {
    name = p.pname;
    value = p;
  };
  basicPlugins = final: prev:
    builtins.listToAttrs (map (p: makeRenamedPloverPlugin p) plugins)
    # Concat the sets and make sure the correct names have priority over the renamed ones
    // builtins.listToAttrs (map (p: pluginToAttr (makePloverPlugin p)) plugins);
  overrides = callPackage ./overrides.nix {};

  initialPackages = self: callPackage ./extra-plugins.nix {inherit plover sources;};

  extensible-self =
    lib.makeExtensible
    (
      extends overrides
      (extends basicPlugins initialPackages)
    );
in
  extensible-self
