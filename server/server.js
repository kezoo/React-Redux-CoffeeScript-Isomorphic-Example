import Express from 'express';
import React from 'react';
import ReactDOM from 'react-dom/server';
import favicon from 'serve-favicon';
import compression from 'compression';
import httpProxy from 'http-proxy';
import path from 'path';
import http from 'http';
import debug from 'debug';
import {ReduxRouter} from 'redux-router';
import createHistory from 'history/lib/createMemoryHistory';
import {reduxReactRouter, match} from 'redux-router/server';
import {Provider} from 'react-redux';
import qs from 'query-string';

import config from '../config/configBase'
import getRoutes from '../src/routes/routes';
import getStatusFromRoutes from '../src/utils/getStatusFromRoutes';
import createStore from '../src/stores/createStore';
import Html from '../src/components/Html';

const app = new Express();
const server = new http.Server(app);

app.use(compression());
app.use(favicon(path.join(__dirname, '..', 'static', 'favicon.ico')));
app.use(Express.static(path.join(__dirname, '..', 'static')));

app.use((req, res) => {
  if (__DEVELOPMENT__) {
    webpackIsomorphicTools.refresh();
  }

  const store = createStore(reduxReactRouter, getRoutes, createHistory);

  function hydrateOnClient() {
    res.send('<!doctype html>\n' +
      ReactDOM.renderToString(<Html assets={webpackIsomorphicTools.assets()} store={store}/>));
  }

  if (__DISABLE_SSR__) {
    hydrateOnClient();
    return;
  }

  store.dispatch(match(req.originalUrl, (error, redirectLocation, routerState) => {
    var catchIt = false;
    if (error) {
      catchIt = true;
      res.status(500);
      hydrateOnClient();
    }
    if (!routerState) {
      catchIt = true;
      res.status(500);
      hydrateOnClient();
    }
    if (redirectLocation) {
      catchIt = true;
      res.redirect(redirectLocation.pathname + redirectLocation.search);
    }
    if (!catchIt) {
      // Workaround redux-router query string issue:
      // https://github.com/rackt/redux-router/issues/106
      if (routerState.location.search && !routerState.location.query) {
        routerState.location.query = qs.parse(routerState.location.search);
      }

      const component = (
        <Provider store={store} key="provider">
          <ReduxRouter/>
        </Provider>
      );
      const status = getStatusFromRoutes(routerState.routes);
      if (status) {
        res.status(status);
      }
      res.send('<!doctype html>\n' +
        ReactDOM.renderToString(<Html assets={webpackIsomorphicTools.assets()} component={component} store={store}/>));
    }
  }));
});

server.listen(config.serverPort, (err) => {
  debug('Listening on port ' + config.serverPort)
});
