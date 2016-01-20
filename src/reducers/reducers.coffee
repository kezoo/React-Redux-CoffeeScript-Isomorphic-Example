{ combineReducers } = require('redux')
{ routerStateReducer } = require('redux-router')
todos = require('./todosReducer')

module.exports = combineReducers({
  router: routerStateReducer
  todos
})
