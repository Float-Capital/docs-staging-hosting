// Generated by ReScript, PLEASE EDIT WITH CARE

import * as React from "react";
import * as Client from "./data/Client.js";
import * as Config from "./Config.js";
import * as MainLayout from "./layouts/MainLayout.js";
import * as Router from "next/router";
import * as RootProvider from "./libraries/RootProvider.js";
import * as Client$1 from "@apollo/client";
import * as StateChangeMonitor from "./libraries/StateChangeMonitor.js";

var PageComponent = {};

var defaultClient = Client.makeClient(Config.localhostGraphEndpoint, "http://localhost:8080/v1/graphql", undefined);

var context = React.createContext(defaultClient);

var provider = context.Provider;

function useApolloClient(param) {
  return React.useContext(context);
}

function App$ApolloContext$GraphQl(Props) {
  var children = Props.children;
  var client = React.useContext(context);
  return React.createElement(Client$1.ApolloProvider, {
              client: client,
              children: children
            });
}

var GraphQl = {
  make: App$ApolloContext$GraphQl
};

function App$ApolloContext$Provider(Props) {
  var client = Props.client;
  var children = Props.children;
  return React.createElement(provider, {
              value: client,
              children: children
            });
}

var Provider = {
  make: App$ApolloContext$Provider
};

function App$ApolloContext(Props) {
  var children = Props.children;
  return React.createElement(App$ApolloContext$Provider, {
              client: defaultClient,
              children: React.createElement(App$ApolloContext$GraphQl, {
                    children: children
                  })
            });
}

var ApolloContext = {
  context: context,
  provider: provider,
  useApolloClient: useApolloClient,
  GraphQl: GraphQl,
  Provider: Provider,
  make: App$ApolloContext
};

function $$default(props) {
  Router.useRouter();
  var content = React.createElement(props.Component, props.pageProps);
  return React.createElement(RootProvider.make, {
              children: React.createElement(App$ApolloContext, {
                    children: React.createElement(StateChangeMonitor.make, {
                          children: React.createElement(MainLayout.make, {
                                children: content
                              })
                        })
                  })
            });
}

export {
  PageComponent ,
  defaultClient ,
  ApolloContext ,
  $$default ,
  $$default as default,
  
}
/* defaultClient Not a pure module */
