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

export type ButtonType = PKPaymentButtonType;
export type ButtonStyle = PKPaymentButtonStyle;

type Props = $Exact<{
  buttonStyle: ButtonStyle,
  buttonType: ButtonType,
  width?: number,
  height?: number,
  onPress: Function,
}>;

const PKPaymentButton = requireNativeComponent('PKPaymentButton', null, {
  nativeOnly: { onPress: true },
});

export class ApplePayButton extends React.Component<Props> {
  static defaultProps = {
    buttonStyle: 'black',
    buttonType: 'plain',
    height: 44,
  };

  render() {
    return (
      <PKPaymentButton
        buttonStyle={this.props.buttonStyle}
        buttonType={this.props.buttonType}
        onPress={this.props.onPress}
        width={this.props.width}
        height={this.props.height}
      />
    );
  }
}
