import React, { Component } from 'react';
import { AppRegistry, StyleSheet, Text, View } from 'react-native';
global.PaymentRequest = require('react-native-payments').PaymentRequest;
const App = require('../common/App').default;

AppRegistry.registerComponent('ReactNativePaymentsExample', () => App);
