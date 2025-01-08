{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  pytestCheckHook,
  hatch-regex-commit,
  itsdangerous,
  starlette,
  asgi-lifespan,
  httpx,
  ruff,
  pytest-asyncio,
  mypy,
  pytest-cov
}:

let
  httpx_27 = httpx.overrideAttrs (_: rec {
    version = "0.27.2";
    src = fetchFromGitHub {
      owner = "encode";
      repo = "httpx";
      tag = version;
      hash = "sha256-N0ztVA/KMui9kKIovmOfNTwwrdvSimmNkSvvC+3gpck=";
    };
  });
in buildPythonPackage rec {
  pname = "starlette-csrf";
  version = "3.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "frankie567";
    repo = "starlette-csrf";
    tag = "v${version}";
    hash = "sha256-oouTMy59/khU3GVhH1yTtdrsOC6Tg4gTua23DSOQQu0=";
  };

  build-system = [
    hatchling
    hatch-regex-commit
  ];

  dependencies = [
    itsdangerous
    starlette
  ];

  nativeCheckInputs = [
    pytestCheckHook
    asgi-lifespan
    httpx_27
    ruff
    pytest-asyncio
    mypy
    pytest-cov
  ];

  pythonImportsCheck = [ "starlette_csrf" ];

  meta = {
    description = "Starlette middleware implementing Double Submit Cookie technique to mitigate CSRF ";
    homepage = "https://github.com/frankie567/starlette-csrf";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jvanbruegge ];
  };
}
