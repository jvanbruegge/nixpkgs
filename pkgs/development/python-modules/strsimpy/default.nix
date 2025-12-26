{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools
}:

buildPythonPackage rec {
  pname = "strsimpy";
  version = "0.2.1";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "luozhouyang";
    repo = "python-string-similarity";
    tag = "v${version}";
    hash = "sha256-MMueTVLdNYpr37H7e5vc9TrGO+2bDPleH8xoSTQTUdQ=";
  };

  build-system = [ setuptools ];

  pythonImportsCheck = [ "strsimpy" ];

  meta = {
    description = "A library implementing different string similarity and distance measures using Python";
    homepage = "https://github.com/luozhouyang/python-string-similarity";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jvanbruegge ];
  };
}
