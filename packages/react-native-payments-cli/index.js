#!/usr/bin/env node
'use strict';

const path = require('path');
const { setupAddon } = require('./lib/commands');

const addOnConfig = require('react-native-payments-addon-braintree/package.json');

const PROJECT_PATH = path.resolve(__dirname, 'ios/RNPCLIProject.xcodeproj/project.pbxproj');
const RNP_PATH = path.resolve(__dirname, 'node_modules/react-native-payments/lib/ios/ReactNativePayments.xcodeproj/project.pbxproj');

function main() {
  setupAddon(PROJECT_PATH, RNP_PATH, addOnConfig);
}

main();