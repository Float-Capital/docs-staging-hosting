// Generated by ReScript, PLEASE EDIT WITH CARE
'use strict';

var Css = require("bs-css-emotion/src/Css.js");
var CssJs = require("bs-css-emotion/src/CssJs.js");
var Curry = require("rescript/lib/js/curry.js");
var React = require("react");
var Button = require("../components/UI/Button.js");
var Globals = require("../libraries/Globals.js");
var Link = require("next/link").default;
var Caml_option = require("rescript/lib/js/caml_option.js");
var Router = require("next/router");
var RootProvider = require("../libraries/RootProvider.js");
var DisplayAddress = require("../components/UI/DisplayAddress.js");

function floatingMenuZoomStyle(shouldDisplay) {
  return CssJs.style([
              CssJs.position("fixed"),
              CssJs.top(CssJs.px(0)),
              CssJs.left(CssJs.px(0)),
              CssJs.width(CssJs.vw(100)),
              CssJs.height(CssJs.vh(100)),
              CssJs.visibility(shouldDisplay ? "visible" : "hidden"),
              CssJs.backgroundColor(CssJs.rgba(255, 255, 255, {
                        NAME: "num",
                        VAL: shouldDisplay ? 0.5 : 0
                      })),
              CssJs.zIndex(40),
              CssJs.transition(600, 0, CssJs.ease, "all"),
              CssJs.selector(".zoom-in-effect", [
                    CssJs.background(CssJs.rgba(59, 130, 250, {
                              NAME: "num",
                              VAL: 0.6
                            })),
                    CssJs.width(CssJs.vw(100)),
                    CssJs.height(CssJs.vh(100)),
                    CssJs.border(CssJs.px(1), "solid", CssJs.grey),
                    CssJs.display("flex"),
                    CssJs.flex("none"),
                    CssJs.alignItems("center"),
                    CssJs.justifyContent("center"),
                    CssJs.transform(shouldDisplay ? CssJs.scale(1, 1) : CssJs.scale(0, 0)),
                    CssJs.transition(300, 0, CssJs.ease, "all")
                  ])
            ]);
}

function hamburgerSvg(param) {
  return React.createElement("svg", {
              className: Curry._1(Css.style, {
                    hd: Css.transition(500, 0, Css.ease, "transform"),
                    tl: {
                      hd: Css.selector(":hover", {
                            hd: Css.transform(Css.rotate(Css.deg(180))),
                            tl: /* [] */0
                          }),
                      tl: /* [] */0
                    }
                  }),
              id: "Layer_1",
              height: "32px",
              width: "32px",
              fill: "#555555",
              version: "1.1"
            }, React.createElement("path", {
                  d: "M4,10h24c1.104,0,2-0.896,2-2s-0.896-2-2-2H4C2.896,6,2,6.896,2,8S2.896,10,4,10z M28,14H4c-1.104,0-2,0.896-2,2  s0.896,2,2,2h24c1.104,0,2-0.896,2-2S29.104,14,28,14z M28,22H4c-1.104,0-2,0.896-2,2s0.896,2,2,2h24c1.104,0,2-0.896,2-2  S29.104,22,28,22z"
                }));
}

function closeSvg(param) {
  return React.createElement("svg", {
              className: Curry._1(Css.style, {
                    hd: Css.transition(500, 0, Css.ease, "transform"),
                    tl: {
                      hd: Css.selector(":hover", {
                            hd: Css.transform(Css.rotate(Css.deg(180))),
                            tl: /* [] */0
                          }),
                      tl: /* [] */0
                    }
                  }),
              height: "32px",
              width: "32px",
              fill: "#222222",
              viewBox: "0 0 512 512"
            }, React.createElement("path", {
                  d: "M437.5,386.6L306.9,256l130.6-130.6c14.1-14.1,14.1-36.8,0-50.9c-14.1-14.1-36.8-14.1-50.9,0L256,205.1L125.4,74.5  c-14.1-14.1-36.8-14.1-50.9,0c-14.1,14.1-14.1,36.8,0,50.9L205.1,256L74.5,386.6c-14.1,14.1-14.1,36.8,0,50.9  c14.1,14.1,36.8,14.1,50.9,0L256,306.9l130.6,130.6c14.1,14.1,36.8,14.1,50.9,0C451.5,423.4,451.5,400.6,437.5,386.6z"
                }));
}

function Navigation(Props) {
  var match = React.useState(function () {
        return false;
      });
  var setIsOpen = match[1];
  var isOpen = match[0];
  var router = Router.useRouter();
  var optCurrentUser = RootProvider.useCurrentUser(undefined);
  var tmp;
  if (optCurrentUser !== undefined) {
    var currentUser = Caml_option.valFromOption(optCurrentUser);
    tmp = React.createElement(Link, {
          href: "/user/" + Globals.ethAdrToStr(currentUser),
          children: React.createElement("p", {
                className: "px-3 bg-white hover:bg-black hover:text-gray-200 text-base cursor-pointer"
              }, " 👤 ", React.createElement(DisplayAddress.make, {
                    address: Globals.ethAdrToStr(currentUser)
                  }))
        });
  } else {
    tmp = React.createElement(Button.Small.make, {
          onClick: (function (param) {
              router.push("/login?nextPath=" + router.asPath);
              
            }),
          children: "LOGIN"
        });
  }
  var tmp$1;
  if (optCurrentUser !== undefined) {
    var currentUser$1 = Caml_option.valFromOption(optCurrentUser);
    tmp$1 = React.createElement("p", {
          className: "px-3 bg-white text-black hover:bg-black hover:text-gray-200 text-base cursor-pointer text-3xl",
          onClick: (function (param) {
              router.push("/user/" + Globals.ethAdrToStr(currentUser$1));
              return Curry._1(setIsOpen, (function (param) {
                            return false;
                          }));
            })
        }, " 👤 ", React.createElement(DisplayAddress.make, {
              address: Globals.ethAdrToStr(currentUser$1)
            }));
  } else {
    tmp$1 = React.createElement(Button.Small.make, {
          onClick: (function (param) {
              router.push("/login?nextPath=" + router.asPath);
              return Curry._1(setIsOpen, (function (param) {
                            return false;
                          }));
            }),
          children: "LOGIN"
        });
  }
  return React.createElement(React.Fragment, undefined, React.createElement("nav", {
                  className: "p-2 h-12 flex justify-between items-center text-sm"
                }, React.createElement(Link, {
                      href: "/markets",
                      children: React.createElement("a", {
                            className: "flex items-center"
                          }, React.createElement("span", {
                                className: "text-xl text-green-800 ml-2 align-middle font-semibold"
                              }, React.createElement("div", {
                                    className: "logo-container"
                                  }, React.createElement("img", {
                                        className: "h-8 md:h-7 w-full md:w-auto",
                                        src: "/img/float-capital-logo.png"
                                      }))))
                    }), React.createElement("div", {
                      className: "hidden md:flex w-2/3 text-base items-center justify-end"
                    }, React.createElement(Link, {
                          href: "/markets",
                          children: React.createElement("a", {
                                className: "px-3 hover:bg-white"
                              }, "MARKETS")
                        }), React.createElement(Link, {
                          href: "/stake",
                          children: React.createElement("a", {
                                className: "px-3 hover:bg-white"
                              }, "STAKE🔥")
                        }), React.createElement(Link, {
                          href: "/dashboard",
                          children: React.createElement("a", {
                                className: "px-3 hover:bg-white"
                              }, "DASHBOARD")
                        }), React.createElement("a", {
                          className: "px-3 hover:bg-white",
                          href: "https://docs.float.capital",
                          target: "_blank"
                        }, "DOCS"), React.createElement("a", {
                          className: "px-3 hover:opacity-60",
                          href: "https://github.com/Float-Capital",
                          target: "_blank"
                        }, React.createElement("img", {
                              className: "h-5",
                              src: "/icons/github.svg"
                            })), tmp), React.createElement("div", {
                      className: "flex w-2/3 text-base items-center justify-end visible md:hidden"
                    }, React.createElement("div", {
                          className: "z-50 absolute top-0 right-0 p-3",
                          onClick: (function (param) {
                              return Curry._1(setIsOpen, (function (isOpen) {
                                            return !isOpen;
                                          }));
                            })
                        }, isOpen ? React.createElement(React.Fragment, undefined, closeSvg(undefined)) : hamburgerSvg(undefined)), React.createElement("div", {
                          className: floatingMenuZoomStyle(isOpen)
                        }, React.createElement("div", {
                              className: "zoom-in-effect flex flex-col text-3xl text-white"
                            }, React.createElement("div", {
                                  className: "px-3 bg-black m-2",
                                  onClick: (function (param) {
                                      router.push("/markets");
                                      return Curry._1(setIsOpen, (function (param) {
                                                    return false;
                                                  }));
                                    })
                                }, "MARKETS"), React.createElement("div", {
                                  className: "px-3 bg-black m-2",
                                  onClick: (function (param) {
                                      router.push("/stake");
                                      return Curry._1(setIsOpen, (function (param) {
                                                    return false;
                                                  }));
                                    })
                                }, "STAKE🔥"), React.createElement("div", {
                                  className: "px-3 bg-black m-2",
                                  onClick: (function (param) {
                                      router.push("/dashboard");
                                      return Curry._1(setIsOpen, (function (param) {
                                                    return false;
                                                  }));
                                    })
                                }, "DASHBOARD"), React.createElement("a", {
                                  className: "px-3 bg-black m-2",
                                  href: "https://docs.float.capital",
                                  target: "_blank",
                                  onClick: (function (param) {
                                      return Curry._1(setIsOpen, (function (param) {
                                                    return false;
                                                  }));
                                    })
                                }, "DOCS"), React.createElement("a", {
                                  className: "px-3 hover:opacity-60 m-4",
                                  href: "https://github.com/float-capital/float-contracts",
                                  target: "_blank",
                                  onClick: (function (param) {
                                      return Curry._1(setIsOpen, (function (param) {
                                                    return false;
                                                  }));
                                    })
                                }, React.createElement("img", {
                                      className: "h-10",
                                      src: "/icons/github.svg"
                                    })), tmp$1)))));
}

var Link$1;

var make = Navigation;

exports.floatingMenuZoomStyle = floatingMenuZoomStyle;
exports.hamburgerSvg = hamburgerSvg;
exports.closeSvg = closeSvg;
exports.Link = Link$1;
exports.make = make;
/* Css Not a pure module */
