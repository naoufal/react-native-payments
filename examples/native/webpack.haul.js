const path = require('path');

module.exports = ({ platform }, defaults) => ({
  entry: `./index.${platform}.js`,
  resolve: {
    ...defaults.resolve,
    modules: [
      path.resolve(__dirname, 'node_modules'),
      path.resolve(__dirname, '../../node_modules')
    ],
    alias: {
      'react-primitives': 'react-native',
      'react-native-payments': '../..'
    }
  }
});
