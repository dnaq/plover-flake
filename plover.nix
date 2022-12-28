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
  sources
}:
let
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
in qt5.mkDerivationWith buildPythonPackage rec {
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
    #hid
    plover-stroke
    rtf-tokenize
  ];

  dontWrapQtApps = true;
  preFixup = ''
    makeWrapperArgs+=("''${qtWrapperArgs[@]}")
  '';

  doCheck = false;
}