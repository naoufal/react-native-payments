/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 * @flow
 */

import React, { Component } from 'react';
import {
  AppRegistry,
  StyleSheet,
  Text,
  View,
  TouchableHighlight
} from 'react-native';
import PaymentRequest from 'react-native-payments';

export default class example extends Component {
  componentDidMount() {
    const methodData = [{
      supportedMethods: ['apple-pay'],
      data: {
        merchantId: '12345'
      }
    }];
    const details = {
      id: 'native-payments-example',
      total: {
          label: 'Total',
          amount: { currency: 'USD', amount: '9.99' },
      }
    };

    this.paymentRequest = new PaymentRequest(methodData, details);
  }

  handlePaymentPress(e) {
    return alert();

    return this.paymentRequest.show()
        .then(paymentResponse => {
            const { paymentToken } = paymentResponse.details;

            // Charge payment token
            return fetch('...').then(res => res.json())
                .then(res => paymentResponse.complete('success'))
                .catch(err => paymentResponse.complete('fail'));
        })
        .catch(err => {
            alert('Something went wrong');
        });
  }

  render() {
    return (
      <View style={styles.container}>
        <TouchableHighlight
          style={styles.button}
          onPress={this.handlePaymentPress}
        >
          <Text style={styles.buttonText}>
            Pay with Payments
          </Text>
        </TouchableHighlight>
      </View>
    );
  }
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    backgroundColor: '#F5FCFF',
  },
  welcome: {
    fontSize: 20,
    textAlign: 'center',
    marginBottom: 10,
  },
  instructions: {
    textAlign: 'center',
    marginBottom: 200,
  },
  button: {
    borderRadius: 3,
    backgroundColor: '#000',
    overflow: 'hidden'
  },
  buttonText: {
    paddingVertical: 10,
    paddingHorizontal: 20,
    color: '#fff',
    fontSize: 18,
    textAlign: 'center'
  }
});

AppRegistry.registerComponent('example', () => example);
