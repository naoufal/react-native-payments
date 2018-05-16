// @flow

import * as React from 'react';
import { NativeModules, requireNativeComponent } from 'react-native';

type PKPaymentButtonType =
  // A button with the Apple Pay logo only.
  | 'plain'
  // A button with the text “Buy with” and the Apple Pay logo.
  | 'buy'
  // A button prompting the user to set up a card.
  | 'setUp'
  // A button with the text “Pay with” and the Apple Pay logo.
  | 'inStore'
  // A button with the text "Donate with" and the Apple Pay logo.
  | 'donate';

type PKPaymentButtonStyle =
  //   A white button with black lettering (shown here against a gray background to ensure visibility).
  | 'white'
  //   A white button with black lettering and a black outline.
  | 'whiteOutline'
  //   A black button with white lettering.
  | 'black';

type Props = {
  height: number,
  onPress?: Function,
  style: PKPaymentButtonStyle,
  type: PKPaymentButtonType,
};

const RNTApplePayPaymentButton = requireNativeComponent(
  'ApplePayPaymentButton',
  null,
  { nativeOnly: { onPress: true } }
);

export class ApplePayPaymentButton extends React.Component<Props> {
  static defaultProps = {
    height: 88,
    style: 'black',
    type: 'plain',
  };

  render() {
    return (
      <RNTApplePayPaymentButton
        {...this.props}
        height={this.props.enabled ? 44 : 88}
      />
    );
  }
}
