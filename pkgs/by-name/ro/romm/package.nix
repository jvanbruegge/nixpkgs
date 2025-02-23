{
  lib,
  stdenv,
  stdenvNoCC,
  fetchFromGitHub,
  buildNpmPackage,
  python312,
  makeWrapper,
  curl,
  cacert,
  p7zip,
}:

let
  version = "3.7.3";

  src = fetchFromGitHub {
    owner = "rommapp";
    repo = "romm";
    tag = version;
    hash = "sha256-xEsg7cr6ty0nZk+0yixjLM6H40+j9oulfYjrGxGBA0A=";
  };

  RAHasher = stdenv.mkDerivation rec {
    name = "RAHasher";
    version = "1.8.0";

    src = fetchFromGitHub {
      owner = "RetroAchievements";
      repo = "RALibretro";
      tag = version;
      hash = "sha256-Ah/q+3r7YqlXXYpdf/ukkw4GC7riNERG6jPfxvYQhbo=";
      fetchSubmodules = true;
    };

    buildPhase = ''
      runHook preBuild

      pushd src/libchdr/deps/zlib-1.2.12
      ./configure
      popd

      make HAVE_CHD=1 -f ./Makefile.RAHasher

      runHook postBuild
    '';

    installPhase = ''
      mkdir -p $out/bin
      cp bin64/RAHasher $out/bin/
    '';
  };

  emulatorjs = stdenvNoCC.mkDerivation rec {
    pname = "emulatorjs";
    version = "4.2.1";

    outputHash = "sha256-ZYdP11abWp+cPo7/42edKkL3vmOZQSAwJxTRQDsdWXU=";
    outputHashMode = "recursive";

    dontUnpack = true;

    nativeBuildInputs = [ curl p7zip cacert ];

    buildPhase = ''
      curl -o emulatorjs.7z -L "https://github.com/EmulatorJS/EmulatorJS/releases/download/v${version}/${version}.7z";
      ${lib.getExe p7zip} e -oemulatorjs emulatorjs.7z
    '';

    installPhase = ''
      cp -r emulatorjs $out
    '';
  };

  frontend = buildNpmPackage {
    pname = "romm-frontend";
    inherit version;
    src = src + "/frontend";

    npmDepsHash = "sha256-bFT9lDeIyMzICXGE7TY+vDVp450xVNF5/bPUEVsBMws=";

    installPhase = ''
      cp -r dist $out/
      pushd assets
      cp -r dashboard-icons default platforms scrappers webrcade/feed $out/assets/
      ln -s ${emulatorjs} $out/assets/emulatorjs
    '';
  };


  python = python312.override {
    self = python;
    packageOverrides = final: prev: {
      py7zr = prev.buildPythonPackage {
        pname = "py7zr";
        version = "1.0.0-rc2";
        pyproject = true;

        src = fetchFromGitHub {
          owner = "miurahr";
          repo = "py7zr";
          tag = "v1.0.0rc2";
          hash = "sha256-1zTXR9DNIyMrSG1ZD/mBu5xym0Cm6cULzBDMEcnjehE=";
        };

        nativeCheckInputs = with final; [
          pytestCheckHook
          pytest-httpserver
          pytest-benchmark
          pytest-cov
          pytest-remotedata
          pytest-timeout
          py-cpuinfo
          coverage
          coveralls
        ];
        build-system = with final; [ setuptools setuptools-scm build ];

        dependencies = with final; [
          texttable
          pycryptodomex
          brotli
          psutil
          pyzstd
          pyppmd
          pybcj
          multivolumefile
          inflate64
        ];
      };
    };
  };
in
stdenvNoCC.mkDerivation rec {
  pname = "romm";
  inherit version src;
  pyproject = true;

  nativeBuildInputs = [
    makeWrapper
  ];

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp -r backend $out/

    runHook postInstall
  '';

  postInstall = ''
    makeWrapper ${lib.getExe python.pkgs.gunicorn} "''${!outputBin}"/bin/romm \
      --prefix PYTHONPATH : "$out/backend:${python.pkgs.makePythonPath dependencies}" \
      --prefix PATH : "${lib.makeBinPath [ RAHasher ]}" \
      --set-default ROMM_HOST "127.0.0.1" \
      --set-default ROMM_PORT 5000 \
      --add-flags "--access-logfile - --error-logfile - --worker-class uvicorn.workers.UvicornWorker --bind=\$ROMM_HOST:\$ROMM_PORT --bind=unix:/tmp/gunicorn.sock main:app"

    makeWrapper ${python.interpreter} "''${!outputBin}"/bin/romm-worker \
      --prefix PYTHONPATH : "$out/backend:${python.pkgs.makePythonPath dependencies}" \
      --add-flags $out/backend/worker.py

    makeWrapper ${python.interpreter} "''${!outputBin}"/bin/romm-scheduler \
      --prefix PYTHONPATH : "$out/backend:${python.pkgs.makePythonPath dependencies}" \
      --add-flags $out/backend/scheduler.py
  '';

  passthru = {
    inherit frontend;
  };

  dependencies = with python.pkgs; [
    anyio
    fastapi
    uvicorn
    gunicorn
    websockets
    python-socketio
    psycopg
    sqlalchemy
    alembic
    pyyaml
    unidecode
    emoji
    python-dotenv
    sqlakeyset
    pydash
    rq
    redis
    passlib
    itsdangerous
    rq-scheduler
    starlette-csrf
    httpx
    python-multipart
    watchdog
    yarl
    joserfc
    pillow
    certifi
    authlib
    python-magic
    py7zr
    sentry-sdk
    streaming-form-data
    zipfile-deflate64
    colorama
    types-colorama
    types-passlib
    types-pyyaml
    types-redis
  ]
  ++ psycopg.optional-dependencies.c
  ++ sqlalchemy.optional-dependencies.mariadb_connector
  ++ sqlalchemy.optional-dependencies.mysql_connector
  ++ sqlalchemy.optional-dependencies.postgresql_psycopg
  ++ passlib.optional-dependencies.bcrypt;
}
