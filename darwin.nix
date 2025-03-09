{
  buildPythonPackage,
  darwin,
  setuptools,
  sources,
}: let
  version = "11.0";
  src = sources.pyobjc;
in
  # Code taken from nixpkgs. Cannot use directly because pinned version of nixpkgs does not have these packages.
  rec {
    # https://github.com/NixOS/nixpkgs/blob/nixos-unstable/pkgs/development/python-modules/pyobjc-core/default.nix#L55
    pyobjc-core = buildPythonPackage {
      pname = "pyobjc-core";
      pyproject = true;

      inherit version src;

      sourceRoot = "source/pyobjc-core";

      build-system = [setuptools];

      buildInputs = [
        darwin.DarwinTools
        darwin.libffi
      ];

      nativeBuildInputs = [
        darwin.DarwinTools
      ];

      postPatch = ''
        for file in Modules/objc/test/*.m; do
          substituteInPlace "$file" --replace "[[clang::suppress]]" ""
        done
        substituteInPlace setup.py \
          --replace-fail "-buildversion" "-buildVersion" \
          --replace-fail "-productversion" "-productVersion"
      '';

      env.NIX_CFLAGS_COMPILE = toString [
        "-I${darwin.libffi.dev}/include"
        "-Wno-error=cast-function-type-mismatch"
        "-Wno-error=unused-command-line-argument"
      ];

      pythonImportsCheck = ["objc"];
    };

    # https://github.com/NixOS/nixpkgs/blob/nixos-unstable/pkgs/development/python-modules/pyobjc-framework-Cocoa/default.nix#L53
    pyobjc-framework-Cocoa = buildPythonPackage {
      pname = "pyobjc-framework-Cocoa";
      pyproject = true;

      inherit version src;

      sourceRoot = "source/pyobjc-framework-Cocoa";

      build-system = [setuptools];

      buildInputs = [
        darwin.libffi
        darwin.DarwinTools
      ];

      nativeBuildInputs = [
        darwin.DarwinTools
      ];

      postPatch = ''
        substituteInPlace pyobjc_setup.py \
          --replace-fail "-buildversion" "-buildVersion" \
          --replace-fail "-productversion" "-productVersion"
      '';

      dependencies = [pyobjc-core];

      env.NIX_CFLAGS_COMPILE = toString [
        "-I${darwin.libffi.dev}/include"
        "-Wno-error=unused-command-line-argument"
      ];

      pythonImportsCheck = ["Cocoa"];
    };

    # Not in nixpkgs
    pyobjc-framework-Quartz = buildPythonPackage {
      pname = "pyobjc-framework-Quartz";
      pyproject = true;

      inherit version src;

      sourceRoot = "source/pyobjc-framework-Quartz";

      build-system = [setuptools];

      buildInputs = [
        darwin.DarwinTools
        darwin.libffi
      ];

      nativeBuildInputs = [
        darwin.DarwinTools
      ];

      postPatch = ''
        substituteInPlace pyobjc_setup.py \
          --replace-fail "-buildversion" "-buildVersion" \
          --replace-fail "-productversion" "-productVersion"
      '';

      dependencies = [
        pyobjc-core
        pyobjc-framework-Cocoa
      ];

      env.NIX_CFLAGS_COMPILE = toString [
        "-I${darwin.libffi.dev}/include"
        "-Wno-error=cast-function-type-mismatch"
        "-Wno-error=unused-command-line-argument"
      ];

      pythonImportsCheck = ["Quartz"];
    };
  }
