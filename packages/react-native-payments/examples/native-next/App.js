/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 * @flow
 */

import React, { Component } from 'react';
import { View } from 'react-native';
import { ApplePayButton, PaymentRequest } from 'react-native-payments';

type Props = {};

export default class App extends Component<Props> {
  showPaymentSheet = () => {
    const paymentRequest = new PaymentRequest(METHOD_DATA, DETAILS);
    paymentRequest.show();
  };
  render() {
    return (
      <View style={{ margin: 50 }}>
        <View style={{ height: 44 }}>
          <ApplePayButton
            type="plain"
            style="black"
            onPress={this.showPaymentSheet}
          />
        </View>
      </View>
    );
  }
}

const METHOD_DATA = [
  {
    supportedMethods: ['apple-pay'],
    data: {
      merchantIdentifier: 'merchant.com.your-app.namespace',
      supportedNetworks: ['visa', 'mastercard', 'amex'],
      countryCode: 'US',
      currencyCode: 'USD',
    },
  },
];

const DETAILS = {
  id: 'basic-example',
  displayItems: [
    {
      label: 'Movie Ticket',
      amount: { currency: 'USD', value: '15.00' },
    },
  ],
  total: {
    label: 'Merchant Name',
    amount: { currency: 'USD', value: '15.00' },
  },
};
