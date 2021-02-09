// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Misc from "./libraries/Misc.js";
import * as React from "react";
import * as MainLayout from "./layouts/MainLayout.js";
import * as Router from "next/router";
import * as ApolloClient from "rescript-apollo-client/src/ApolloClient.js";
import * as RootProvider from "./libraries/RootProvider.js";
import * as Client from "@apollo/client";
import * as SwrSyncStorage from "swr-sync-storage";
import * as ApolloClient__Cache_InMemory_InMemoryCache from "rescript-apollo-client/src/@apollo/client/cache/inmemory/ApolloClient__Cache_InMemory_InMemoryCache.js";

Misc.onlyExecuteClientSide(function (prim) {
      SwrSyncStorage.syncWithSessionStorage();
      
    });

function App$GraphQl(Props) {
  var children = Props.children;
  var networkId = RootProvider.useChainId(undefined);
  var client = React.useMemo((function () {
          var uriLink = networkId !== undefined && networkId !== 5 && networkId !== 97 && networkId === 321 ? "goerli" : "https://api.thegraph.com/subgraphs/name/avolabs-io/float-capital-goerli";
          return ApolloClient.make(uriLink, undefined, undefined, undefined, ApolloClient__Cache_InMemory_InMemoryCache.make(undefined, undefined, undefined, undefined, undefined, undefined), undefined, undefined, true, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined);
        }), [networkId]);
  return React.createElement(Client.ApolloProvider, {
              client: client,
              children: children
            });
}

function $$default(props) {
  var router = Router.useRouter();
  var content = React.createElement(props.Component, props.pageProps);
  var match = router.route;
  var tmp = match === "/examples" ? React.createElement(MainLayout.make, {
          children: null
        }, React.createElement("h1", {
              className: "font-bold"
            }, "Examples Section"), React.createElement("div", undefined, content)) : React.createElement(MainLayout.make, {
          children: content
        });
  return React.createElement(RootProvider.make, {
              children: React.createElement(App$GraphQl, {
                    children: tmp
                  })
            });
}

export {
  $$default ,
  $$default as default,
  
}
/*  Not a pure module */
