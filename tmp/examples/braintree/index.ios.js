import React, { Component } from 'react';
import { AppRegistry, StyleSheet, Text, View, Button } from 'react-native';

global.PaymentRequest = require('react-native-payments').PaymentRequest;
const ReactNativePaymentsVersion = require('react-native-payments/package.json')
  .version;

import Header from '../common/components/Header';

export default class BraintreeExample extends Component {
  constructor() {
    super();

    this.state = {
      text: null
    };
  }

  handlePress() {
    const supportedMethods = [
      {
        supportedMethods: ['apple-pay'],
        data: {
          merchantIdentifier: 'merchant.com.react-native-payments.naoufal',
          supportedNetworks: ['visa', 'mastercard'],
          countryCode: 'US',
          currencyCode: 'USD',
          paymentMethodTokenizationParameters: {
            parameters: {
              gateway: 'braintree',
              'braintree:tokenizationKey': 'sandbox_np7393pq_sh6czsvsq9nvjc3j'
            }
          }
        }
      }
    ];

    const details = {
      id: 'basic-example',
      displayItems: [
        {
          label: 'Movie Ticket',
          amount: { currency: 'USD', value: '15.00' }
        }
      ],
      total: {
        label: 'Merchant Name',
        amount: { currency: 'USD', value: '15.00' }
      }
    };

    const pr = new PaymentRequest(supportedMethods, details);

    pr
      .show()
      .then(paymentResponse => {
        this.setState({
          text: paymentResponse.details.paymentToken
        });

        paymentResponse.complete('success');
      })
      .catch(e => {
        pr.abort();

        this.setState({
          text: e.message
        });
      });
  }

  render() {
    return (
      <View style={styles.container}>
        <Header supHeadingText={ReactNativePaymentsVersion} />
        <View style={styles.content}>
          <Button
            title="Buy with Braintree"
            onPress={this.handlePress.bind(this)}
          />
          <Text>
            {this.state.text}
          </Text>
        </View>
      </View>
    );
  }
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    marginTop: 25,
    padding: 10
  },
  content: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center'
  }
});

AppRegistry.registerComponent('BraintreeExample', () => BraintreeExample);
