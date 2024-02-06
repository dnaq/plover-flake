{
  sources,
  lib,
  plover,
  hid,
  bitarray,
  dulwich,
  odfpy,
  pyparsing,
  tomli,
  websocket-client,
  hatchling,
  buildPythonPackage,
  fetchPypi,
}: let
  spylls = buildPythonPackage rec {
    pname = "spylls";
    version = "0.1.7";
    src = fetchPypi {
      inherit pname version;
      sha256 = "sha256-cEWJLcvTJNNoX2nFp2AGPnj7g5kTckzhgHfPCgyT8iA=";
    };
    doCheck = false;
  };
  obsws-python = buildPythonPackage rec {
    format = "pyproject";
    pname = "obsws_python";
    version = "1.6.1";
    src = fetchPypi {
      inherit pname version;
      sha256 = "sha256-n1l4M3xVfp+8pnO1rF3Ww7Vwyi6GCD3/QHLbrZOXp7w=";
    };
    buildInputs = [hatchling];
    propagatedBuildInputs = [tomli websocket-client];
  };
in {
  plover_machine_hid = buildPythonPackage rec {
    pname = "plover-machine-hid";
    version = "master";
    src = sources.plover-machine-hid;
    buildInputs = [plover];
    propagatedBuildInputs = [hid bitarray];
  };
  plover_auto_reconnect_machine = buildPythonPackage rec {
    pname = "plover_auto_reconnect_machine";
    version = "master";
    src = sources.plover_auto_reconnect_machine;
    buildInputs = [plover];
  };
  plover2cat = buildPythonPackage rec {
    pname = "plover2cat";
    version = "master";
    src = sources.plover2cat;
    buildInputs = [plover];
    propagatedBuildInputs = [dulwich odfpy pyparsing spylls obsws-python];
    doCheck = false;
  };
}
