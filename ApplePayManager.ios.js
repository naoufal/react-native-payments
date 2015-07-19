/**
 * @providesModule ApplePayManager
 * @flow
 */
'use strict';

var React = require('react-native');
var {
  NativeModules
} = React;

var NativeApplePayManager = NativeModules.ApplePayManager;

/**
 * High-level docs for the ApplePayManager iOS API can be written here.
 */

var ApplePayManager = {
  canMakePayments: NativeApplePayManager.canMakePayments,

  canMakePaymentsUsingNetworks: NativeApplePayManager.canMakePaymentsUsingNetworks,

  paymentRequest: function(opts, items) {
    var summaryItems = JSON.parse(JSON.stringify(items));
    var options = opts || {};
    options.DEV = __DEV__;

    // Setup total item
    var totalItem = {
      label: opts.merchantName,
      amount: getTotal(items).toString()
    };

    // Add total item to items
    summaryItems.push(totalItem);

    // Set amounts as strings
    summaryItems.forEach(function(i) {
      i.amount = i.amount.toString();
    });

    return new Promise(function(resolve, reject) {
      NativeApplePayManager.paymentRequest(options, summaryItems, function(error, token) {
        if (error) {
          return reject(error);
        }

        resolve(token);
      });
    });
  },

  success: function() {
    return new Promise(function(resolve, reject) {
      NativeApplePayManager.success(function(error) {
        if (error) {
          return reject(error);
        }

        resolve(true);
      });
    });
  },

  failure: function() {
    return new Promise(function(resolve, reject) {
      NativeApplePayManager.failure(function(error) {
        if (error) {
          return reject(error);
        }

        resolve(true);
      });
    });
  },

  getTotal: getTotal
};

function getTotal(items) {
  var total = 0;

  items.forEach(function(i) {
    total+= i.amount;
  });

  return total;
}

module.exports = ApplePayManager;
