// @flow

import * as React from 'react';
import { NativeModules, requireNativeComponent, Text } from 'react-native';

const ApplePayPaymentButton = requireNativeComponent(
  'ApplePayPaymentButton',
  null
);

export class ApplePayButton extends React.Component<Props> {
  render() {
    return (
      <ApplePayPaymentButton style={{ height: 50, backgroundColor: 'red' }} />
    );
  }
}
