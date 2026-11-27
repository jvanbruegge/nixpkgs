{
  lib,
  vscode-utils,
  isabelle,
}:

vscode-utils.buildVscodeExtension (finalAttrs: {
  pname = "isabelle";
  version = "2.0.0";
  vscodeExtPublisher = "isabelle";
  vscodeExtName = "isabelle";
  vscodeExtUniqueId = "${finalAttrs.vscodeExtPublisher}.${finalAttrs.vscodeExtName}";

  src = "${isabelle}/share/${isabelle.dirname}/contrib/vscode_extension-20260929/isabelle-${finalAttrs.version}.vsix";

  postPatch = ''
        rm -rf node-v*

        cp "$(find "${isabelle}/share/${isabelle.dirname}/contrib"/vscodium-* -name symbols.json | head -n1)" symbols.json

        substituteInPlace package.json \
          --replace-fail '"vscode": "^1.135.0"' '"vscode": "^1.107.0"'

        substituteInPlace out/src/symbol.js \
          --replace-fail 'const File = require("./file");' \
          'const Path = require("path");
    const File = require("./file");' \
          --replace-fail '    else {
            return [];
        }' \
          '    else {
            return File.read_json_sync(Path.join(__dirname, "..", "..", "symbols.json"));
        }'

        substituteInPlace out/src/extension.js \
          --replace-fail 'const vscode_1 = require("vscode");' \
          'const fs = require("fs");
    const path = require("path");
    const vscode_1 = require("vscode");' \
          --replace-fail '            const isabelle_home = Library.getenv_strict("ISABELLE_HOME");
                const isabelle_tool = isabelle_home + "/bin/isabelle";' \
          '            const isabelle_home = Library.getenv("ISABELLE_HOME");
                let isabelle_tool = isabelle_home ? path.join(isabelle_home, "bin", "isabelle") : undefined;
                if (!isabelle_tool) {
                    for (const dir of (process.env["PATH"] || "").split(path.delimiter)) {
                        if (dir !== "") {
                            const candidate = path.join(dir, "isabelle");
                            try {
                                if (fs.statSync(candidate).isFile()) {
                                    fs.accessSync(candidate, fs.constants.X_OK);
                                    isabelle_tool = candidate;
                                    break;
                                }
                            } catch (_e) { }
                        }
                    }
                }
                if (!isabelle_tool) {
                    isabelle_tool = "${isabelle}/bin/isabelle";
                }'
  '';

  passthru.updateScript = null;

  meta = {
    description = "Visual Studio Code extension for the Isabelle theorem prover";
    homepage = "https://isabelle.in.tum.de/";
    license = lib.licenses.mit;
    sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
    maintainers = with lib.maintainers; [
      jvanbruegge
      sempiternal-aurora
    ];
    platforms = isabelle.meta.platforms;
  };
})
