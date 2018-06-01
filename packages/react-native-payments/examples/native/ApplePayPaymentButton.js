// @flow

import * as React from 'react';
import { NativeModules, requireNativeComponent } from 'react-native';

export type PKPaymentButtonType =
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

export type PKPaymentButtonStyle =
  //   A white button with black lettering (shown here against a gray background to ensure visibility).
  | 'white'
  //   A white button with black lettering and a black outline.
  | 'whiteOutline'
  //   A black button with white lettering.
  | 'black';

type Props = $Exact<{
  buttonStyle: PKPaymentButtonStyle,
  buttonType: PKPaymentButtonType,
  width?: number,
  height?: number,
  onPress: Function,
}>;

const RNTApplePayPaymentButton = requireNativeComponent(
  'ApplePayPaymentButton',
  null,
  { nativeOnly: { onPress: true } }
);

export class ApplePayPaymentButton extends React.Component<Props> {
  static defaultProps = {
    buttonStyle: 'black',
    buttonType: 'plain',
    height: 44,
  };

  render() {
    return (
      <RNTApplePayPaymentButton
        buttonStyle={this.props.buttonStyle}
        buttonType={this.props.buttonType}
        onPress={this.props.onPress}
        width={this.props.width}
        height={this.props.height}
      />
    );
  }
}
