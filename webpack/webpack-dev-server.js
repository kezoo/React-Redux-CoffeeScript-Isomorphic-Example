var Express = require('express');
var webpack = require('webpack');
var debug = require('debug')
var config = require('../config/configBase');
var webpackConfig = require('./dev.config');
var compiler = webpack(webpackConfig);

var host = config.host;
var port = config.webpackPort;
var serverOptions = {
  contentBase: 'http://' + host + ':' + port,
  quiet: true,
  noInfo: true,
  hot: true,
  inline: true,
  lazy: false,
  publicPath: webpackConfig.output.publicPath,
  headers: {'Access-Control-Allow-Origin': '*'},
  stats: {colors: true}
};

var app = new Express();
app.use(require('webpack-dev-middleware')(compiler, serverOptions));
app.use(require('webpack-hot-middleware')(compiler));
app.listen(port, function onAppListening(err) {
  debug('Webpack development server listening on port %s', port);
});
