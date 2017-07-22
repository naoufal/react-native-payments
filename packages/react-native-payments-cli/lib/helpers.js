function filterOutCommentKeys(key) {
  return !key.endsWith('_comment');
}

function addFrameworks(project, frameworkDirPath, frameworkFileNames = []) {
  // Add frameworks pbx
  project.addPbxGroup(
    [],
    'Frameworks',
    frameworkDirPath
  );

  frameworkFileNames.forEach(frameworkFileName => {
    project.addFramework(`${frameworkDirPath}/${frameworkFileName}`)
  });
}

function addCarthageRunScriptPhase(project, inputPaths, outputPaths) {
  project.addBuildPhase(
    [],
    'PBXShellScriptBuildPhase',
    'Copy Carthage Frameworks (Generated by react-native-payments-cli)',
    undefined,
    {
      shellPath: '/bin/sh',
      shellScript: '/usr/local/bin/carthage copy-frameworks',
      inputPaths,
      outputPaths
    }
  );
}

function addFrameworkSearchPaths(project, filePaths) {
  const config = project.pbxXCBuildConfigurationSection();

  Object.keys(config)
    .filter(filterOutCommentKeys)
    .forEach(key => {
      const buildSettings = config[key].buildSettings;
      const hasFrameworkSearchPaths = buildSettings.hasOwnProperty('FRAMEWORK_SEARCH_PATHS');

      // If there's only one path, the frameworkSearchPaths is a string, so we
      // normalize it here.
      const frameworkSearchPaths = buildSettings.FRAMEWORK_SEARCH_PATHS || [];
      const normalizedFrameworkSearchPaths = Array.isArray(frameworkSearchPaths)
        ? frameworkSearchPaths
        : [frameworkSearchPaths];

      const pathsToAdd = filePaths
        .filter(filePath => !normalizedFrameworkSearchPaths.includes(filePath));

      const nextFrameworkSearchPaths = [...normalizedFrameworkSearchPaths, ...pathsToAdd];

      buildSettings.FRAMEWORK_SEARCH_PATHS = nextFrameworkSearchPaths.length > 1
        ? nextFrameworkSearchPaths
        : nextFrameworkSearchPaths.join('');
    });
}

module.exports = {
  addFrameworks,
  addFrameworkSearchPaths,
  addCarthageRunScriptPhase
};