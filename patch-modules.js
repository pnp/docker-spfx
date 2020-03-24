const fs = require("fs");

{
  process.stdout.write(
    "patching ./node_modules/@microsoft/sp-build-web/lib/SPWebBuildRig.js..."
  );
  const buildRigJs = fs
    .readFileSync("./node_modules/@microsoft/sp-build-web/lib/SPWebBuildRig.js")
    .toString();

  if (
    !/if \(!spBuildCoreTasks\.writeManifests\.taskConfig\.debugBasePath\) {\s*spBuildCoreTasks\.writeManifests\.mergeConfig\({.*\s*debugBasePath.*\s*}\);/m.test(
      buildRigJs
    )
  ) {
    const match = buildRigJs.match(
      /spBuildCoreTasks\.writeManifests\.mergeConfig\({.*\s*debugBasePath.*\s*}\);/m
    );

    const patchedBuildRigJs = buildRigJs.replace(
      match[0],
      `if (!spBuildCoreTasks.writeManifests.taskConfig.debugBasePath) {
    ${match[0]}
}`
    );

    fs.writeFileSync(
      "./node_modules/@microsoft/sp-build-web/lib/SPWebBuildRig.js",
      patchedBuildRigJs
    );

    console.log("\x1b[32m", "done", "\x1b[0m");
  } else {
    console.log("\x1b[33m", "no change", "\x1b[0m");
  }
}
{
  process.stdout.write("patching ./node_modules/gulp-connect/index.js...");

  const gulpConnectJs = fs
    .readFileSync("./node_modules/gulp-connect/index.js")
    .toString();

  if (
    !/return this\.server\.listen\(this\.port, \(function\(_this\) \{/g.test(
      gulpConnectJs
    )
  ) {
    const patchedGulpConnectJs = gulpConnectJs.replace(
      /return this\.server.listen\(this\.port, this\.host, \(function\(_this\) {/,
      "return this.server.listen(this.port, (function(_this) {"
    );

    fs.writeFileSync(
      "./node_modules/gulp-connect/index.js",
      patchedGulpConnectJs
    );

    console.log("\x1b[32m", "done", "\x1b[0m");
  } else {
    console.log("\x1b[33m", "no change", "\x1b[0m");
  }
}
{
  process.stdout.write(
    "patching ./node_modules/@microsoft/sp-build-core-tasks/lib/spfxServe/SpfxServeTask.js..."
  );

  const spfxServeTask = fs
    .readFileSync(
      "./node_modules/@microsoft/sp-build-core-tasks/lib/spfxServe/SpfxServeTask.js"
    )
    .toString();

  if (
    /\?debug=true&noredir=true&\${exports\.DEBUG_MANIFESTS_QUERY_PARAMETER}=\${this\._getManifestJsUrl\(\)\.href}/.test(
      spfxServeTask
    )
  ) {
    const patchedSpfxServeTask = spfxServeTask.replace(
      /\?debug=true&noredir=true&\${exports\.DEBUG_MANIFESTS_QUERY_PARAMETER}=\${this\._getManifestJsUrl\(\)\.href}/,
      '?debug=true&noredir=true&${exports.DEBUG_MANIFESTS_QUERY_PARAMETER}=${this._getManifestJsUrl().href.replace("0.0.0.0", "localhost")}'
    );

    fs.writeFileSync(
      "./node_modules/@microsoft/sp-build-core-tasks/lib/spfxServe/SpfxServeTask.js",
      patchedSpfxServeTask
    );

    console.log("\x1b[32m", "done", "\x1b[0m");
  } else {
    console.log("\x1b[33m", "no change", "\x1b[0m");
  }
}
