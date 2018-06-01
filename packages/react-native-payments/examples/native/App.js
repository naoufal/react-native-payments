// @flow

import * as React from 'react';
import { Text, View } from 'react-native';
import { ApplePayPaymentButton, type PKPaymentButtonType, type PKPaymentButtonStyle } from './ApplePayPaymentButton';

type Props = {};

type State = {
  enabled: boolean,
  type: PKPaymentButtonType,
  style: PKPaymentButtonStyle,
};

export class App extends React.Component<Props, State> {
  state = {
    type: 'donate',
    style: 'black',
  };

  onPress = () => {
    alert('Init payment request');
  };

  render() {
    return (
      <View
        style={{
          margin: 30,
        }}
      >
        <ApplePayPaymentButton
          onPress={this.onPress}
          buttonType={this.state.type}
          buttonStyle={this.state.style}
        />

        <View style={{ padding: 20 }}>
          <View style={{ marginVertical: 50 }}>
            <Text style={{ color: this.state.type === 'plain' ? 'red': 'black' }} onPress={() => this.setState({ type: 'plain' })}>plain</Text>
            <Text style={{ color: this.state.type === 'buy' ? 'red': 'black' }} onPress={() => this.setState({ type: 'buy' })}>buy</Text>
            <Text style={{ color: this.state.type === 'setUp' ? 'red': 'black' }} onPress={() => this.setState({ type: 'setUp' })}>setUp</Text>
            <Text style={{ color: this.state.type === 'inStore' ? 'red': 'black' }} onPress={() => this.setState({ type: 'inStore' })}>inStore</Text>
            <Text style={{ color: this.state.type === 'donate' ? 'red': 'black' }} onPress={() => this.setState({ type: 'donate' })}>donate</Text>
          </View>
          <View style={{ marginVertical: 50 }}>
            <Text style={{ color: this.state.style === 'white' ? 'red': 'black' }} onPress={() => this.setState({ style: 'white' })}>white</Text>
            <Text style={{ color: this.state.style === 'whiteOutline' ? 'red': 'black' }} onPress={() => this.setState({ style: 'whiteOutline' })}>whiteOutline</Text>
            <Text style={{ color: this.state.style === 'black' ? 'red': 'black' }} onPress={() => this.setState({ style: 'black' })}>black</Text>
          </View>
        </View>
      </View>
    );
  }
}
