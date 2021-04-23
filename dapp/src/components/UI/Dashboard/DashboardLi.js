// Generated by ReScript, PLEASE EDIT WITH CARE

import * as React from "react";
import * as Belt_Option from "rescript/lib/es6/belt_Option.js";
import * as Caml_option from "rescript/lib/es6/caml_option.js";

function DashboardLi$OptionallyIntoLink(Props) {
  var link = Props.link;
  var children = Props.children;
  return Belt_Option.mapWithDefault(link, children, (function (link) {
                return React.createElement("a", {
                            href: link
                          }, children);
              }));
}

var OptionallyIntoLink = {
  make: DashboardLi$OptionallyIntoLink
};

function createDashboardLiProps(suffixOpt, prefix, value, link, param) {
  var suffix = suffixOpt !== undefined ? Caml_option.valFromOption(suffixOpt) : null;
  return {
          prefix: prefix,
          value: value,
          suffix: suffix,
          link: link
        };
}

var Props = {
  createDashboardLiProps: createDashboardLiProps
};

function DashboardLi(Props) {
  var prefix = Props.prefix;
  var value = Props.value;
  var first = Props.first;
  var suffix = Props.suffix;
  var linkOpt = Props.link;
  var link = linkOpt !== undefined ? Caml_option.valFromOption(linkOpt) : undefined;
  return React.createElement(DashboardLi$OptionallyIntoLink, {
              link: link,
              children: React.createElement("li", {
                    className: first ? "" : "pt-2"
                  }, React.createElement("span", {
                        className: "text-sm mr-2"
                      }, prefix), React.createElement("span", {
                        className: "text-md"
                      }, value, suffix))
            });
}

var make = DashboardLi;

export {
  OptionallyIntoLink ,
  Props ,
  make ,
  
}
/* react Not a pure module */
