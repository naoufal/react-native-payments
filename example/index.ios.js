
import React, { Component } from 'react';
import { AppRegistry } from 'react-native';

global.PaymentRequest = require('react-native-payments').PaymentRequest;
const App = require('./js/App').default;

AppRegistry.registerComponent('example', () => App);