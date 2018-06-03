// @flow

import * as React from 'react';
import { Text, View } from 'react-native';
import {
  ApplePayButton,
  type ButtonStyle,
  type ButtonType,
} from 'react-native-payments';

type Props = {};

type State = {
  style: ButtonStyle,
  style2: ButtonStyle,
  type: ButtonType,
};

export class App extends React.Component<Props, State> {
  state = {
    style: 'black',
    style2: 'whiteOutline',
    type: 'donate',
  };

  render() {
    return (
      <View
        style={{
          margin: 30,
        }}
      >
        <ApplePayButton
          key="first"
          buttonStyle={this.state.style}
          buttonType={this.state.type}
          onPress={() => alert('btn 1')}
        />

        <View style={{ height: 50 }} />

        <ApplePayButton
          key="second"
          buttonStyle={this.state.style2}
          buttonType={this.state.type}
          onPress={() => alert('btn 2')}
        />

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

          <View style={{ marginVertical: 50 }}>
            <Text
              style={{ color: this.state.style2 === 'white' ? 'red' : 'black' }}
              onPress={() => this.setState({ style2: 'white' })}
            >
              white
            </Text>
            <Text
              style={{
                color: this.state.style2 === 'whiteOutline' ? 'red' : 'black',
              }}
              onPress={() => this.setState({ style2: 'whiteOutline' })}
            >
              whiteOutline
            </Text>
            <Text
              style={{ color: this.state.style2 === 'black' ? 'red' : 'black' }}
              onPress={() => this.setState({ style2: 'black' })}
            >
              black
            </Text>
          </View>
        </View>
      </View>
    );
  }
}
