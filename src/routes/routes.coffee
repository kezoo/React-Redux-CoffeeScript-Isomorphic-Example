React = require('react')
{IndexRoute, Route} = require('react-router')
{ App, Home, About, Examples, Todos, NotFound } = require('pages')

module.exports = () =>
  <Route path="/" component={App}>
    <IndexRoute component={Home}/>

    <Route path="about" component={About} />
    <Route path="examples" component={Examples} />
    <Route path="examples/todos" component={Todos} />

    <Route path="*" component={NotFound} status={404} />
  </Route>
