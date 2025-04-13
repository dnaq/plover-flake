# A flake for plover with support for plugins

This is an experimental flake which packages plover for nix, along with support for plugins from the plugins registry.

## Usage

Add this flake to your flake inputs, e.g. `inputs.plover-flake.url = "github:dnaq/plover-flake";`

Then a plover derivation containing the plugins you want can be built with

```nix
  plover-flake.packages.${system}.plover.with-plugins (ps: with ps; [
      plover-dict-commands
      plover-console-ui
  ];
```

where `ps` is an attribute set containing all plugins from the plugin registry
as well as some extra plugins.

> [!NOTE]
> The plugin names were recently changed to be the same as in the [plugins registry](https://github.com/openstenoproject/plover_plugins_registry). This means that they will now consistently use dashes `-` in the names.

## Troubleshooting

If a specific plugin fails to build it is most likely because of a missing dependency. In that case that dependency can be added to overrides.nix, any pull requests doing so are welcome.
