{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  crontab,
  rq,
  python-dateutil,
  freezegun
}:

buildPythonPackage rec {
  pname = "rq-scheduler";
  version = "0.14";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "rq";
    repo = "rq-scheduler";
    tag = "v${version}";
    hash = "sha256-1m/lcJ7ejUTnFRZWHE5OAMCIJOjh9jJwszJQtkVN0CU=";
  };

  build-system = [ hatchling ];

  dependencies = [
    crontab
    rq
    python-dateutil
    freezegun
  ];

  pythonImportsCheck = [ "rq_scheduler" ];

  meta = {
    description = "A lightweight library that adds job scheduling capabilities to RQ (Redis Queue)";
    homepage = "https://github.com/rq/rq-scheduler";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jvanbruegge ];
  };
}
