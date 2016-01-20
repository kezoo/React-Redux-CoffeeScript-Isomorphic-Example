React = require('react')
Helmet = require('react-helmet')
{ pushState } = require('redux-router')
config = require('../../config/configBase')
if __CLIENT__ then require('../styles/index.scss')

class App extends React.Component
  propTypes =
    children: React.PropTypes.object.isRequired,
    user: React.PropTypes.object,
    pushState: React.PropTypes.func.isRequired

  contextTypes =
    store: React.PropTypes.object.isRequired

  render: ->
    <div>
      <Helmet {...config.app.head}/>
      <a href="/">
        Home
      </a>
      <a href="/about">
        About
      </a>
      <a href="/examples">
        Examples
      </a>

      <div>
        {this.props.children}
      </div>
    </div>

module.exports = App
