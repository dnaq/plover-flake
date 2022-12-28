{ lib, plover, hid, bitstring, buildPythonPackage, fetchFromGitHub }:
{
  plover_machine_hid = buildPythonPackage rec {
    pname = "plover-machine-hid";
    version = "git";
    src = fetchFromGitHub {
      owner = "dnaq";
      repo = "plover-machine-hid";
      rev = "3112cabd180b512d6c85a5dda259e9be9996ce32";
      sha256 = "sha256-AS+sNsJuFi+KZPdNNhGE8zgjStfq1ZfBoNh+/xWUJKE=";
    };
    buildInputs = [ plover ];
    propagatedBuildInputs = [ hid bitstring ];
  };
  plover_auto_reconnect_machine = buildPythonPackage rec {
    pname = "plover_auto_reconnect_machine";
    version = "84f8d74894f993e7ccac923242f27fe14317c7c6";
    src = fetchFromGitHub {
      owner = "tschulte";
      repo = "plover_auto_reconnect_machine";
      rev = "84f8d74894f993e7ccac923242f27fe14317c7c6";
      sha256 = "sha256-osM/bVJeJmUxPqO9hhYy7fipu+Qg4Xq/qPe9l3JP5a8=";
    };
    buildInputs = [ plover ];
  };
}
