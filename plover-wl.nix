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
  pywayland,
  wayland,
  pkg-config,
  sources,
  wayland-scanner,
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
    src = sources.plover-wl;
    #checkInputs = [ pytest pytest-qt mock ];
    nativeBuildInputs = [
      pkg-config
    ];
    buildInputs = [
      wayland-scanner
    ];
    propagatedBuildInputs = [
      Babel
      pyqt5
      xlib
      pyserial
      appdirs
      wcwidth
      setuptools
      certifi
      #hid
      plover-stroke
      rtf-tokenize
      pywayland
    ];

    dontWrapQtApps = true;
    preFixup = ''
      makeWrapperArgs+=("''${qtWrapperArgs[@]}")
    '';
    postPatch = ''
      substituteInPlace plover_build_utils/setup.py --replace "/usr/share/wayland/wayland.xml" "${wayland}/share/wayland/wayland.xml"
    '';

    doCheck = false;
  }
