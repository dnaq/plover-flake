{
  appdirs,
  Babel,
  buildPythonPackage,
  certifi,
  pyside6,
  pyserial,
  qt6,
  requests-futures,
  setuptools,
  wcwidth,
  xlib,
  evdev,
  pkginfo,
  pygments,
  readme-renderer,
  cmarkgfm,
  requests-cache,
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
in
  buildPythonPackage {
    pname = "plover";
    version = "master";
    src = sources.plover;

    nativeBuildInputs = [
      qt6.qtbase
      qt6.wrapQtAppsHook
    ];

    #checkInputs = [ pytest pytest-qt mock ];
    propagatedBuildInputs = [
      Babel
      pyside6
      xlib
      pyserial
      appdirs
      wcwidth
      setuptools
      certifi
      evdev
      pkginfo
      pygments
      readme-renderer
      cmarkgfm
      requests-cache
      requests-futures
      #hid
      plover-stroke
      rtf-tokenize
    ];

    preConfigure = ''
      export PATH=${qt6.qtbase}/libexec:$PATH
      substituteInPlace "plover_build_utils/setup.py" \
        --replace-fail "'pyside6-rcc'" "'${qt6.qtbase}/libexec/rcc', '-g', 'python'" \
        --replace-fail "'pyside6-uic'" "'${qt6.qtbase}/libexec/uic', '-g', 'python'"
    '';

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
