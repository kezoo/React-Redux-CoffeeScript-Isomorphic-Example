import React from 'react';
import ReactDOM from 'react-dom';
import createHistory from 'history/lib/createBrowserHistory';
import useScroll from 'scroll-behavior/lib/useStandardScroll';
import {Provider} from 'react-redux';
import {reduxReactRouter, ReduxRouter} from 'redux-router';
import createStore from './stores/createStore';
import getRoutes from './routes/routes';
import makeRouteHooksSafe from './utils/makeRouteHooksSafe';

// https://github.com/rackt/scroll-behavior
const scrollableHistory = useScroll(createHistory);
const store = createStore(reduxReactRouter, makeRouteHooksSafe(getRoutes), scrollableHistory, window.__data);
const appID = document.getElementById('app');
const component = (
  <ReduxRouter routes={getRoutes(store)} />
);

ReactDOM.render(
  <Provider store={store} key="provider">
    {component}
  </Provider>,
  appID
);

window.React = React;

if (__DEVTOOLS__ && !window.devToolsExtension) {
  const DevTools = require('./pages/DevTools');
  ReactDOM.render(
    <Provider store={store} key="provider">
      <div>
        {component}
        <DevTools />
      </div>
    </Provider>,
    appID
  );
}
