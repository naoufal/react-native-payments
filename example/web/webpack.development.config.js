const webpack = require('webpack');
const baseWebpackConfig = require('./webpack.base.config.js');

module.exports = Object.assign({}, baseWebpackConfig, {
    devServer: {
        port: 8080,
        historyApiFallback: {
            index: './web/public/index.html'
        }
    },
    plugins: [
        new webpack.DefinePlugin({
            'process.env': {
                NODE_ENV: JSON.stringify('development'),
            },
        })
    ],
});