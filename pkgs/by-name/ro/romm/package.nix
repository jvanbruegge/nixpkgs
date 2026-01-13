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
  version = "4.5.0";

  src = fetchFromGitHub {
    owner = "rommapp";
    repo = "romm";
    tag = version;
    hash = "sha256-fh1RyCbkZRtrkfqiTAwTJL9mvQOBFu9z79NL6mvKwRQ=";
  };

  RAHasher = stdenv.mkDerivation rec {
    name = "RAHasher";
    version = "1.8.1";

    src = fetchFromGitHub {
      owner = "RetroAchievements";
      repo = "RALibretro";
      tag = version;
      hash = "sha256-jcn8WhNCjr6gqjbkTlPUJVR7q5TOItAkpof2dX5kX4E=";
      fetchSubmodules = true;
    };

    buildPhase = ''
      runHook preBuild

      pushd src/libchdr/deps/zlib-*
      chmod +x ./configure
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

  /*emulatorjs = stdenvNoCC.mkDerivation rec {
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
  };*/

  frontend = buildNpmPackage {
    pname = "romm-frontend";
    inherit version;
    src = src + "/frontend";

    npmDepsHash = "sha256-ytbH58i1D63Z73tG4WLSDsLjscjSRjWg0yqOrtXhluo=";

    installPhase = ''
      cp -r dist $out/
      pushd assets
      cp -r dashboard-icons default platforms scrappers webrcade/feed $out/assets/
      #ln -s ''${emulatorjs} $out/assets/emulatorjs
    '';
  };


  python = python312.override {
    self = python;
    packageOverrides = final: prev: {
      rq-scheduler = prev.rq-scheduler.overridePythonAttrs (_: {
        src = fetchFromGitHub {
          owner = "adamantike";
          repo = "rq-scheduler";
          rev = "39583cb2a00c6faa12ef34c7277893064a83c4de";
          hash = "sha256-VOgMuzSDwCIWOlWc2+dxZHXqO3IigTi0F7ZRAzbgzLE=";
        };
      });
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
    pyyaml
    sqlalchemy
    unidecode
    aiohttp
    alembic
    anyio
    authlib
    colorama
    defusedxml
    fastapi-pagination
    fastapi
    gunicorn
    httpx
    itsdangerous
    joserfc
    opentelemetry-distro
    opentelemetry-exporter-otlp
    opentelemetry-instrumentation-aiohttp-client
    opentelemetry-instrumentation-fastapi
    opentelemetry-instrumentation-httpx
    opentelemetry-instrumentation-redis
    opentelemetry-instrumentation-sqlalchemy
    passlib
    pillow
    psycopg
    pydash
    python-dotenv
    python-magic
    python-socketio
    redis
    rq
    rq-scheduler
    sentry-sdk
    starlette
    streaming-form-data
    strsimpy
    types-colorama
    types-passlib
    types-pyyaml
    types-redis
    user-agents
    uvicorn
    uvicorn-worker
    watchfiles
    yarl
    zipfile-inflate64
  ]
  ++ psycopg.optional-dependencies.c
  ++ sqlalchemy.optional-dependencies.mariadb_connector
  ++ sqlalchemy.optional-dependencies.mysql_connector
  ++ sqlalchemy.optional-dependencies.postgresql_psycopg
  ++ fastapi-pagination.optional-dependencies.sqlalchemy
  ++ fastapi.optional-dependencies.standard
  ++ passlib.optional-dependencies.bcrypt;
}
