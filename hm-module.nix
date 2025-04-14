self:
{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.programs.plover;
  iniFormat = pkgs.formats.ini { };
in
{
  options.programs.plover = {
    enable = lib.mkEnableOption "plover";

    package = lib.mkOption {
      type = lib.types.package;
      default = self.packages.${pkgs.system}.plover;
      example =
        lib.literalExpression # nix
          ''
            inputs.plover-flake.${pkgs.system}.plover.withPlugins (ps: with ps; [
              plover-lapwing-aio
              plover-console-ui
            ])
          '';
    };

    settings = lib.mkOption {
      description = ''
        The plover configuration, written to `$XDG_CONFIG_HOME/plover/plover.cfg`.
        If null, the configuration will not be managed by home-manager.
      '';
      type =
        with lib.types;
        with lib.options;
        nullOr (submodule {
          freeformType = iniFormat.type;

          options = {
            "Machine Configuration" = {
              machine_type = mkOption {
                type = str;
                example = "Gemini PR";
              };

              auto_start = mkOption {
                type = bool;
                example = false;
              };
            };

            "Output Configuration" = {
              undo_levels = mkOption {
                type = int;
                example = 100;
              };
            };

            "Translation Frame" = {
              opacity = mkOption {
                type = int;
                example = 100;
              };
            };

            "Gemini PR" = {
              baudrate = mkOption {
                type = int;
                example = 9600;
              };

              bytesize = mkOption {
                type = int;
                example = 8;
              };

              parity = mkOption {
                type = str;
                example = "N";
              };

              port = mkOption {
                type = str;
                example = "/dev/ttyACM0";
              };

              stopbits = mkOption {
                type = int;
                example = 1;
              };

              timeout = mkOption {
                type = float;
                example = 2.0;
              };
            };

            "Plugins" = {
              enabled_extensions = mkOption {
                type = listOf str;
                example = [
                  "modal_update"
                  "plover_auto_reconnect_machine"
                ];
              };
            };

            "System" = {
              name = mkOption {
                type = str;
                example = "Lapwing";
              };
            };

            "Startup" = {
              "start minimized" = mkOption {
                type = bool;
                example = false;
              };
            };

            "Logging Configuration" = {
              log_file = mkOption {
                type = str;
                example = "strokes.log";
              };
            };

            "System: Lapwing" = {
              dictionaries = mkOption {
                type = listOf (submodule {
                  options = {
                    enabled = mkOption {
                      type = bool;
                      example = true;
                    };
                    path = mkOption {
                      type = str;
                      example = "user.json";
                    };
                  };
                });
              };
            };
          };
        });
      default = null;
    };
  };

  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      {
        home.packages = [ cfg.package ];
      }
      (lib.mkIf (cfg.settings != null) {
        xdg.configFile."plover/plover.cfg".source = (iniFormat.generate cfg.settings);
      })
    ]
  );
}
