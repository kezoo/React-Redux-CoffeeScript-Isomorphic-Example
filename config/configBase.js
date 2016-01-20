require('babel/polyfill');
const path = require('path');

module.exports = Object.assign({
  env: process.env.NODE_ENV || 'development',
  host: process.env.HOST || 'localhost',
  serverPort: process.env.PORT || 3100,
  webpackPort: 5000,
  dirBase: path.resolve(__dirname, '../'),
  babelLoaderQuery: {
    stage: 0,
    optional: 'runtime',
    loose: 'all',
    plugins: [
      'react-transform'
    ],
    extra: {
      'react-transform': {
        transforms: [{
          transform: 'react-transform-hmr',
          imports: ['react'],
          locals: ['module']
        }]
      }
    }
  },
  app: {
    title: 'React Redux Example',
    description: 'React Redux Example',
    head: {
      titleTemplate: 'React Redux Example: %s',
      meta: [
        {name: 'description', content: 'React Redux Example'},
        {charset: 'utf-8'},
        {property: 'og:site_name', content: 'React Redux Example'},
        {property: 'og:locale', content: 'en_US'},
        {property: 'og:title', content: 'React Redux Example'},
        {property: 'og:description', content: ''},
        {property: 'og:site', content: ''},
        {property: 'og:creator', content: ''},
      ]
    }
  }
});
