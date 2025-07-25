{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  pytest-cov-stub,
  pythonOlder,
  pyyaml,
  setuptools,
}:

buildPythonPackage rec {
  pname = "mt-940";
  version = "4.30.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "wolph";
    repo = "mt940";
    tag = "v${version}";
    hash = "sha256-t6FOMu+KcEib+TZAv5uVAzvrUSt/k/RQn28jpdAY5Y0=";
  };

  nativeBuildInputs = [ setuptools ];

  nativeCheckInputs = [
    pyyaml
    pytestCheckHook
    pytest-cov-stub
  ];

  pythonImportsCheck = [ "mt940" ];

  meta = with lib; {
    description = "Module to parse MT940 files and returns smart Python collections for statistics and manipulation";
    homepage = "https://github.com/WoLpH/mt940";
    changelog = "https://github.com/wolph/mt940/releases/tag/v${version}";
    license = licenses.bsd3;
    maintainers = [ ];
  };
}
