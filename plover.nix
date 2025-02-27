{
  lib,
  stdenv,
  callPackage,
  appdirs,
  Babel,
  buildPythonPackage,
  buildPythonApplication,
  certifi,
  pyqt6,
  pyside6,
  pyserial,
  qt5,
  requests-futures,
  setuptools,
  setuptools-scm,
  wcwidth,
  xlib,
  evdev,
  appnope,
  pkginfo,
  pygments,
  readme-renderer,
  cmarkgfm,
  requests-cache,
  poetry-core,
  sources,
}: let
  plover-stroke = buildPythonPackage {
    pname = "plover_stroke";
    version = "master";
    src = sources.plover-stroke;
  };
  rtf-tokenize = buildPythonPackage {
    pname = "rtf_tokenize";
    version = "master";
    src = sources.rtf-tokenize;
  };
  pyqt6rc = buildPythonApplication {
    pname = "pyqt6rc";
    version = "master";
    src = sources.pyqt6rc;
    pyproject = true;

    build-system = [ poetry-core ];

    dependencies = [
      (buildPythonPackage {
        pname = "importlib-resources";
        version = "v5.13.0";
        src = sources.importlib-resources;
        pyproject = true;

        build-system = [
          setuptools
          setuptools-scm
        ];
      })
      pyqt6
      pyside6
    ];

    pythonImportsCheck = [
      "pyqt6rc"
    ];
  };
  darwinPackages = callPackage ./darwin.nix { };
in
  qt5.mkDerivationWith buildPythonPackage {
    pname = "plover";
    version = "master";
    src = sources.plover;
    #checkInputs = [ pytest pytest-qt mock ];
    propagatedBuildInputs = [
      Babel
      pyqt6
      xlib
      pyserial
      appdirs
      wcwidth
      setuptools
      certifi
      pkginfo
      pygments
      readme-renderer
      cmarkgfm
      requests-cache
      requests-futures
      pyqt6rc
      #hid
      plover-stroke
      rtf-tokenize
    ] ++ lib.optionals (!stdenv.hostPlatform.isDarwin) [
      evdev
    ] ++ lib.optionals (stdenv.hostPlatform.isDarwin) [
      appnope
      darwinPackages.pyobjc-core
      darwinPackages.pyobjc-framework-Cocoa
      darwinPackages.pyobjc-framework-Quartz
    ];

    postInstall = ''
      mkdir -p $out/share/icons/hicolor/128x128/apps
      cp $src/plover/assets/plover.png $out/share/icons/hicolor/128x128/apps/plover.png

      mkdir -p $out/share/applications
      cp $src/linux/plover.desktop $out/share/applications/plover.desktop
      substituteInPlace "$out/share/applications/plover.desktop" \
        --replace-warn "Exec=plover" "Exec=$out/bin/plover"
    '';

    dontWrapQtApps = true;
    preFixup = ''
      makeWrapperArgs+=("''${qtWrapperArgs[@]}")
    '';

    doCheck = false;
  }
