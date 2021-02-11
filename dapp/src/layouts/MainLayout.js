// Generated by ReScript, PLEASE EDIT WITH CARE

import * as React from "react";
import * as Ethers from "../ethereum/Ethers.js";
import Link from "next/link";
import * as Caml_option from "bs-platform/lib/es6/caml_option.js";
import * as Router from "next/router";
import * as RootProvider from "../libraries/RootProvider.js";
import * as DisplayAddress from "../components/UI/DisplayAddress.js";

function MainLayout$Navigation(Props) {
  var router = Router.useRouter();
  var optCurrentUser = RootProvider.useCurrentUser(undefined);
  return React.createElement("nav", {
              className: "p-2 h-12 flex justify-between items-center text-sm"
            }, React.createElement(Link, {
                  href: "/",
                  children: React.createElement("a", {
                        className: "flex items-center w-1/3"
                      }, React.createElement("span", {
                            className: "text-xl text-green-800 ml-2 align-middle font-semibold"
                          }, React.createElement("div", {
                                className: "logo-container"
                              }, React.createElement("img", {
                                    className: "logo-text",
                                    src: "/img/float-capital-logo.png"
                                  }))))
                }), React.createElement("div", {
                  className: "flex w-2/3 text-lg items-center justify-end"
                }, React.createElement(Link, {
                      href: "/dapp",
                      children: React.createElement("a", {
                            className: "px-3"
                          }, "APP")
                    }), React.createElement(Link, {
                      href: "/dashboard",
                      children: React.createElement("a", {
                            className: "px-3"
                          }, "DASHBOARD")
                    }), React.createElement(Link, {
                      href: "/admin",
                      children: React.createElement("a", {
                            className: "px-3"
                          }, "ADMIN")
                    }), React.createElement("a", {
                      className: "px-3",
                      href: "https://docs.float.capital",
                      target: "_blank"
                    }, "DOCS"), React.createElement("a", {
                      className: "px-3",
                      href: "https://github.com/avolabs-io/longshort",
                      target: "_blank"
                    }, React.createElement("img", {
                          className: "h-5",
                          src: "/icons/github.svg"
                        })), optCurrentUser !== undefined ? React.createElement("p", {
                        className: "px-3"
                      }, React.createElement(DisplayAddress.make, {
                            address: Ethers.Utils.toString(Caml_option.valFromOption(optCurrentUser))
                          })) : React.createElement("button", {
                        className: "px-3",
                        onClick: (function (param) {
                            router.push("/login?nextPath=" + router.asPath);
                            
                          })
                      }, "login")));
}

var Navigation = {
  make: MainLayout$Navigation
};

function MainLayout(Props) {
  var children = Props.children;
  return React.createElement("div", {
              className: "flex lg:justify-center"
            }, React.createElement("div", {
                  className: "max-w-5xl w-full lg:w-3/4 text-gray-900 font-base"
                }, React.createElement(MainLayout$Navigation, {}), React.createElement("main", {
                      className: "mt-4 mx-4"
                    }, children)));
}

var Link$1;

var make = MainLayout;

export {
  Link$1 as Link,
  Navigation ,
  make ,
  
}
/* react Not a pure module */
