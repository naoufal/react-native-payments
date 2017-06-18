const path = require('path');

module.exports = {
  entry: './examples/web/index.web.js',
  output: {
    path: path.resolve(__dirname, 'examples', 'web', 'public'),
    filename: 'bundle.js'
  },
  resolve: {
    alias: {
      'react-native-payments': path.resolve(__dirname)
    }
  },
  module: {
    rules: [
      {
        test: /\.js$/,
        exclude: /(node_modules|bower_components)/,
        use: {
          loader: 'babel-loader'
        }
      }
    ]
  }
}
