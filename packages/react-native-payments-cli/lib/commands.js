const Promise = require('bluebird');
const fs = require('fs');
const path = require('path');
const xcode = require('xcode');
const pbxFile = require('xcode/lib/pbxFile');

const { addFrameworkSearchPaths, addFrameworks, addCarthageRunScriptPhase } = require('./helpers');

function setupAddon(projectPath, rnpPath, addOnConfig) {
  const addOnName = addOnConfig.name;
  const addOnFrameworks = addOnConfig.reactNativePaymentsAddonConfig.frameworks;

  Promise.all([
    addToProject(projectPath, addOnName, addOnFrameworks),
    addToRNP(rnpPath, addOnName)
  ])
  .catch(e => {
    throw new Error('Error setting up Stripe', e);
  })
}

function addToProject(projectPath, addOnName, addOnFrameworks) {
  const project = xcode.project(projectPath);
  project.parseAsync = Promise.promisify(project.parse);

  return project.parseAsync(() => {
    // Add Framework Search Paths
    addFrameworkSearchPaths(
      project,
      [`"$(SRCROOT)/../node_modules/${addOnName}/Carthage/Build/iOS/"`]
    );

    // Add and link Framework
    const frameworksWithExtension = addOnFrameworks.map(name => `${name}.framework`);
    addFrameworks(
      project,
      path.resolve(__dirname, `../../${addOnName}/Carthage/Build/iOS`),
      frameworksWithExtension
    );

    // Add Run Script Phase
    const inputPaths = frameworksWithExtension.map(
      frameworkFile => `"$(SRCROOT)/../node_modules/${addOnName}/Carthage/Build/iOS/${frameworkFile}"`
    );
    const outputPaths = frameworksWithExtension.map(
      frameworkFile => `"$(BUILT_PRODUCTS_DIR)/$(FRAMEWORKS_FOLDER_PATH)/${frameworkFile}"`
    );
    addCarthageRunScriptPhase(
      project,
      inputPaths,
      outputPaths
    );

    fs.writeFileSync(
      projectPath,
      project.writeSync()
    );
  });
}

function addToRNP(projectPath, addOnName) {
  const project = xcode.project(projectPath);
  project.parseAsync = Promise.promisify(project.parse);

  return project.parseAsync(() => {
    // Add Framework Search Paths
    addFrameworkSearchPaths(
      project,
      [`"$(SRCROOT)/../../../${addOnName}/Carthage/Build/iOS/"`]
    );

    fs.writeFileSync(
      projectPath,
      project.writeSync()
    );
  });
}

module.exports = { setupAddon };
