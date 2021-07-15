// Generated by ReScript, PLEASE EDIT WITH CARE
'use strict';

var Next = require("../../bindings/Next.js");
var Curry = require("rescript/lib/js/curry.js");
var React = require("react");
var KeyPress = require("../../utils/KeyPress.js");
var Link = require("next/link").default;
var Belt_Array = require("rescript/lib/js/belt_Array.js");
var Belt_Option = require("rescript/lib/js/belt_Option.js");
var Router = require("next/router");

function makeDefaultHighlightLandingNav(length) {
  var defaultFalseArray = Belt_Array.make(length, false);
  Belt_Array.set(defaultFalseArray, 0, true);
  return defaultFalseArray;
}

function highlightLandingNavArray(length, index) {
  var resetNavs = Belt_Array.make(length, false);
  Belt_Array.set(resetNavs, index, true);
  return resetNavs;
}

function highlightMove(navs, up) {
  var currentHighlightIndex = navs.indexOf(true);
  var newIndexPosition = up ? currentHighlightIndex - 1 | 0 : currentHighlightIndex + 1 | 0;
  var navsLength = navs.length;
  if (!(newIndexPosition >= 0 && newIndexPosition < navsLength)) {
    return navs;
  }
  var resetNavs = Belt_Array.make(navsLength, false);
  Belt_Array.set(resetNavs, newIndexPosition, true);
  return resetNavs;
}

function LandingNav(Props) {
  var router = Router.useRouter();
  var landingNav = [
    {
      title: "App",
      link: "app/markets"
    },
    {
      title: "What is Float?",
      link: "#what-is-float"
    },
    {
      title: "Roadmap",
      link: "#roadmap"
    },
    {
      title: "Governance",
      link: "#governance"
    },
    {
      title: "Security",
      link: "#security"
    }
  ];
  var match = React.useState(function () {
        return makeDefaultHighlightLandingNav(landingNav.length);
      });
  var setShow = match[1];
  var show = match[0];
  var enterClicked = KeyPress.useKeyPress("Enter");
  var upClicked = KeyPress.useKeyPress("ArrowUp");
  var downClicked = KeyPress.useKeyPress("ArrowDown");
  React.useEffect((function () {
          if (enterClicked === true) {
            var currentHighlightIndex = show.indexOf(true);
            var sectionLink = Belt_Option.getWithDefault(Belt_Array.get(landingNav, currentHighlightIndex), {
                  title: "",
                  link: ""
                }).link;
            Next.Router.pushShallow(router, "/" + sectionLink);
          }
          
        }), [enterClicked]);
  React.useEffect((function () {
          if (upClicked === true) {
            Curry._1(setShow, (function (param) {
                    return highlightMove(show, true);
                  }));
          }
          
        }), [upClicked]);
  React.useEffect((function () {
          if (downClicked === true) {
            Curry._1(setShow, (function (param) {
                    return highlightMove(show, false);
                  }));
          }
          
        }), [downClicked]);
  return React.createElement("nav", {
              className: "text-xl md:text-3xl font-vt323"
            }, React.createElement("div", {
                  className: "mx-auto custom-cursor"
                }, Belt_Array.mapWithIndex(landingNav, (function (index, nav) {
                        return React.createElement("div", {
                                    key: nav.link,
                                    id: "landing-nav-item-" + String(index)
                                  }, React.createElement(Link, {
                                        href: nav.link,
                                        children: React.createElement("div", {
                                              className: "flex items-center hover:bg-white " + (
                                                Belt_Option.getWithDefault(Belt_Array.get(show, index), false) ? "bg-white" : ""
                                              ),
                                              onMouseOver: (function (param) {
                                                  return Curry._1(setShow, (function (param) {
                                                                return highlightLandingNavArray(landingNav.length, index);
                                                              }));
                                                })
                                            }, React.createElement("span", {
                                                  className: "text-2xl animate-pulse font-bold  ml-2"
                                                }, Belt_Option.getWithDefault(Belt_Array.get(show, index), false) ? ">" : "\xa0"), React.createElement("a", {
                                                  className: "px-3"
                                                }, nav.title))
                                      }));
                      }))));
}

var Link$1;

var make = LandingNav;

exports.Link = Link$1;
exports.makeDefaultHighlightLandingNav = makeDefaultHighlightLandingNav;
exports.highlightLandingNavArray = highlightLandingNavArray;
exports.highlightMove = highlightMove;
exports.make = make;
/* react Not a pure module */
