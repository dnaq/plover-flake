{
  appdirs,
  Babel,
  buildPythonPackage,
  certifi,
  path,
  pyqt5,
  pyserial,
  qt5,
  requests-futures,
  setuptools,
  wcwidth,
  xlib,
  evdev,
  sources,
}: let
  plover-stroke = buildPythonPackage rec {
    pname = "plover_stroke";
    version = "master";
    src = sources.plover-stroke;
  };
  rtf-tokenize = buildPythonPackage rec {
    pname = "rtf_tokenize";
    version = "master";
    src = sources.rtf-tokenize;
  };
in
  qt5.mkDerivationWith buildPythonPackage rec {
    pname = "plover";
    version = "master";
    src = sources.plover;
    #checkInputs = [ pytest pytest-qt mock ];
    propagatedBuildInputs = [
      Babel
      pyqt5
      xlib
      pyserial
      appdirs
      wcwidth
      setuptools
      certifi
      evdev
      #hid
      plover-stroke
      rtf-tokenize
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
