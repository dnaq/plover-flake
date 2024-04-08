# A flake for plover with support for plugins

## Usage

Add this flake to your flake inputs, e.g. `inputs.plover-flake.url = "github:dnaq/plover-flake";`

Then a plover derivation containing the plugins you want can be built with
```
  plover-flake.packages.${system}.plover.with-plugins (ps: with ps; [
    plover_dictionary_commands
    plover_console_ui
  ];
```
where `ps` is an attribute set containing all plugins from the plugin registry
as well as some extra plugins.

## Troubleshooting

If a specific plugin fails to build its most likely because of a missing
dependency. In that case that dependency can be added to overrides.nix,
any pull requests doing so are welcome.

## Updating the plugin list from the registry

At some point this will be added to CI and done automatically, but in
the meantime it is possible to do the following:

```
  nix develop
  bash update.sh
```

## Current Issues

In order to support plover2cat the pyqt derivation is overriden with `withMultimedia = true;`.
This holds even if plover2cat isn't installed, which might entail a bit of a waste of disk space.
If anyone figures out a good way for plugins to additively add qt features when dependen on, please let me know.
