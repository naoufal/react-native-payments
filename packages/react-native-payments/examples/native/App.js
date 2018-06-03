// @flow

import * as React from 'react';
import { Text, View } from 'react-native';
import {
  ApplePayPaymentButton,
  type PKPaymentButtonType,
  type PKPaymentButtonStyle,
} from './ApplePayPaymentButton';

type Props = {};

type State = {
  type: PKPaymentButtonType,
  style: PKPaymentButtonStyle,
};

export class App extends React.Component<Props, State> {
  state = {
    type: 'donate',
    type2: 'donate',
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
          buttonStyle={this.state.style}
          buttonType={this.state.type}
          onPress={this.onPress}
        />

        {/* <View style={{ width: 150, marginVertical: 50 }}>
          <ApplePayPaymentButton
            buttonStyle={this.state.style}
            buttonType={this.state.type}
            onPress={() => alert('2')}
          />
        </View> */}

        <View style={{ padding: 20 }}>
          <View style={{ marginVertical: 50 }}>
            <Text
              style={{ color: this.state.type === 'plain' ? 'red' : 'black' }}
              onPress={() => this.setState({ type: 'plain' })}
            >
              plain
            </Text>
            <Text
              style={{ color: this.state.type === 'buy' ? 'red' : 'black' }}
              onPress={() => this.setState({ type: 'buy' })}
            >
              buy
            </Text>
            <Text
              style={{ color: this.state.type === 'setUp' ? 'red' : 'black' }}
              onPress={() => this.setState({ type: 'setUp' })}
            >
              setUp
            </Text>
            <Text
              style={{ color: this.state.type === 'inStore' ? 'red' : 'black' }}
              onPress={() => this.setState({ type: 'inStore' })}
            >
              inStore
            </Text>
            <Text
              style={{ color: this.state.type === 'donate' ? 'red' : 'black' }}
              onPress={() => this.setState({ type: 'donate' })}
            >
              donate
            </Text>
          </View>
          <View style={{ marginVertical: 50 }}>
            <Text
              style={{ color: this.state.type2 === 'plain' ? 'red' : 'black' }}
              onPress={() => this.setState({ type2: 'plain' })}
            >
              plain
            </Text>
            <Text
              style={{ color: this.state.type2 === 'buy' ? 'red' : 'black' }}
              onPress={() => this.setState({ type2: 'buy' })}
            >
              buy
            </Text>
            <Text
              style={{ color: this.state.type2 === 'setUp' ? 'red' : 'black' }}
              onPress={() => this.setState({ type2: 'setUp' })}
            >
              setUp
            </Text>
            <Text
              style={{
                color: this.state.type2 === 'inStore' ? 'red' : 'black',
              }}
              onPress={() => this.setState({ type2: 'inStore' })}
            >
              inStore
            </Text>
            <Text
              style={{ color: this.state.type2 === 'donate' ? 'red' : 'black' }}
              onPress={() => this.setState({ type2: 'donate' })}
            >
              donate
            </Text>
          </View>
          <View style={{ marginVertical: 50 }}>
            <Text
              style={{ color: this.state.style === 'white' ? 'red' : 'black' }}
              onPress={() => this.setState({ style: 'white' })}
            >
              white
            </Text>
            <Text
              style={{
                color: this.state.style === 'whiteOutline' ? 'red' : 'black',
              }}
              onPress={() => this.setState({ style: 'whiteOutline' })}
            >
              whiteOutline
            </Text>
            <Text
              style={{ color: this.state.style === 'black' ? 'red' : 'black' }}
              onPress={() => this.setState({ style: 'black' })}
            >
              black
            </Text>
          </View>
        </View>
      </View>
    );
  }
}
