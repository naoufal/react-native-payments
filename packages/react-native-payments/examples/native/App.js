// @flow

import * as React from 'react';
import { Text, View } from 'react-native';
import { ApplePayPaymentButton } from './ApplePayPaymentButton';

type Props = {};

type State = {
  enabled: boolean,
};

export class App extends React.Component<Props, State> {
  state = {
    enabled: true,
  };

  onPress = () => {
    alert('Init payment request');
  };

  render() {
    return (
      <View
        style={{
          margin: 30,
          borderWidth: 1,
          borderColor: 'black',
        }}
      >
        <ApplePayPaymentButton
          enabled={this.state.enabled}
          onPress={this.onPress}
        />
        <View style={{ padding: 20 }}>
          <Text
            onPress={() =>
              this.setState(state => ({ enabled: !state.enabled }))}
          >
            {this.state.enabled ? 'Disable' : 'Enable'}
          </Text>
        </View>
      </View>
    );
  }
}
