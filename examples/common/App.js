import React from 'react';
import {
  View,
  Text,
  StyleSheet,
  Platform
} from 'react-primitives';

// TODO:
// - Look into how to clean this up
let Touchable;
let ScrollView;
if (Platform.OS === 'web') {
  ScrollView = View;
  Touchable = require('react-primitives').Touchable;
} else {
  ScrollView = require('react-native').ScrollView;
  Touchable = require('react-native').TouchableHighlight;
}

import {
  oneItem,
  twoItems,
  twoItemsPlusTax,
  requestPayerName,
  requestPayerPhone,
  requestPayerEmail,
  requestPayerAll,
  requestShippingDetails,
  staticShipping,
  dynamicShipping,
  noInternationalShipping
 } from './handlers';

const ORDER_SUMMARY_EXAMPLES = [{
  label: 'One Item',
  handlePress: oneItem
}, {
  label: 'Two Items',
  handlePress: twoItems
}, {
  label: 'Two Items + Tax',
  handlePress: twoItemsPlusTax
}];

const CONTACT_INFO_EXAMPLES = [{
  label: 'Request Payer Name',
  handlePress: requestPayerName
}, {
  label: 'Request Payer Phone',
  handlePress: requestPayerPhone
}, {
  label: 'Request Payer Email',
  handlePress: requestPayerEmail
}, {
  label: 'Request Payer Name, Phone & Email',
  handlePress: requestPayerAll
}];

const SHIPPING_ADDRESS_EXAMPLES = [{
  label: 'Static Shipping',
  handlePress: staticShipping
}, {
  label: 'Dynamic Shipping',
  handlePress: dynamicShipping
}, {
  label: 'No International Shipping',
  handlePress: noInternationalShipping
}];

const Header = () => (
    <View>
      <Text style={styles.supHeading}>
        Version {require('react-native-payments/package.json').version}
      </Text>
      <Text style={styles.heading}>
          React Native Payments
      </Text>
    </View>
);

const ExampleList = ({ examples }) => {
  return (
    <View>
      {examples.map(({ label, handlePress }) => (
        <Touchable
            key={label}
            style={styles.exampleLink}
            onPress={handlePress}
            underlayColor='#f0f4f7'
        >
            <Text
              style={[styles.exampleLinkLabel, !handlePress && {
                color: '#888'
              }]}
            >
              {label}
            </Text>
        </Touchable>
      ))}
    </View>
  );
};

const Content = () => (
    <View style={styles.content}>
      <Text style={styles.subHeading}>Order Summary Examples</Text>
      <ExampleList examples={ORDER_SUMMARY_EXAMPLES} />
      <Text style={styles.subHeading}>Contact Info Examples</Text>
      <ExampleList examples={CONTACT_INFO_EXAMPLES} />
      <Text style={styles.subHeading}>Shipping Address Examples</Text>
      <ExampleList examples={SHIPPING_ADDRESS_EXAMPLES} />
    </View>
);

export default () => (
    <ScrollView style={styles.container}>
      <Header />
      <Content />
    </ScrollView>
);

const baseTextStyles = {
    fontWeight: '700',
    letterSpacing: -0.5
};
const styles = StyleSheet.create({
  container: {
    marginTop: 25,
    padding: 10
  },
  supHeading: {
    ...baseTextStyles,
    fontSize: 11,
    fontWeight: '700',
    letterSpacing: -0.5,
    color: '#A8A8A8'
  },
  heading: {
    ...baseTextStyles,
    fontSize: 27
  },
  subHeading: {
    ...baseTextStyles,
    marginTop: 20,
    paddingVertical: 10,
    fontSize: 20
  },
  content: {
  },
  exampleLink: {
    paddingVertical: 10,
    borderTopWidth: 1,
    borderTopColor: '#D0D0D2'
  },
  exampleLinkLabel: {
    fontSize: 16,
    color: '#0070C9'
  }
});