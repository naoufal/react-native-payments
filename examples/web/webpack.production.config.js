const webpack = require('webpack');
const baseWebpackConfig = require('./webpack.base.config.js');

module.exports = Object.assign({}, baseWebpackConfig, {
  plugins: [
    new webpack.DefinePlugin({
      __DEV__: false,
      'process.env': {
        NODE_ENV: JSON.stringify('production')
      }
    }),
    new webpack.optimize.UglifyJsPlugin({
      compress: {
        warnings: false
      }
    })
  ]
});
