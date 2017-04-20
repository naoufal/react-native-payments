import React, { Component } from 'react';
import {
  AppRegistry,
  StyleSheet,
  Text,
  View,
  TouchableHighlight,
  NativeModules
} from 'react-native';
import PaymentRequest from 'react-native-payments';

export default class example extends Component {
  constructor() {
    super();

    this.handlePaymentPress = this.handlePaymentPress.bind(this);
  }

  handlePaymentPress(e) {
    const methodData = [{
      supportedMethods: ['apple-pay'],
      data: {
        merchantIdentifier: 'merchant.com.react-native-payments.naoufal',
        supportedNetworks: ['visa', 'mastercard'],
        countryCode: 'US',
        currencyCode: 'USD'
      }
    }];
    const details = {
      id: 'native-payments-example',
      displayItems: [{
        label: 'Sub-total',
        amount: { currency: 'USD', value: '55.00' }
      }, {
        label: 'Sales Tax',
        amount: { currency: 'USD', value: '5.00' }
      }],
      total: {
          label: 'Total',
          amount: { currency: 'USD', value: '60.00' }
      }
    };

    const options = {
      requestShipping: true,
      requestPayerPhone: true,
      requestPayerEmail: true,
      requestPayerName: true,
      shippingType: 'shipping'
    };

    this.paymentRequest = new PaymentRequest(methodData, details, options);

    return this.paymentRequest.show()
      .then(paymentResponse => {

        // TODO:
        // - Charge the token or send it back to the Native Side
        return paymentResponse.complete('success');
      })
      .catch(e => this.paymentRequest.abort());
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
