const { merge } = require('webpack-merge')

const baseConfig = require('./webpack.base')

const productionConfig = {
  mode: 'production'
}

module.exports = merge(baseConfig, productionConfig);
