{ sources, lib, plover, hid, bitstring, dulwich, odfpy, pyparsing, buildPythonPackage, fetchPypi }:
let
  spylls = buildPythonPackage rec {
    pname = "spylls";
    version = "0.1.7";
    src = fetchPypi {
      inherit pname version;
      sha256 = "sha256-cEWJLcvTJNNoX2nFp2AGPnj7g5kTckzhgHfPCgyT8iA=";
    };
    doCheck = false;
  };
in {
  plover_machine_hid = buildPythonPackage rec {
    pname = "plover-machine-hid";
    version = "master";
    src = sources.plover-machine-hid;
    buildInputs = [ plover ];
    propagatedBuildInputs = [ hid bitstring ];
  };
  plover_auto_reconnect_machine = buildPythonPackage rec {
    pname = "plover_auto_reconnect_machine";
    version = "master";
    src = sources.plover_auto_reconnect_machine;
    buildInputs = [ plover ];
  };
  plover2cat = buildPythonPackage rec {
    pname = "plover2cat";
    version = "master";
    src = sources.plover2cat;
    buildInputs = [ plover ];
    propagatedBuildInputs = [ dulwich odfpy pyparsing spylls ];
    doCheck = false;
  };
}
