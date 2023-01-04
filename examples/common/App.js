import React from 'react';
import { View, Text, StyleSheet, Platform } from 'react-primitives';

// TODO:
// - Look into how to clean this up
let Touchable;
let ScrollView;
if (Platform.OS === 'web') {
  Touchable = require('react-primitives').Touchable;
  ScrollView = View;
} else {
  Touchable = require('react-native').TouchableHighlight;
  ScrollView = require('react-native').ScrollView;
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
  noInternationalShipping,
  errorNoTotal,
  errorNegativeTotal,
  errorInvalidTotalAmount,
  errorInvalidDisplayItemAmount,
  errorNoShippingOptions,
  errorInvalidShippingOptionsAmount,
  errorDuplicateShippingOptionsId,
  errorGatewayNotSupported
} from './handlers';

import Header from './components/Header';
import { baseTextStyles } from './styles';

const ORDER_SUMMARY_EXAMPLES = [
  {
    label: 'One Item',
    handlePress: oneItem
  },
  {
    label: 'Two Items',
    handlePress: twoItems
  },
  {
    label: 'Two Items + Tax',
    handlePress: twoItemsPlusTax
  }
];

const CONTACT_INFO_EXAMPLES = [
  {
    label: 'Request Payer Name',
    handlePress: requestPayerName
  },
  {
    label: 'Request Payer Phone',
    handlePress: requestPayerPhone
  },
  {
    label: 'Request Payer Email',
    handlePress: requestPayerEmail
  },
  {
    label: 'Request Payer Name, Phone & Email',
    handlePress: requestPayerAll
  }
];

const SHIPPING_ADDRESS_EXAMPLES = [
  {
    label: 'Static Shipping',
    handlePress: staticShipping
  },
  {
    label: 'Dynamic Shipping',
    handlePress: dynamicShipping
  },
  {
    label: 'No International Shipping',
    handlePress: noInternationalShipping
  }
];

const ERROR_EXAMPLES = [
  {
    label: 'No Total',
    handlePress: errorNoTotal
  },
  {
    label: 'Negative Total',
    handlePress: errorNegativeTotal
  },
  {
    label: 'Invalid Total Amount',
    handlePress: errorInvalidTotalAmount
  },
  {
    label: 'Invalid Display Item Amount',
    handlePress: errorInvalidDisplayItemAmount
  },
  {
    label: 'No Shipping Options',
    handlePress: errorNoShippingOptions
  },
  {
    label: 'Invalid Shipping Options Amount',
    handlePress: errorInvalidShippingOptionsAmount
  },
  {
    label: 'Duplicate Shipping Option Id',
    handlePress: errorDuplicateShippingOptionsId
  },
  {
    label: 'Gateway Not Supported (React Native Only)',
    handlePress: errorGatewayNotSupported
  }
];

const ExampleList = ({ examples }) => {
  return (
    <View>
      {examples.map(({ label, handlePress }) =>
        <Touchable
          key={label}
          style={styles.exampleLink}
          onPress={handlePress}
          underlayColor="#f0f4f7"
        >
          <Text
            style={[
              styles.exampleLinkLabel,
              !handlePress && {
                color: '#888'
              }
            ]}
          >
            {label}
          </Text>
        </Touchable>
      )}
    </View>
  );
};

const Content = () =>
  <View style={styles.content}>
    <Text style={styles.subHeading}>Order Summary Examples</Text>
    <ExampleList examples={ORDER_SUMMARY_EXAMPLES} />
    <Text style={styles.subHeading}>Contact Info Examples</Text>
    <ExampleList examples={CONTACT_INFO_EXAMPLES} />
    <Text style={styles.subHeading}>Shipping Address Examples</Text>
    <ExampleList examples={SHIPPING_ADDRESS_EXAMPLES} />
    {__DEV__ && <ErrorExamples />}
  </View>;

const ErrorExamples = () =>
  <View>
    <Text style={styles.subHeading}>Error Examples</Text>
    <ExampleList examples={ERROR_EXAMPLES} />
  </View>;
const ReactNativePaymentsVersion = require('react-native-payments/package.json')
  .version;

export default () =>
  <ScrollView style={styles.container}>
    <Header supHeadingText={ReactNativePaymentsVersion} />
    <Content />
  </ScrollView>;

const styles = StyleSheet.create({
  container: {
    marginTop: 25,
    padding: 10
  },
  subHeading: {
    ...baseTextStyles,
    marginTop: 20,
    paddingVertical: 10,
    fontSize: 20
  },
  content: {},
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
