# A flake for plover with support for plugins

This is an experimental flake which packages plover for nix, along with support for plugins from the plugins registry.

## Usage

Add this flake to your flake inputs, e.g. `inputs.plover-flake.url = "github:dnaq/plover-flake";`

Then a plover derivation containing the plugins you want can be built with

```nix
inputs.plover-flake.packages.${system}.plover.withPlugins (ps: with ps; [
  plover-lapwing-aio
  plover-console-ui
];
```

Where `ps` is an attribute set containing all plugins from the plugin registry, as well as some extra plugins.

## home-manager module

If you use [home-manager](https://github.com/nix-community/home-manager), there is a module available. Here is an example of a configuration:

```nix
# any file imported by home-manager, e.g. home.nix

{ inputs, ... }: {
  imports = [
    inputs.plover-flake.homeManagerModules.plover
  ];

  programs.plover = {
    enable = true;
    package = inputs.plover-flake.packages.${pkgs.system}.plover.withPlugins (
      ps: with ps; [
        plover-lapwing-aio
      ]
    );
    settings = {
      "Machine Configuration" = {
        machine_type = "Gemini PR";
        auto_start = true;
      };
      "Output Configuration".undo_levels = 100;
    };
  };
}
```

If you don't want nix to manage the configuration of plover, you can omit the `settings` value.

## Troubleshooting

If a specific plugin fails to build it is most likely because of a missing dependency. In that case that dependency can be added to overrides.nix, any pull requests doing so are welcome.
