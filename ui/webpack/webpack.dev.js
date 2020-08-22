const baseConfig = require('./webpack.base');
const { merge } = require('webpack-merge');
const ErrorOverlayPlugin = require('error-overlay-webpack-plugin');

console.log(baseConfig.output.path)

const devConfig = {
    mode: 'development',
    devServer: {
        host: '0.0.0.0',
        contentBase: baseConfig.output.path,
        port: 3031,
        historyApiFallback: true
    },
    module: {
      rules: [
        {
          enforce: 'pre',
          test: /\.js$/,
          exclude: /node_modules/,
          loader: 'eslint-loader',
          options: {
            fix: true
          }
        },
      ],
    },
    plugins: [
      new ErrorOverlayPlugin()
    ],
    devtool: 'inline-source-map'
}

module.exports = merge(baseConfig, devConfig)
