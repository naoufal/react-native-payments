// @flow

import * as React from 'react';
import { Text, View } from 'react-native';
import { ApplePayButton } from './ApplePayButton';

export function App() {
  return (
    <View style={{ margin: 30, borderWidth: 1, borderColor: 'black' }}>
      <ApplePayButton />
    </View>
  );
}
