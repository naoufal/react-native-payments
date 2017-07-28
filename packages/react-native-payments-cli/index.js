#!/usr/bin/env node
'use strict';

const path = require('path');
const fs = require('fs');
const meow = require('meow');
const chalk = require('chalk');
const inquirer = require('inquirer');
const Table = require('cli-table');
const { log } = console;

const { setupAddon } = require('./lib/commands');

const cli = meow(`
    Usage: react-native-payments [command] <options>

    Commands:

      link <addon>     links an add-ons native dependencies to your project
      list             lists all available add-ons
    \n
`);

function convertAddOnToPackageName(addon = '') {
  const RNP_ADDON_PREFIX = 'react-native-payments-addon';

  return addon.startsWith(RNP_ADDON_PREFIX)
    ? addon
    : `${RNP_ADDON_PREFIX}-${addon}`;
}

function getRNPProjectPath() {
  return path.resolve(__dirname, '../react-native-payments/lib/ios/ReactNativePayments.xcodeproj/project.pbxproj');
}

function getUserProjectPath(relativeIOSPath) {
  const iosPath = path.resolve(__dirname, `../../${relativeIOSPath}`)
  let userProjectPath;
  if (fs.existsSync(iosPath)) {
    const projectFileName = fs.readdirSync(`${iosPath}`).find(
      fileName => fileName.endsWith('.xcodeproj')
    );

    userProjectPath = `${iosPath}/${projectFileName}`;
  }

  return userProjectPath;
}

function removeLeadingSlash(input = '') {
  return input.startsWith('/')
    ? input.slice(1)
    : input;
}

function buildQuestions(maybeUserProject) {
  let questions = [{
    name: 'userProjectPath',
    type: 'input',
    message: 'What is the relative path to your ios directory?',
    when: ({ isUserPath }) => !isUserPath,
    validate: (input) => {
      return getUserProjectPath(removeLeadingSlash(input)) ? true : false;
    }
  }];

  if (maybeUserProject) {
    questions.unshift({
      name: 'isUserPath',
      type: 'confirm',
      message: `Is this the path to your Xcode project "${maybeUserProject}"?`
    });
  }

  return questions;
}

function interactiveGetUserProjectPath(maybeUserProject) {
  // /project.pbxproj
  return inquirer.prompt(buildQuestions(maybeUserProject))
  .then(({ isUserPath, userProjectPath }) => {
    return isUserPath
      ? `${maybeUserProject}/project.pbxproj`
      : `${getUserProjectPath(removeLeadingSlash(userProjectPath))}/project.pbxproj`;
  })
  .catch(e => {
    console.log(e.stack);
  });
}

function getPackagePath(packageName) {
  return path.resolve(__dirname, `../${packageName}/package.json`);
}
function getPackageConfig(packageName) {
  const config = require(getPackagePath(packageName));

  return config;
}

function isValidAddon(addon) {
  if (!addon) {
    log(chalk.yellow(`
      You need to pass an <addon> option with this command.

      For example, "react-native-payments link stripe".
    `));

    return false;
  }

  if (addon === true) {
    log(chalk.yellow(`
      You need to pass a valid <addon> option with this command.

      To see the full list of addons, go to https://goo.gl/ZC7jgf.
    `));

    return false;
  }

  return true;
}

function isPackageInstalled(packageName) {
  const packageExists = fs.existsSync(getPackagePath(packageName));

  if (!packageExists) {
    log(chalk.yellow(`
      "${packageName}" is not installed. Install it with "npm" or "yarn" and try again.

      To see the full list of addons, go to https://goo.gl/ZC7jgf.
    `));

    return false;
  }

  return true;
}

function link(addon) {
  // Check if `addon` flag exists
  if (!isValidAddon(addon)) {
    return;
  }

  // Check if `react-native-payments` is installed
  if (!isPackageInstalled('react-native-payments')) {
    return;
  };

  // Check if `addon` is installed
  const packageName = convertAddOnToPackageName(addon);
  if (!isPackageInstalled(packageName)) {
    return;
  }

  const packageConfig = getPackageConfig(packageName);

  const rnpProjectPath = getRNPProjectPath();
  return (interactiveGetUserProjectPath(getUserProjectPath('ios')))
  .then(userProjectPath => {
    setupAddon(
      userProjectPath,
      rnpProjectPath,
      packageConfig
    );
  })
  .then(() => {
    log(chalk.green(`
      ✅  Successfully linked "${addon}".
    `));
  })
  .catch(() => {
    log(chalk.red(`
      ⛔️  Something went wrong, could not link "${addon}".
    `));
  });
}

function unlink(addon) {
  if (!isValidAddon(addon)) {
    return;
  }
}

function list() {
  const availableAddons = fs.readdirSync(path.resolve(__dirname, '..'))
    .filter(packageName => packageName.startsWith('react-native-payments-addon'));

  if (availableAddons.length === 0) {
    log(chalk.yellow(`
      No addons are available for linking.

      You can install addons with "npm" or "yarn".  To see the full list of addons, go to https://goo.gl/ZC7jgf.
    `));
    return;
  }

  const addonsTable = new Table({
    head: ['name', 'package'],
    style: { head: [] }
  });

  availableAddons.forEach(name => {
    addonsTable.push([name.replace('react-native-payments-addon-', ''), name]);
  });

  log('\n' + addonsTable.toString());
  return;
}

function main(input, addon){
  switch (input) {
    case 'link':
      return link(addon);
    // case 'unlink':
    //   return unlink(addon);
    case 'list':
      return list();
    default:
      return;
  }
}

main(cli.input[0], cli.input[1]);
