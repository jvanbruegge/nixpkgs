{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  fastapi,
  pydantic,
  typing-extensions,
  sqlmodel,
  sqlalchemy,
  sqlakeyset,
  databases,
}:

buildPythonPackage rec {
  pname = "fastapi-pagination";
  version = "0.15.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "uriyyo";
    repo = "fastapi-pagination";
    tag = version;
    hash = "sha256-FR2iyEHDkMPJUk81IV3601lAmDSPoDpvNrU9/LaJ3KU=";
  };

  build-system = [ hatchling ];

  dependencies = [
    fastapi
    pydantic
    typing-extensions
  ];

  optional-dependencies = {
    sqlmodel = [
      sqlmodel
      sqlakeyset
    ];
    sqlalchemy = [
      sqlalchemy
      sqlakeyset
    ];
    databases = [ databases ];
  };

  pythonImportsCheck = [ "fastapi_pagination" ];

  meta = {
    description = "FastAPI pagination";
    homepage = "https://github.com/uriyyo/fastapi-pagination";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jvanbruegge ];
  };
}
