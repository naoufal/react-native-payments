// @flow

import * as React from 'react';
import { Text, View } from 'react-native';
import { ApplePayButton } from './ApplePayButton';

type Props = {};

type State = {
  enabled: boolean,
};

export class App extends React.Component<Props, State> {
  state = {
    enabled: true,
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
        <ApplePayButton enabled={this.state.enabled} />
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
