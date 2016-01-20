import { createStore as _createStore, applyMiddleware, compose } from 'redux';

export default function createStore(reduxReactRouter, getRoutes, createHistory, data) {
  const middleware = [];

  let finalCreateStore;
  if (__DEVELOPMENT__ && __CLIENT__ && __DEVTOOLS__) {
    const { persistState } = require('redux-devtools');
    const DevTools = require('../pages/DevTools');
    finalCreateStore = compose(
      applyMiddleware(...middleware),
      window.devToolsExtension ? window.devToolsExtension() : DevTools.instrument(),
      persistState(window.location.href.match(/[?&]debug_session=([^&]+)\b/))
    )(_createStore);
  } else {
    finalCreateStore = applyMiddleware(...middleware)(_createStore);
  }

  finalCreateStore = reduxReactRouter({ getRoutes, createHistory })(finalCreateStore);

  const reducer = require('../reducers/reducers');
  const store = finalCreateStore(reducer, data);

  if (__DEVELOPMENT__ && module.hot) {
    module.hot.accept('../reducers/reducers', () => {
      store.replaceReducer(require('../reducers/reducers'));
    });
  }

  return store;
}
