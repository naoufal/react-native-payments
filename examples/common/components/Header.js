import React, { Component } from 'react';
import { StyleSheet, Text, View } from 'react-native';

import { baseTextStyles } from '../styles';

const Header = ({ supHeadingText, headingText = 'React Native Payments' }) =>
  <View>
    {supHeadingText &&
      <Text style={styles.supHeading}>
        Version {supHeadingText}
      </Text>}
    <Text style={styles.heading}>
      {headingText}
    </Text>
  </View>;

const styles = StyleSheet.create({
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
  }
});

export default Header;
