// @flow

import * as React from 'react';
import { NativeModules, requireNativeComponent, Text } from 'react-native';

type Props = {
  height: number,
};

const ApplePayPaymentButton = requireNativeComponent(
  'ApplePayPaymentButton',
  null
);

export class ApplePayButton extends React.Component<Props> {
  static defaultProps = {
    height: 44,
  };

  render() {
    return <ApplePayPaymentButton style={{ height: this.props.height }} />;
  }
}
