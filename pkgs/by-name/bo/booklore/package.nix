{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  buildNpmPackage,
  yq,
  gradle,
  makeWrapper,
  jre,
}:
let
  version = "0.30.2";

  src = fetchFromGitHub {
    owner = "adityachandelgit";
    repo = "BookLore";
    rev = "v${version}";
    hash = "sha256-b2Zq7fBxxJF2WLDIPJQA+7GO9r96r/wf5zaopO9wJAw=";
  };

  webui = buildNpmPackage {
    pname = "booklore-ui";
    inherit version;

    src = src + "/booklore-ui";

    npmFlags = [ "--legacy-peer-deps" ];
    npmDepsHash = "sha256-uQPDyrlaqLQTV/FcqCXRg/KD5mBWoiWciGR5ny5bAVI=";

    installPhase = ''
      runHook preInstall

      cp -r dist $out

      runHook postInstall
    '';
  };

  booklore = stdenvNoCC.mkDerivation (final: {
    pname = "booklore";
    inherit version;

    src = src + "/booklore-api";

    nativeBuildInputs = [
      yq
      gradle
      makeWrapper
    ];

    prePatch = ''
      sed -i "s/version: 'v.*'/version: 'v${version}'/" src/main/resources/application.yaml
    '';

    mitmCache = gradle.fetchDeps {
      inherit (final) pname;
      pkg = booklore;
      data = ./deps.json;
    };

    gradleBuildTask = "build";

    installPhase = ''
      runHook preInstall

      mkdir -p $out/bin $out/share/booklore-api
      cp build/libs/booklore-api-*-SNAPSHOT.jar $out/share/booklore-api/booklore-api.jar
      ln -s ${webui} $out/share/booklore-ui

      makeWrapper ${lib.getExe' jre "java"} $out/bin/booklore \
        --add-flags "-jar $out/share/booklore-api/booklore-api.jar"

      runHook postInstall
    '';

    meta = {
      description = "BookLore is a web app for hosting, managing, and exploring books, with support for PDFs, eBooks, reading progress, metadata, and stats";
      mainProgram = "booklore";
      homepage = "https://github.com/adityachandelgit/BookLore";
      license = lib.licenses.gpl3Only;
      maintainers = with lib.maintainers; [ jvanbruegge ];
      platforms = lib.platforms.linux;
    };
  });
in
booklore
