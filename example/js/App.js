import React from 'react'
import {
  View,
  Text,
  Touchable,
  StyleSheet
} from 'react-primitives';

import {
  displayItemAndTotal,
  requestPayerName,
  requestPayerPhone,
  requestPayerEmail,
  requestPayerAll,
  requestShippingDetails,
  handleShippingChanges
 } from './helpers';

const BASIC_EXAMPLES = [{
  label: 'Display Item + Total',
  handlePress: displayItemAndTotal
}, {
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
}, {
  label: 'Request Shipping Details',
  handlePress: requestShippingDetails
}];

const ADVANCED_EXAMPLES = [{
  label: 'Handle Shipping Changes',
  handlePress: handleShippingChanges
}, {
  label: 'Handle Shipping Changes with Promises',
  handlePress: null
}];

const Header = () => (
    <View>
      <Text style={styles.supHeading}>
          Version {require('../package.json').version}
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
      <Text style={styles.subHeading}>Basic Examples</Text>
      <ExampleList examples={BASIC_EXAMPLES} />
      <Text style={styles.subHeading}>Advanced Examples</Text>
      <ExampleList examples={ADVANCED_EXAMPLES} />
    </View>
);

export default () => (
    <View style={styles.container}>
      <Header />
      <Content />
    </View>
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
    borderTopWidth: 0.5,
    borderTopColor: '#D0D0D2'
  },
  exampleLinkLabel: {
    fontSize: 16,
    color: '#0070C9'
  }
});